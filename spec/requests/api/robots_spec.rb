# spec/requests/api/v1/messages_spec.rb
describe "Robots API" do
    before do
      @robot = Robot.create(name:"XX1")
      @revision = Revision.create(type: "create")
      @feature = Feature.create(name:"color", value: "white")
      @revision.features << @feature
      @robot.revisions << @revision
      @robot2 = Robot.create(name:"XX2")
      @revision = Revision.create(type: "create")
      @feature = Feature.create(name:"color", value: "red")
      @revision.features << @feature
      @robot2.revisions << @revision
    end
  it 'retrieves a specific robot attributes' do
    get "/api/robots/#{@robot.name}"
    json = JSON.parse(response.body)
    # test for the 200 status-code
    expect(response).to be_success


    expect(json['color']).to eq('white')
  end

  it 'create a new robot' do

    robot_name = "XX3"
    query= "color=blue&weight=10kg"
    put "/api/robots/#{robot_name}?#{query}"
    json = JSON.parse(response.body)

    expect(response).to be_success

    expect(Robot.all.count).to eq(3)

    expect(json['color']).to eq('blue')
    expect(json['weight']).to eq('10kg')

  end

  it 'update an existing robot' do

    robot_name = "XX1"
    query= "color=gray&weight=20kg"
    put "/api/robots/#{robot_name}?#{query}"
    json = JSON.parse(response.body)

    expect(response).to be_success

    expect(json['color']).to eq('gray')
    expect(json['weight']).to eq('20kg')

  end

  it 'list the robot' do

    robot_name = "XX1"

    get "/api/robots/"

    json = JSON.parse(response.body)

    expect(response).to be_success

    expect(json[0]['name']).to eq('XX1')
    expect(json[1]['name']).to eq('XX2')

  end


end