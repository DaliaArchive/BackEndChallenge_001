require 'spec_helper'

describe 'guests/history.json.jbuilder' do
  it 'should render history' do
    assign(:history, [
        double(GuestHistory, timestamp: 'timestamp', type: 'updated', change_set: ChangeSet.new([{attribute: "name", from: 'from', to: 'to'}])
    )])

    render

    rendered.should == [{
      timestamp: 'timestamp' , type: 'updated', changes: [{
        attribute: "name", from: 'from', to: 'to'
      }]
    }].to_json
  end
end
