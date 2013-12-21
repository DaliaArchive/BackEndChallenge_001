class GuestHistory
  class << self
    def guest_created(guest, change_set)
      create_guest_history(change_set, guest, 'created')
    end

    def guest_updated(guest, change_set)
      create_guest_history(change_set, guest, 'updated')
    end

    def find(guest_name)
      MongoStore.find('guest_history', guest_name: guest_name).collect{ |param| new(param) }
    end

    private
    def create_guest_history(change_set, guest, type)
      guest_history = GuestHistory.new(guest_name: guest.name, timestamp: Time.now, type: type)
      guest_history.change_set = change_set
      guest_history.create!
    end
  end

  attr_reader :timestamp, :type, :guest_name
  attr_accessor :change_set

  def initialize(params)
    params = HashWithIndifferentAccess.new(params)
    @timestamp =params[:timestamp]
    @type =params[:type]
    @guest_name =params[:guest_name]
    @change_set = ChangeSet.new(params[:change_set])
  end

  def == other
    self.class == other.class and
        self.guest_name == other.guest_name and
        self.timestamp == other.timestamp and
        self.type == other.type
  end

  def create!
    MongoStore.create!('guest_history', to_param)
  end

  private
  def to_param
    {timestamp: timestamp, type: type, guest_name: guest_name, change_set: change_set.to_params}
  end


end