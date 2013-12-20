require 'spec_helper'

describe DrRoboto::InspectorsController do

  before do
    DatabaseCleaner.clean
  end

  describe "POST /inspectors" do

    context "when provided with all parameters" do

      context "if username not taken" do
        before do
          DrRoboto::Inspector.where(username: 'inspector_gadget').destroy_all
          post "/inspectors", { username: 'inspector_gadget', password: '1234' }
        end
        subject { last_response }
        let(:inspector) { DrRoboto::Inspector.where(username: 'inspector_gadget').first }
        it { inspector.present?.should == true }
        it { subject.status.should == 201 }
        it { subject.headers['SetCookie'].should == "token=#{inspector.token}" }
        it { subject.body.should == { data: 'success' }.to_json }
        it { subject.content_type.should == 'application/json;charset=utf-8' }
      end

      context "if username already taken" do
        before do
          DrRoboto::Inspector.create(username: 'inspector_gadget', password: '1234')
          post "/inspectors", { username: 'inspector_gadget', password: '1234' }
        end
        subject { last_response }
        it { subject.status.should == 400 }
        it { subject.body.should == { error: 'invalid_parameters' }.to_json }
        it { subject.content_type.should == 'application/json;charset=utf-8' }
      end

    end

    context "when parameters are missing" do
      before do
        post "/inspectors", { username: 'inspector_gadget', password: '' }
      end
      subject { last_response }
      it { subject.status.should == 400 }
      it { subject.body.should == { error: 'invalid_parameters' }.to_json }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
    end

  end

  describe "POST /inspectors/login" do

    context "when valid username and password are passed" do
      before do
        DrRoboto::Inspector.create(username: 'inspector_gadget', password: '1234')
        post "/inspectors/login", { username: 'inspector_gadget', password: '1234' }
      end
      let(:inspector) { DrRoboto::Inspector.where(username: 'inspector_gadget').first }
      subject { last_response } 
      it { subject.status.should == 200 }
      it { subject.headers['SetCookie'].should == "token=#{inspector.token}" }
      it { subject.body.should == { data: 'success' }.to_json }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
    end

    context "when invalid username and password are passed" do
      before do
        post "/inspectors/login", { username: 'not_the_inspector', password: '4321' }
      end
      subject { last_response }
      it { subject.status.should == 401 }
      it { subject.body.should == { error: 'not_authorized' }.to_json }
      it { subject.content_type.should == 'application/json;charset=utf-8' }
    end

  end

end