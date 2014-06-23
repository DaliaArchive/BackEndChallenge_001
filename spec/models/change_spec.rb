require 'spec_helper'

describe Change do
  describe 'initialize' do
    it 'should assign attribute, from and to' do
      subject = Change.new(attribute: 'color', from: 'blue', to: 'red')

      expect(subject.attribute).to eq('color')
      expect(subject.from).to eq('blue')
      expect(subject.to).to eq('red')
    end
  end

  describe 'equality' do
    it 'should be equal if attribute, from and to are equal' do
      subject = Change.new(attribute: 'color', from: 'blue', to: 'red')

      expect(subject).to eq(Change.new(attribute: 'color', from: 'blue', to: 'red'))

      expect(subject).not_to eq(Change.new(attribute: 'color', from: 'blue', to: 'blue'))
      expect(subject).not_to eq(Change.new(attribute: 'color', from: 'red', to: 'red'))
      expect(subject).not_to eq(Change.new(attribute: 'height', from: 'blue', to: 'red'))
      expect(subject).not_to eq('string')
    end
  end

  describe '#to_param' do
    it 'should convert to a params representation' do
      subject = Change.new(attribute: :a, from: :b, to: :e)

      expect(subject.to_params).to eq(attribute: :a, from: :b, to: :e)
    end
  end

end