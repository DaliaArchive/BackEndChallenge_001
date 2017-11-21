class GuestsController < ApplicationController

  before_action :require_guest, only: [:show, :history]

  def update
    if params[:name] && params[:custom_attributes]
      update_guest
      render json: { status: 'success' }
    else
      render json: { error: 'invalid parameters. name and attributes must be provided' }, status: 400
    end
  end

  def show
    render json: @guest
  end

  def index
    guests = Guest.select(:id, :name, :history).map do |guest|
      # The datetime format we use also sorts well alphabetically :)
      last_update = guest.history.map { |h| h['datetime'] }.sort.last
      { id: guest.id, name: guest.name, last_update: last_update }
    end
    render json: { guests: guests }
  end

  def history
    render json: @guest.history
  end

  protected

  def require_guest
    @guest = Guest.find_by_name(params[:name])
    unless @guest
      render :json => { error: 'not found' }, status: 404
    end
  end

  def update_guest
    guest = Guest.find_or_initialize_by(name: params[:name])
    guest.custom_attributes ||= {}
    old_attributes = guest.custom_attributes.dup
    guest.custom_attributes.merge!(params[:custom_attributes].permit!)
    store_history(guest, old_attributes)
    guest.save!
  end

  def store_history(guest, old_attributes)
    update_type = if guest.new_record?
                    :create
                  else
                    :update
                  end
    guest.history << { datetime: Time.current.utc, type: update_type, changes: { old: old_attributes,
                                                                                 new: guest.custom_attributes } }
  end

end
