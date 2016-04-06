class Robot < ActiveRecord::Base

  has_many :revisions
  has_many :features, through: :revisions

  # returns a formatted list of all the robots with the last update
  def self.list

    # Fetch the robots
    robots = Robot.includes(:revisions).all

    # Formats the output
    robots.map do |robot|

      last_update = robot.revisions.last.created_at.to_formatted_s(:db)

      { name: robot.name, last_update: last_update }

    end

  end


  # Return a formatted hash of the robot's current features
  def current_features

    # Fetch the robot's current features with unique names
    features = self.features.group(:name).select(:name,:value).as_json

    # Formats the output
    features.inject({}) do |hash, feature|

      name = feature["name"]

      value = feature["value"]

      hash[name] = value

      hash

    end

  end

  # Returns a dettailed list of all revisions and changes for a robot
  def history

    # Fetch the revisions
    revisions = self.revisions.includes(:features).all

    # Instantiates an empty container for the list that will be returned by the method
    revisions_history = {}
    # Instantiates an empty container that keep track of the changing features over time
    registry = {}
    # Iterates over the revisions
    revisions.each do |actual|

      # Fetches the features present in the current revision
      actual_features = actual.get_features

      # Sets up the item hash for the current revision
      created_at = actual.created_at.to_formatted_s(:db)

      revision_item =  {
          type: actual.type,
          changes: []

        }


      #if it's the first revision for a robot
      if actual.type === "create"

        # updates the value in the changes history hash and
        # sets up the change string with an empty starting value

        changes = actual_features.map do |name, value|

          registry[name] = value

          "#{name}: [] -> [#{value}]"

        end

        # puts the changes string in the current revision item
        revision_item[:changes] = changes

      # if it's an update revision
      else



        # Iterates over the features of the current revision to confront them
        # with the history of features
        actual_features.each do |name, value|

          # Feature was already present in the registry but the value has changed
          if registry.has_key?(name) && registry[name] != value
            # sets up the changes string with the old and new values
            changes = "#{name}: [#{registry[name]}] -> [#{value}]"
            # updates the registry
            registry[name] = value
          # if feature is not present in the registry
          elsif !registry.has_key?(name)
            # sets up the changes string with an empty starting value
            changes = "#{name}: [] -> [#{value}]"
            # updates the registry
            registry[name] = value
          end

          # insert the changes in the revision item
          revision_item[:changes] << changes if changes

        end

      end
      #insert the revision item in the list
      revisions_history[created_at] = revision_item

    end

    revisions_history

  end

end
