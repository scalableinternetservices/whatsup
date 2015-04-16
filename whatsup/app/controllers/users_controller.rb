class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(article_params)
    if @user.save
      #
    else
      render :template => 'auth/signup'
    end
  end

  private
    def article_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
