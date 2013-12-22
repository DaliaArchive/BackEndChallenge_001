class Robot
	include Mongoid::Document

	field :last_update, type: Date, default: DateTime.now
end
