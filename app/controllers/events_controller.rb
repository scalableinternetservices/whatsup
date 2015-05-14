class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  helper_method :leaveEvent

  # GET /events
  # GET /events.json
  def index
    if logged_in?
      eventList = Event.where(user_id: current_user.id)
      @events = []
      for event in eventList
        count = Attendance.where(event_id: event.id).count
        @events.append([event, count])
      end
      @attending = Attendance.where(user_id: current_user.id)
      @eventsAttending = []
      for event in @attending
        count = Attendance.where(event_id: event.event_id).count
        @eventsAttending.append([Event.find(event.event_id), count])
      end
      
    else
      redirect_to action: "new", controller: "users"
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    if logged_in?
      @event = Event.new
    else
      redirect_to action: "new", controller: "users"
    end
  end
  
  def near_events(la,lo,radius)
     Event.near([la, lo], radius)
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.user = current_user
    
    respond_to do |format|
      if @event.save 
        @attend = Attendance.new(user_id: current_user.id, event_id: @event.id)
        if @attend.save
          format.html { redirect_to @event, notice: 'Event was successfully created.' }
          format.json { render :show, status: :created, location: @event }
        else
          @event.destroy
          format.html { render :new }
          format.json { render json: @attend.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
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
    
      respond_to do |format|
        # attend this event
        event = Event.find(params[:id])
        if (event != nil)
          attend = Attendance.new(user_id: current_user.id, event_id: event.id)
          if (attend.save)
            format.html { redirect_to controller: 'users', action: 'show' }
            format.js
            format.json { render action: 'show' }
          end
        else
          # event doesn't exist
        end
      end
    end
    
  end
  
  def leaveEvent
    eventList = Attendance.where(user_id: current_user.id, event_id: params[:id])
    if (eventList.count != 1)
      # we have an inconsistency in the data table
      redirect_to action: 'show', controller: 'users'
    else
      eventList.first.destroy
      redirect_to action: "show", controller: "users"
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @attending = Attendance.where(event_id: @event.id)
    for event in @attending
      event.destroy
    end
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :location, :start_time, :end_time, :description)
    end
end
