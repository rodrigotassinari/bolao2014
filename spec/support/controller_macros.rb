module ControllerMacros

  def login_user(user)
    controller.stub(:current_user).and_return(user)
  end

end

RSpec.configure do |config|
  config.include ControllerMacros, :type => :controller
end
