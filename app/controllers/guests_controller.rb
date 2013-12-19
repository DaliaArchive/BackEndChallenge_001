class GuestsController < ApplicationController
  def update
    guest = Guest.find_or_initialize(params[:name])
    guest.merge_attributes(params[:guest])
    guest.save!
  end

  def show
    guest = Guest.find(params[:name])
    render json: guest.attributes
  end

  def history
    guest = Guest.find(params[:name])
    render json: guest.history
  end

  def index
    guests = Guest.all
    render
  end
end
