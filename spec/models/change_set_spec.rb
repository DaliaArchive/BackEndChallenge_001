require 'spec_helper'

describe ChangeSet do
  describe '#initalize' do
    it 'should initalize a empty change set' do
      subject = ChangeSet.new

      expect(subject).to eq([])
    end

    it 'should initalize a empty change set if nil is passed' do
      subject = ChangeSet.new nil

      expect(subject).to eq([])
    end

    it 'should initalize with a change\'s hash' do
      subject = ChangeSet.new [{attribute: :a, from: :b, to: :e}]

      expect(subject.count).to eq(1)
      expect(subject).to eq(ChangeSet.new([{attribute: :a, from: :b, to: :e}]))
    end
  end

  describe '#to_param' do
    it 'should convert to a params representation' do
      subject = ChangeSet.new [{attribute: :a, from: :b, to: :e}]

      expect(subject.to_params).to eq([{attribute: :a, from: :b, to: :e}])
    end
  end

  describe '#<<' do
    it 'should add a change to the change set' do
      change = double(Change)
      change_set = ChangeSet.new
      change_set << change

      expect(change_set).to eq([change])
    end
  end

  describe '.build' do
    it 'should create a change set of changed attributes' do
      change_set = ChangeSet.build({a: :b}, {a: :e})

      expect(change_set).to eq([Change.new(attribute: :a, from: :b, to: :e)])
    end

    it 'should create a change set of unchanged attributes' do
      change_set = ChangeSet.build({a: :b}, {a: :b})

      expect(change_set).to eq([])
    end

    it 'should create a change set if not matches for new attributes' do
      change_set = ChangeSet.build({a: :b}, {})

      expect(change_set).to eq([])
    end

    it 'should create a change with from as nil, if its a new attribute' do
      change_set = ChangeSet.build({}, {a: :b})

      expect(change_set).to eq([Change.new(attribute: :a, from: nil, to: :b)])
    end
  end
end