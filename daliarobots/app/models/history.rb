class History
	include Mongoid::Document

	field :robot_id, type: String
	index({ robot_id: 1 }, { unique: true, name: 'robot_id_index'})
	
	field :type, type: String
	field :date_time_stamp, type: Date, default: DateTime.now
end
