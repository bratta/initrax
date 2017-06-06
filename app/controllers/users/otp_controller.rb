class Users::OtpController < ApplicationController
  before_action :authenticate_user!
  layout 'devise'

  def index
    @user = current_user
    @show_qr = session[:new_qrcode]
  end

  def update
    @user = current_user
    original_otp_status = @user.otp_required_for_login

    @user.update_attributes otp_params

    if (original_otp_status != @user.otp_required_for_login)
      if @user.otp_required_for_login
        @user.otp_secret = User.generate_otp_secret
        session[:new_qrcode] = true
      else
        @user.otp_secret = nil
        session[:new_qrcode] = nil
      end
      @user.save!
    else
      session[:new_qrcode] = nil
    end

    redirect_to users_otp_index_path
  end

  def otp_params
    params.require(:user).permit(:otp_required_for_login)
  end

  def qrcode
    raise ActionController::RoutingError.new('Not Found') if !session[:new_qrcode]
    generated_code = generate_qrcode_for(current_user)
    send_data generated_code.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 128,
      border_modules: 4,
      module_px_size: 6,
      file: nil
    ), filename: "qrcode.png", type: "image/png", disposition: "inline"
    session[:new_qrcode] = false
  end

  def backup_codes
    if current_user.otp_required_for_login
      @backup_codes = current_user.generate_otp_backup_codes!
      current_user.save!
    end
  end

  private

  def generate_qrcode_for(user)
    issuer = "Initrax"
    label = "#{issuer}:#{user.email}"
    provisioning_uri = user.otp_provisioning_uri(label, issuer: issuer)
    RQRCode::QRCode.new(provisioning_uri)
  end
end
