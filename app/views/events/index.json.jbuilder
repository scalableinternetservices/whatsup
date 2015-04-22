json.array!(@events) do |event|
  json.extract! event, :id, :name, :city, :latitude, :longitude, :time, :description
  json.url event_url(event, format: :json)
end
