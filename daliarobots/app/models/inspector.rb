class Inspector
	require "httpi"

  def index
  	response = HTTPI.get("http://0.0.0.0:3000/robots")
  	JSON.parse(response.body)
  end

  def show(name)
  	response = HTTPI.get("http://0.0.0.0:3000/robots/#{name}")
  	JSON.parse(response.body)
  end

  def update(name, options={})
    parameters = ""
    options.each do |k, v|
      parameters += "&#{k}=#{v}"
    end
  	response = HTTPI.put("http://0.0.0.0:3000/robots/update/?name=#{name}", parameters)
  	JSON.parse(response.body)
  end

  def history(name)
  	response = HTTPI.get("http://0.0.0.0:3000/robots/#{name}/history")
  	JSON.parse(response.body)
  end

end
