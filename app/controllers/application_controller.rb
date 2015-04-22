class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private
  
  def current_user 
    User.find(session[:user_id]) #assumes that the logged in user ID is stored in session[:user_id] 
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = 123 #default user ID for now
  end
end
