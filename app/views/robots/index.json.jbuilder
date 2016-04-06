json.array!(@robots) do |robot|
  json.extract! robot, :name, :updated_at
end
