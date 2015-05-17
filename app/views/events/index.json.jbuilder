json.array!(@events) do |event|
  json.extract! event, :id, :name, :location, :start_time, :end_time, :description, :category
  json.url event_url(event, format: :json)
end
