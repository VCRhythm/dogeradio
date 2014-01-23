json.array!(@tags) do |tag|
  json.extract! tag, :id, :music_id, :category, :description
  json.url tag_url(tag, format: :json)
end
