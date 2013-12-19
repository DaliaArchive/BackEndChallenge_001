class GuestHistory
  class << self
    def guest_created(guest)
      GuestHistory.new(guest_name: guest.name, timestamp: Time.now, type: 'created').create!
    end

    def guest_updated(guest)
      GuestHistory.new(guest_name: guest.name, timestamp: Time.now, type: 'updated').create!
    end

    def find(guest_name)
      MongoStore.find('guest_history', guest_name: guest_name).collect{|param| GuestHistory.new(param)}
    end
  end

  attr_reader :timestamp, :type, :guest_name

  def initialize(params)
    params = HashWithIndifferentAccess.new(params)
    @timestamp =params[:timestamp]
    @type =params[:type]
    @guest_name =params[:guest_name]
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
    {timestamp: timestamp, type: type, guest_name: guest_name}
  end


end