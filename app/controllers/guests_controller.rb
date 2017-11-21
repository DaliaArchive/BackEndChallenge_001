class GuestsController < ApplicationController
  def update
  end

  def show
  end

  def index
    render json: { guests: Guest.select(:id, :name) }
  end

  def history
  end
end
