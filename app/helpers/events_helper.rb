module EventsHelper
  # Return the current list of categories
  def list_categories
    @possible_categories = ["Infosession", "Lunch/Dinner Meeting", "Group Study", "Other"]
  end
end
