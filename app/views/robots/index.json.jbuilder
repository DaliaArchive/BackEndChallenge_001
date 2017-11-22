json.array! @robots do |robot|
  json.name robot.name
  json.last_update robot.updated_at
end
