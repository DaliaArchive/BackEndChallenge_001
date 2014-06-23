class GuestsController < ApplicationController
  def update
    guest = Guest.find_or_initialize(params[:name])
    guest.merge_attributes(params[:guest])
    guest.save!
    head :no_content
  end

  def show
    guest = Guest.find(params[:name])
    if guest.present?
      render json: guest.attributes
    else
      head :not_found
    end
  end

  def history
    guest = Guest.find(params[:name])
    if guest.present?
      @history = guest.history
      render formats: [:json]
    else
      head :not_found
    end
  end

  def index
    @guests = Guest.all
    render formats: [:json]
  end
end
