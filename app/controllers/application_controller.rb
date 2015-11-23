class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # Sets the current user in the controller we can find a matching user from the
  # session information. Nil otherwise.
  # @return User
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


  # We'll need a way to access the current_user from within the templates.
  helper_method :current_user

end
