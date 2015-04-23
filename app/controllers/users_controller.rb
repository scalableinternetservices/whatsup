class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(article_params)
    if !@user.save
      render :template => 'users/new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    def article_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
