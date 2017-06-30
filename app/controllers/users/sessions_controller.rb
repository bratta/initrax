# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def pre_otp
      user = User.find_by pre_otp_params
      @otp_ok = user && user.otp_required_for_login
      respond_to do |format|
        format.js { @otp = user.current_otp if @otp_ok }
      end
    end

    private

    def pre_otp_params
      params.require(:user).permit(:email)
    end
  end
end
