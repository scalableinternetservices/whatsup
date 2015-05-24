class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  include UsersHelper

  before_action :check_log_in

  private
  
  def check_log_in
    if !logged_in?
      redirect_to action: 'new', controller: 'users'
    end
  end

end
