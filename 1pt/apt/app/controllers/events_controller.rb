class EventsController < ApplicationController

  def new
    if @current_user.blank?
      flash[:errors] = [I18n.t('errors.login_needed_to_create_event')]
      return redirect_to login_path
    end

    @event = Event.new
  end

  def create
    if @current_user.blank?
      flash[:errors] = [I18n.t('errors.login_needed_to_create_event')]
      return redirect_to login_path
    end

    eparams = event_create_params
    if eparams[:event_entries].blank? || eparams[:event_entries].empty?
      flash[:errors] = ['Must specify appointments']
      return redirect_back fallback_location: new_event_path
    end
    eparams[:event_entries] = eparams[:event_entries].map do |e|
      ee = EventEntry.new(e)
      ee.date = nil if eparams[:same_date]
      ee.time = nil if eparams[:same_time]
      ee
    end
    event = Event.new(eparams)
    event.user = @current_user
    if event.save
      redirect_to events_path
    else
      flash[:errors] = event.errors.full_messages
      redirect_back fallback_location: new_event_path
    end
  end

  def find_event
    if params[:event_id].blank?
      flash[:errors] = [I18n.t('errors.missing_event_id')]
      return redirect_back fallback_location: root_page_path
    end

    event = Event.find_by(id: params[:event_id])
    return redirect_to event_path(event.id), id: event.id if event

    flash[:errors] = [I18n.t('invalid_event_identifier')]
    redirect_back fallback_location: root_page_path
  end

  def index
    if @current_user.blank?
      flash[:errors] = [I18n.t('errors.login_needed_to_see_events')]
      return redirect_to login_path
    end
    @events = Event.where(user_id: @current_user.id).all
  end

  def get_responses
    @event = Event.where(id: params[:event_id]).includes(responses: [:user, response_entries: [:event_entry]]).first
    unless @event
      flash[:errors] = [I18n.t('errors.missing_event')]
      return redirect_back fallback_location: root_page_path
    end

    @entries = @event.event_entries.map do |e|
      {
        date: e.as_rendered,
        ok: filter_responses(e.response_entries, 'ok'),
        maybe: filter_responses(e.response_entries, 'maybe'),
        no: filter_responses(e.response_entries, 'no'),
      }
    end
  end

  def save_response
    event = Event.includes(:event_entries).find_by(id: params[:id])
    if event.blank?
      flash[:errors] = [I18n.t('errors.missing_event')]
      return redirect_back fallback_location: root_page_path
    end

    resp_params = params.require(:response).permit(
      :user_id,
      :responder,
      { entry: {} }
    )

    resp_params[:entry] ||= {}
    resp_params[:response_entries] = resp_params[:entry].keys.map do |idx|
      ResponseEntry.new(stat: resp_params[:entry][idx], event_entry: event.event_entries[idx.to_i])
    end
    resp_params[:event_id] = params[:id]
    resp_params = resp_params.except(:entry)

    resp = Response.new(resp_params)
    if resp.save
      flash[:notices] = ["Thank you for responding"]
      return redirect_to root_page_path
    end

    flash[:errors] = resp.errors.full_messages
    redirect_back fallback_location: root_page_path
  end

  def show
    @response_types = [
      { type: :ok, text: I18n.t('stat.ok') },
      { type: :maybe, text: I18n.t('stat.maybe') },
      { type: :no, text: I18n.t('stat.no') },
    ]
    @default_response = @response_types[-1]

    event_params = params.permit :id, :event_id
    id = event_params[:event_id]
    id = event_params[:id] unless id

    @event = Event.find_by(id: id)
    unless @event
      flash[:errors] = [I18n.t('errors.missing_event')]
      return redirect_back fallback_location: root_page_path
    end

    @response = Response.new event_id: @event.id
    @entries = @event.event_entries.map do |e|
      e.as_rendered
    end
  end

  private

  def event_create_params
    params.permit(:same_time, :same_day, event: [
      :name,
      for_users: [],
      event_entries: [:date, :time]
    ]).require(:event)
  end

  def filter_responses(r, type)
    r.filter { |x| x.stat == type }
     .map { |x| x.response.responder_name }
  end
end
