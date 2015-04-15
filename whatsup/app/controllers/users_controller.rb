class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(article_params)
  end

  private
    def article_params
      params.require(:user).permit(:user, :email, :password, :password_confirmation)
    end
end
