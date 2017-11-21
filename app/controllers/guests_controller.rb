class GuestsController < ApplicationController

  def update
    if params[:name] && params[:custom_attributes]
      guest = Guest.find_by_name(params[:name])
      update_type = :update
      unless guest
        update_type = :create
        guest = Guest.create(name: params[:name])
      end
      guest.custom_attributes ||= {}
      old_attributes = guest.custom_attributes.dup
      guest.custom_attributes.merge!(params[:custom_attributes].permit!)
      guest.history << { datetime: Time.current.utc, type: update_type, changes: { old: old_attributes, new: guest.custom_attributes } }
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
    guest = Guest.find_by_name(params[:name])
    if guest
      render json: guest.history
    else
      render :json => { error: 'not found' }, status: 404
    end
  end
end
