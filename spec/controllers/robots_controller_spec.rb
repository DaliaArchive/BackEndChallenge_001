require 'spec_helper' 
describe RobotsController do
  before(:all) do
    @robot = Robot.new(:name => "testRobot3")
  end 
  
  describe "GET 'showrobot'" do
    it "not allow not exist name, wil return 204" do
      get :show, :name => "fff4r"
      response.response_code.should == 204
    end
  end
  
  describe "POST 'createrobot'" do
    
    it "create robot without name will return 422" do
      @attr={:name =>"", :robot_datas => {:color => "9999" }}
      post :create, :robot => @attr
      response.response_code.should == 422
    end
    
    it "create robot with exist name will return 422" do
      @attr={:name =>"testRobot3", :robot_datas => {:color => "9999" }}
      post :create, :robot => @attr
      response.response_code.should == 422
    end
    
    it "create robot with not exist name will return 201" do
      @attr={:name =>"rrrr", :robot_datas => {:color => "9999" }}
      post :create, :robot => @attr
      response.response_code.should == 201
    end
  end
  
  describe "PUT 'updaterobot'" do
    
    it "update by not exist name will response code 204" do
      @attr = { :name => "fff4r", :robot_datas => {:color => "9999" }}
      put :update, :name => "fff4r", :robot => @attr
      response.response_code.should == 204 
    end
    
    it "update by without name will response code 204" do
      @attr = { :name => "fff4r", :robot_datas => {:color => "9999" }}
      put :update, :name => "", :robot => @attr
      response.response_code.should == 204
    end
    
    it "update will not update name column" do
      @robot = Robot.where(:name => "testRobot3").first
      @attr = { :name => "testRobot2", :robot_datas => {:color => "9999" }}
      put :update, :name => "testRobot3", :robot => @attr
      @robot.reload
      @robot.name.should == "testRobot3"
      @robot.robot_datas.should == @attr[:robot_datas].to_json
      response.response_code.should == 200 
    end
    
  end
end