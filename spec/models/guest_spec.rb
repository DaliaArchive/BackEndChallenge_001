require 'rails_helper'

RSpec.describe Guest, type: :model do

  subject(:guest) { Fabricate.build(:guest) }

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end

end
