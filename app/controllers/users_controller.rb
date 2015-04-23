class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(article_params)
    if !@user.save
      render :template => 'users/new'
    else
      log_in @user
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def login
    @user = User.find_by(email: params[:session][:email])

    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      render 'show'
    else
      @user = User.new
      render :template => 'users/new'
    end
  end

  def logout
    @user = User.new
    log_out
    render :template => 'users/new'
  end

  private
    def article_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
