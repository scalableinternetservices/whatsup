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
  
  def isAttending(user_id, event_id)
    Attendance.where(user_id: user_id, event_id: event_id).any?
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
    elsif diffTime == 1
      formattedString = "#{diffTime.to_i} seconds ago"
    end
    
    return formattedString
  end

end
