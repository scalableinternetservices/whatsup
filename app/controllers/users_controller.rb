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
    if (logged_in? && params[:id].to_s != @user.id.to_s)
      redirect_to action: "show", id: @user.id
    elsif (!logged_in?)
      redirect_to action: "new"
    else
      @user = current_user
      
      Rails.cache.cleanup
      
      if Rails.cache.exist?("result_user_#{@user.id}", :expires_in => 1.hours) #return what was in the cache if something was there
        @result = Rails.cache.fetch("result_user_#{@user.id}", :expires_in => 1.hours)
      elsif request.safe_location != nil #store the location if it is available but not in the cache
        result = Rails.cache.fetch("result_user_#{@user.id}", :expires_in => 1.hours) do
          request.safe_location
        end
      else
        @result = nil #rare case: set location to nil
      end
      
      temp_events = nil
      
      if params[:location].present?
        temp_events = Rails.cache.fetch("events_near_location_#{params[:location]}", :expires_in => 5.minutes) do
          Event.near(params[:location], 50).limit(15)
        end
      else  
        temp_events = Rails.cache.fetch("events_near_lat_#{@lat}_lon_#{@lon}", :expires_in => 5.minutes) do
          Event.near([@lat,@lon], 50).limit(15)
        end
      end
  
      if params[:event_categories].present? and params[:event_categories].length != 0
        temp_events = temp_events.joins(:event_categories).where('event_categories.category in (?)', params[:event_categories]).uniq
        
      end
      
      @near_me = temp_events
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
    
    createNotification(:attend, params[:id])
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
    
    createNotification(:leave, params[:id])
  end
  
  def notifications
    @notifications = getAllNotifications
    @notifications.each { |n|
      if !n.hasSeen
        n.update_attribute(:hasSeen, true)
      end
    }
  end

  def logout
    @user = nil
    log_out
    redirect_to action: 'new'
  end
  
  def createComment
    comment = Comment.new(comment_params)
    if !comment.save
      render :action => :new
    else
      createNotification(:comment, comment.event_id)
      event = Event.find(params[:comment][:event_id])
      respond_to do |format|
        format.html
        format.json
        format.js { render 'reloadEvent', :locals => { :event => event } }
      end
    end
  end
  
  def seenNotifications
    notifications = getNotifications
    notifications.each { |n|
      n.update_attribute(:hasSeen, true)
    }
  end
  
  def destroy
    if (@user == nil)
      @user = User.find(params[:id])
    end
    
    Event.where(user_id: @user.id).each { |e|
      @attending = Attendance.where(event_id: e.id)
      for event in @attending
        event.destroy
      end
      @categories = EventCategory.where(event_id: e.id)
      for cat in @categories
        cat.destroy
      end
      @comments = Comment.where(event_id: e.id)
      for comment in @comments
        comment.destroy
      end
      @notifications = Notification.where(event_id: e.id)
      for notification in @notifications
        notification.destroy
      end
    }
    
    @user.destroy
    redirect_to action: 'new'
  end

  private
    def article_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def comment_params
      params.require(:comment).permit(:message, :event_id, :user_id)
    end
end
