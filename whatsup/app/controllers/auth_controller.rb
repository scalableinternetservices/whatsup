class AuthController < ApplicationController
  def signup
    @user = User.new
  end

  def login
  end
end
