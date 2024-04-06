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
    @event = Event.new id: 1, name: 'Event Name'
    @entries = [
      {
        date: DateTime.iso8601('2024-12-12T09:15:00Z'),
        ok: ['Teszt Kunó'],
        maybe: ['Teszt Béla', 'Teszt Xavér', 'Teszt Eleonóra'],
        no: ['Teszt Teofil']
      },
      {
        date: DateTime.iso8601('2024-12-12T10:15:00Z'),
        ok: ['Teszt Kunó', 'Teszt Xavér', 'Teszt Eleonóra'],
        maybe: ['Teszt Béla'],
        no: ['Teszt Teofil']
      },
      {
        date: DateTime.iso8601('2024-12-13T09:15:00Z'),
        ok: ['Teszt Teofil'],
        maybe: ['Teszt Béla', 'Teszt Xavér', 'Teszt Eleonóra', 'Teszt Kunó'],
        no: []
      },
      {
        date: DateTime.iso8601('2024-12-13T10:15:00Z'),
        ok: ['Teszt Teofil', 'Teszt Béla'],
        maybe: ['Teszt Kunó'],
        no: ['Teszt Xavér', 'Teszt Eleonóra']
      },
    ]
  end

  def show
    @event = Event.new id: 1, name: 'Event Name'
    @entries = [
      DateTime.iso8601('2024-12-12T09:15:00Z'),
      DateTime.iso8601('2024-12-12T10:15:00Z'),
      DateTime.iso8601('2024-12-13T09:15:00Z'),
      DateTime.iso8601('2024-12-13T10:15:00Z'),
    ]
  end
end
