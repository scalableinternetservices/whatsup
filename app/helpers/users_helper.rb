module UsersHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  def getComments(event_id)
    Comment.where(event_id: event_id).order(created_at: :asc)
  end
  
  def getNotifications
    notifications = Notification.where(user_id: current_user.id, hasSeen: false).order(created_at: :asc)
  end
  
  def getAllNotifications
    Notification.where(user_id: current_user.id).order(created_at: :desc)
  end
  
  def isAttending(user_id, event_id)
    Attendance.where(user_id: user_id, event_id: event_id).any?
  end
  
  def getUserName(user_id)
    User.find(user_id).name
  end
  
  def getEventName(event_id)
    Event.find(event_id).name
  end
  
  # Currently accepted types
  # :attend, :leave, :comment
  def createNotification(type, event_id)
    msg = nil
    hostId = Event.find(event_id).user_id
    case type
      when :attend
        msg = "#{getUserName(current_user.id)} is attending the event #{getEventName(event_id)}"
        notification = Notification.new(user_id: hostId, from_user_id: current_user.id, event_id: event_id, hasSeen: false, message: msg)
        notification.save
      when :leave
        msg = "#{getUserName(current_user.id)} has left the event #{getEventName(event_id)}"
        notification = Notification.new(user_id: hostId, from_user_id: current_user.id, event_id: event_id, hasSeen: false, message: msg)
        notification.save
      when :comment
        idList = []
        msg = "#{getUserName(current_user.id)} has commented on the event #{getEventName(event_id)}"
        
        # we need to get a list of all the people that commented
        listToNotify = Comment.where(event_id: event_id).select("user_id").distinct.flatten
        
        listToNotify.each { |n|
          if (n.user_id != current_user.id && !idList.include?(n.user_id))
            idList.push(n.user_id)
          end
        }
        
        # we need to get a list of all the people that are attending
        listToNotify = Attendance.where(event_id: event_id).select("user_id").distinct.flatten
        listToNotify.each { |n|
          if (n.user_id != current_user.id && !idList.include?(n.user_id))
            idList.push(n.user_id)
          end
        }
        
        # check if host is included
        if (!idList.include?(hostId))
          idList.push(hostId)
        end
        
        idList.each { |id|
          notification = Notification.new(user_id: id, from_user_id: current_user.id, event_id: event_id, hasSeen: false, message: msg)
          notification.save
        }
      else
        return
    end

    # should probably do error checking here
  end
  
  def seenNotification(notification_id)
    Notification.find(notification_id).update_attribute(hasSeen: true)
  end
  
  def format_time(time)
    diffTime = Time.now - time
    formattedString = ""
    
    if diffTime > 604800 # over a week
      formattedString = time.strftime("%M %d, %Y")
    elsif diffTime > 86400 * 2 # more than one day ago
      formattedString = "#{(diffTime / 86400).to_i} days ago"
    elsif diffTime > 86400 # one day ago
      formattedString = "1 day ago"
    elsif diffTime > 3600 * 2 # more than one hour ago
      formattedString = "#{(diffTime / 3600).to_i} hours ago"
    elsif diffTime > 3600 # one hour ago
      formattedString = "1 hour ago"
    elsif diffTime > 60 * 2 # more than one minute ago
      formattedString = "#{(diffTime / 60).to_i} minutes ago"
    elsif diffTime > 60 # one minute ago
      formattedString = "1 minute ago"
    elsif diffTime == 1 # one second ago
      formattedString = "1 second ago"
    else
      formattedString = "#{diffTime.to_i} seconds ago"
    end
    
    return formattedString
  end

end
