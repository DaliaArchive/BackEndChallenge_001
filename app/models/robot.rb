class Robot < ActiveRecord::Base

  has_many :revisions
  has_many :features, through: :revisions

  # return a formatted list of all the robots with the last update
  def self.list

    # Fetch the robots
    robots = Robot.includes(:revisions).all

    # Format the output
    robots.map do |robot|

      last_update = robot.revisions.last.created_at.to_formatted_s(:db)

      { name: robot.name, last_update: last_update }

    end

  end


  # Return a formatted list of the robot current features
  def current_revision

    # Fetch the robots current features with unique names
    features = self.features.group(:name).select(:name,:value).as_json

    # Format the output
    features.inject({}) do |hash, feature|

      name = feature["name"]

      value = feature["value"]

      hash[name] = value

      hash

    end

  end

  # Return a dettailed list of all revisions and changes for a robot
  def history

    # Fetch the revisions
    revisions = self.revisions.includes(:features).all

    # Instantiate an empty container for the list
    history = []

    # Iterate over the features with index in order to grab the previous
    # element and confront the changes
    revisions.each_with_index do |actual, i|

      # current features
      actual_features = actual.get_features

      # Set up the item hash for the current revision
      created_at = actual.created_at.to_formatted_s(:db)

      revision_item = {
        created_at => {
          type: actual.type,
          changes: []

        }
      }

      #if it's the first revision
      if actual.type === "create"

        # set up the changes string with an empty starting value
        changes = actual_features.map do |name, value|

          "#{name}: [] -> [#{value}]"

        end

        revision_item[created_at][:changes] = changes

      else

        # Fetch the previous revision
        previous = revisions[i - 1]

        previous_features = previous.get_features

        # Iterate over the features of the current revision to confront them
        # with the previous revision
        actual_features.each do |name, value|

          # Feature was already present but the value has changed
          if previous_features.has_key?(name) && previous_features[name] != value
            # set up the changes string with the old and new values
            changes = "#{name}: [#{previous_features[name]}] -> [#{value}]"

          # Feature was not present in the previous revision
          elsif !previous_features.has_key?(name)
            # set up the changes string with an empty starting value
            changes = "#{name}: [] -> [#{value}]"

          end

          # insert the changes in the revision item
          revision_item[created_at][:changes] << changes if changes

        end

      end
      #insert the item in the list
      history << revision_item

    end

    history

  end

end
