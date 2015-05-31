module EventsHelper
  # Return the current list of categories
  def list_categories
    @possible_categories = ["Infosession", "Lunch/Dinner Meeting", "Group Study", "Competition"]
  end
  
  def cache_key_for_event_panel(event)
    "event-#{event.id}-#{event.updated_at}"
  end
  
end
