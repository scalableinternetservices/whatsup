class UsersController < ApplicationController

  skip_before_action :check_log_in, only: [:new, :create, :login]

  def new
    if logged_in?
      @user = current_user
      redirect_to action: 'show'
    end
  end

  def create
    @user = User.new(article_params)
    if !@user.save
      render :action => :new
    else
      log_in @user
    end
  end

  def show
    @user = current_user
    @near_me = Event.order(:start_time)
    if (logged_in? && params[:id].to_s != @user.id.to_s)
      redirect_to action: "show", id: @user.id
    elsif (!logged_in?)
      redirect_to action: "new"
    else
      @user = User.find(params[:id])
    end
  end

  def login
    @user = User.find_by(email: params[:session][:email])

    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to action: 'show'
    else
      redirect_to action: 'new'
    end
  end

  def logout
    @user = nil
    log_out
    redirect_to action: 'new'
  end

  private
    def article_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
