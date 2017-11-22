@robot.attributes_hash.each do |key, value|
  json.set! key, value
end
