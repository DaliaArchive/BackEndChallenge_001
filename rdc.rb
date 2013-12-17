module Rdc
	class Cli
		attr_accessor :robots, :commands
		COMM_REG = /([a-zA-Z]+)\s*([a-zA-Z\d]+)*\s*([[\W][a-zA-Z\d]+[\W]+[a-zA-Z\d]+[\W]]+\W*)*/

		def initialize
			@commands = [:add, :delete, :update, :show, :index, :history, :exit]
			@robots = []
		end

		def process(command)
			return error_message if command.empty?

			sub_commands = COMM_REG.match(command).captures
			main_command = sub_commands[0].to_sym

			case main_command
			when :add
				add sub_commands[1], eval(sub_commands[2])
			when :delete
				delete sub_commands[1]
			when :update
				update sub_commands[1], eval(sub_commands[2])
			when :show
				show sub_commands[1]
			when :index
				index
			when :history
				history sub_commands[1]
			when :exit
				exit
			else
				puts "Wrong command: " + main_command.to_s
			end
		end

		def add(name, attributes)
			@robots << Robot.new(name, attributes)
		end

		def delete(name)
			robot = get_robot name
			robot ? (@robots.delete robot) : error_message
		end

		def update(name, attributes)
			robot = get_robot name

			if(robot)
				robot.update attributes
				@robots.map!{|r| (r.name == name) ? robot : r}
			else
				add name, attributes
			end
		end

		def show(name)
			robot = get_robot name
			robot ? robot.show_attributes : error_message
		end

		def index
			puts @robots.to_s
		end

		def history(name)
			robot = get_robot name
			robot ? robot.show_history : error_message
		end

		def get_robot(name)
			@robots.find{|r| r.name == name}
		end

		def error_message
			puts "Robot with such name doesn't exist"
		end

		def exit
			abort "Bye-bye"
		end
	end

	class Robot
		@@instances = 0
		attr_accessor :name, :created_at, :updated_at, :attributes, :history

		def self.new(*args)
			@@instances += 1
			super
		end

		def initialize(name="R2D2", attributes={})
			@name = name
			@created_at = Time.now
			@attributes = attributes

			@history = []
			@history << {date: @created_at, type: "create", changes: @attributes}
		end

		def update(attributes)
			@updated_at = Time.now
			@attributes.merge! attributes

			@history << {date: @updated_at, type: "update", changes: attributes}
		end

		def show_attributes
			puts @attributes.to_s
		end

		def show_history
			puts @history.each {|h| h.to_s}
		end

		def inspect
			"name: #{@name}\n" \
			"attributes: #{@attributes.to_s}"
		end
	end
end

console = Rdc::Cli.new

while(true)
	print "> "
	console.process STDIN.gets.chomp
end