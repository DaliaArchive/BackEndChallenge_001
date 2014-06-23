class Change
  attr_reader :attribute, :from, :to

  def initialize params
    @attribute = params[:attribute]
    @from = params[:from]
    @to = params[:to]
  end

  def == other
    self.class == other.class &&
        self.attribute == other.attribute &&
        self.from == other.from &&
        self.to == other.to
  end

  def to_params
    {attribute: @attribute, from: @from, to: @to}
  end
end