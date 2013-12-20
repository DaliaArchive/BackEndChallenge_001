require 'spec_helper'

describe DrRoboto::InspectorsController do

  before do
    DatabaseCleaner.clean
  end

  describe "POST /inspectors" do

    context "when provided with all parameters" do

      context "when username not taken" do
        before do
          DrRoboto::Inspector.where(username: 'inspector_gadget').destroy_all
          post "/inspectors", { username: 'inspector_gadget', password: '1234' }
        end
        subject { last_response }
        let(:inspector) { DrRoboto::Inspector.where(username: 'inspector_gadget').first }
        it { inspector.present?.should == true }
        it { subject.status.should == 201 }
        it { subject.cookies['token'].should == inspector.token }
      end

      context "when username already taken" do
        before do
          DrRoboto::Inspector.create(username: 'inspector_gadget', password: '1234')
          post "/inspectors", { username: 'inspector_gadget', password: '1234' }
        end
        subject { last_response }
        it { subject.status.should == 400 }
        # it { subject.content_type.should == 'application/json;charset=utf-8' }
      end

    end

    context "when parameters are missing" do
      before do
        post "/inspectors", { username: 'inspector_gadget', password: '' }
      end
      subject { last_response }
      it { subject.status.should == 400 }
    end

  end

  describe "POST /inspectors/login" do

  end

end