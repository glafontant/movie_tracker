class ApplicationController < ActionController::Base
  add_flash_types(:danger)

  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def require_signin
      unless current_user
        redirect_to new_session_url, alert: "Please sign in first!"
        session[:intended_url] = request.url
      end
    end

    def current_user?(user)
      current_user == user
    end
    helper_method :current_user?

    def current_admin_user?
      current_user && current_user.admin?
    end
    helper_method :current_admin_user?

    def require_admin
      redirect_to root_url, alert: "You are not authorized!" unless current_admin_user?
    end
end
