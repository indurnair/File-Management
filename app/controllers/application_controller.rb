class ApplicationController < ActionController::Base
  protect_from_forgery

  def check_banned_user
    if current_user and !current_user.active
      flash[:notice] = 'Your Account is banned. Please contact administrator'
      redirect_to root_url
    end
  end

  rescue_from CanCan::AccessDenied do |exception|

   flash[:notice] = "Access denied!"
   redirect_to root_url
    end

    private

end

