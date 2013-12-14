require 'spec_helper'
describe 'routing to robots' do

  it 'GET /robots/:unique_name routes to robots#show' do
    expect(:get => '/robots/some_id').to route_to(
                                              :controller => 'robots',
                                              :action => 'show',
                                              :id => 'some_id'
                                          )
  end

  it 'GET /robots routes to robots#index' do
    expect(:get => '/robots').to route_to(
                                     :controller => 'robots',
                                     :action => 'index'
                                 )
  end

  it 'POST /robots routes to robots#create_or_update' do
    expect(:post => '/robots').to route_to(
                                              :controller => 'robots',
                                              :action => 'create_or_update'
                                          )
  end

  it 'GET /robots routes to robots#index' do
    expect(:get => 'robots/some_id/history').to route_to(
                                              :controller => 'robots',
                                              :action => 'history',
                                              :id => 'some_id'
                                          )
  end

end