json.array!(@history) do |history|
  json.timestamp history.timestamp
  json.type history.type
  json.changes history.change_set
end
