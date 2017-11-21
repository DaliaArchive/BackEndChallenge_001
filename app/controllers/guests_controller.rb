class GuestsController < ApplicationController

  def update
    if params[:name] && params[:custom_attributes]
      guest = Guest.find_or_create_by(name: params[:name])
      guest.custom_attributes ||= {}
      guest.custom_attributes.merge!(params[:custom_attributes].permit!)
      guest.save!
      render json: { status: 'success' }
    else
      render json: { error: 'invalid parameters. name and attributes must be provided' }, status: 400
    end
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
