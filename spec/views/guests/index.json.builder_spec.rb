require 'spec_helper'

describe 'guests/index.json.builder' do
  it 'should render the name and last_updatedd only' do
    assign(:guests, [
        double(Guest, name: 'S341', last_updated: Time.parse('12-12-12')),
        double(Guest, name: 'D67', last_updated: Time.parse('12-12-13'))
    ])

    render

    rendered.should == [{name: 'S341', last_update: Time.parse('12-12-12')},
                        {name: 'D67', last_update: Time.parse('12-12-13')}].to_json
  end
end