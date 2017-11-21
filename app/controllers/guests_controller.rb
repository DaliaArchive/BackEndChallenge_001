class GuestsController < ApplicationController
  def update
  end

  def show
    guest = Guest.find_by_name(params[:name])
    if guest
      render json: guest
    else
      render :json => { error: 'not found' }, status: 404
    end
  end

  def index
    render json: { guests: Guest.select(:id, :name) }
  end

  def history
  end
end
