json.array! @guests do |guest|
  json.name guest.name
  json.last_update guest.last_updated
end
