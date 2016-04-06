json.extract! @robot, :id
json.features do
  json.array!(@robot.features) do |feature|
    json.extract! feature, :key, :value
  end
end
