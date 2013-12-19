@guests.collect { |guest| {name: guest.name, last_update: guest.last_updated} }.to_json
#TODO: Figure out why this is broken
#Jbuilder.encode do |json|
#  json.array!(@guests) do |guest|
#    json.name guest.name
#    json.last_updated guest.last_updated
#  end
#end