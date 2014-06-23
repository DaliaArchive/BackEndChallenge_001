class MongoStore
  class << self
    include Mongo
    def create!(collection, params)
      database[collection].insert(params)
    end

    def update!(collection, id, params)
      database[collection].update({"_id" => id}, params)
    end

    def find(collection, criteria)
      database[collection].find(criteria).to_a
    end

    def purge!
      MongoClient.new.drop_database(database_name)
    end


    private
    def database
      MongoClient.new[database_name]
    end

    def database_name
      Rails.env.to_s
    end
  end
end