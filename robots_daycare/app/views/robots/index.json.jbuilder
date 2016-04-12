json.array!(@robots) do |robot|
  json.extract!     robot, :name, :attribs, :created_at, :updated_at
  json.histories    robot.histories, :transaction_type, :changed_attribs
  json.url          robot_url(robot.name, format: :json)
  json.history_url  robot_histories_url(robot.name, format: :json)
end
