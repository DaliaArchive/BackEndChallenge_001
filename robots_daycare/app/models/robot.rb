class Robot
  include Mongoid::Document
  include Mongoid::Timestamps
  embeds_many :histories, class_name: "History"
  
  field :name, type: String
  field :attribs, type: Hash, :default => Hash.new
  
  validates_presence_of :name
  validates_uniqueness_of :name

  def self.action_type(attibs)
    attibs.blank? ? "create" : "update"
  end

  def save_history(old_attribs)
    changed_attributes = self.get_changed_attribs(old_attribs)
    history = {
      transaction_type: Robot.action_type(old_attribs),
      changed_attribs: changed_attributes
    } unless changed_attributes.blank?

    self.histories.create(history) unless history.blank?
  end

  def get_changed_attribs(old_attribs)
    changed_attribs = []
    self.attribs.each do |k, v|
      changed_attrib = get_changed_attrib(old_attribs, k, v)
      changed_attribs << changed_attrib unless changed_attrib.blank?
    end
    changed_attribs
  end

  def get_changed_attrib(old_attribs, key, value)
    changed_attrib = {}
    if (old_attribs.key?(key) and old_attribs[key] != value) or !old_attribs.key?(key)
      changed_attrib[:key]        = key
      changed_attrib[:new_value]  = value
      changed_attrib[:old_value]  = old_attribs[key].to_s   # to_s for emptying null value in case of new key
    end
    changed_attrib
  end
  
end
