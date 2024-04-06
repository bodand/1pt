class EventController < ApplicationController
  def new
    @event = Event.new
  end

  def index
    @events = [
      Event.new(id: 1, name: 'A'),
      Event.new(id: 2, name: 'BB'),
      Event.new(id: 3, name: 'CCC'),
      Event.new(id: 4, name: 'DDDD'),
    ]
  end

  def respond
  end

  def show
  end
end
