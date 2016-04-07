json.array!(@robots) do |robot|
  json.extract! robot, :id, :name, :attribs, :created_at, :updated_at
  json.histories robot.histories, :transaction_type, :changed_attribs
  json.url robot_url(robot.name, format: :json)
end
