module ControllerMacros
  def login_user
    let :user { FactoryGirl.create(:user) }
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
end