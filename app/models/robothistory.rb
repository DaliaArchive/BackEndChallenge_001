class Robothistory < ActiveRecord::Base
  attr_accessible :field, :status, :value
  
  belongs_to :robot
  
  def self.result_format(name)
    if @robothistories = Robothistory.where(:robots => {:name => name}).includes(:robot).order(:robothisies => :id)
      history_hash={}
      @robothistories.each do |history|
        history_hash["#{history.created_at}"]=Array.new if history_hash["#{history.created_at}"].blank?
        objArray = Array.new
        objArray << {"status" => history.status}
        objArray << {"changes" => { :"#{history.field}" => history.value}}
        history_hash["#{history.created_at}"] << objArray
      end
      return history_hash
    end
  end
end
