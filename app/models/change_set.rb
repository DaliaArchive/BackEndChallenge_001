class ChangeSet < Array
  class << self
    def build(old_attributes, new_attributes)
      change_set = ChangeSet.new
      new_attributes.keys.
          select { |key| old_attributes[key] != new_attributes[key] }.
          each do |key|
        change_set << Change.new(attribute: key, from: old_attributes[key], to: new_attributes[key])
      end
      change_set
    end
  end

  def initialize(params = {})
    params ||= {}
    params.collect { |param| Change.new(param) }.inject(self, :<<)
  end

  def to_params
    collect(&:to_params)
  end
end