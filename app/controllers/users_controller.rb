class UsersController < ApplicationController

  skip_before_action :check_log_in, only: [:new, :create, :login]
  respond_to :html, :js

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
    @result = request.safe_location
    
    temp_events = Event.all
    
    if params[:location].present?
      temp_events = Event.near(params[:location], 50)
    else  
      temp_events = Event.near([@result.latitude,@result.longitude],20) 
    end

    if params[:event_categories].present? and params[:event_categories].length != 0
      temp_events = temp_events.joins(:event_categories).where('event_categories.category in (?)', params[:event_categories]).uniq
      
    end
    
    @near_me = temp_events
 
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
  
  def attendEvent
    eventList = Attendance.where(user_id: current_user.id, event_id: params[:id])
    if (eventList.count == 1 && eventList.first.event_id == params[:id])
      # we are already going to this event!
      format.html { redirect_to action: 'show', controller: 'users', notice: 'You are already going to this event!' }
    elsif (eventList.count != 0)
      # we have an incosistency in the data table
    else
      # attend this event
      event = Event.find(params[:id])
      if (event != nil)
        attend = Attendance.new(user_id: current_user.id, event_id: event.id)
        if (attend.save)
          respond_to do |format|
            format.html
            format.json
            format.js { render 'reloadEvent', :locals => { :event => event } }
          end
        end
      else
        # event doesn't exist
      end
    end
    
  end
  
  def leaveEvent
    eventList = Attendance.where(user_id: current_user.id, event_id: params[:id])
    if (eventList.count != 1)
      # we have an inconsistency in the data table
      redirect_to action: 'show', controller: 'users'
    else
      event = Event.find(eventList.first.event_id)
      eventList.first.destroy
      respond_to do |format|
        format.html
        format.json
        format.js { render 'reloadEvent', :locals => { :event => event } }
      end
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
