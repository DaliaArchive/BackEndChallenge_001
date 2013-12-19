class GuestsController < ApplicationController
  def update
    guest = Guest.find_or_initialize(params[:name])
    guest.merge_attributes(params[:guest])
    guest.save!
  end

  def show
  end
end
