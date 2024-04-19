# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

u1 = User.create(username: "user1", password: "password1", name: 'User Egy', email: 'user1@mail.com')
u2 = User.create(username: "user2", password: "password2", name: 'User Kettő', email: 'user2@mail.com')

e1u1 = Event.create name: 'Event1 User1', user: u1, event_entries: [
  EventEntry.new(date: Date.iso8601('2024-04-19'), time: Time.iso8601('1970-01-01T10:00:00Z')),
  EventEntry.new(date: Date.iso8601('2024-04-19'), time: Time.iso8601('1970-01-01T11:00:00Z')),
  EventEntry.new(date: Date.iso8601('2024-04-20'), time: Time.iso8601('1970-01-01T10:00:00Z')),
  EventEntry.new(date: Date.iso8601('2024-04-20'), time: Time.iso8601('1970-01-01T11:00:00Z')),
]
e2u1 = Event.create name: 'Event2 User1', user: u1, event_entries: [
  EventEntry.new(date: Date.iso8601('2024-04-19'), time: Time.iso8601('1970-01-01T10:00:00Z')),
  EventEntry.new(date: Date.iso8601('2024-04-20'), time: Time.iso8601('1970-01-01T10:00:00Z')),
]
e1u2 = Event.create name: 'Event1 User2', user: u2, event_entries: [
  EventEntry.new(date: Date.iso8601('2024-04-19'), time: Time.iso8601('1970-01-01T10:00:00Z')),
  EventEntry.new(date: Date.iso8601('2024-05-19'), time: Time.iso8601('1970-01-01T11:00:00Z')),
  EventEntry.new(date: Date.iso8601('2024-06-20'), time: Time.iso8601('1970-01-01T10:00:00Z')),
  EventEntry.new(date: Date.iso8601('2024-07-20'), time: Time.iso8601('1970-01-01T11:00:00Z')),
]

r1 = Response.create responder: 'responder1', event: e1u1, response_entries: [
  ResponseEntry.new(event_entry: e1u1.event_entries[0], stat: 'ok'),
  ResponseEntry.new(event_entry: e1u1.event_entries[1], stat: 'maybe'),
  ResponseEntry.new(event_entry: e1u1.event_entries[2], stat: 'ok'),
  ResponseEntry.new(event_entry: e1u1.event_entries[3], stat: 'no'),
]

r2 = Response.create responder: 'responder2', event: e1u1, response_entries: [
  ResponseEntry.new(event_entry: e1u1.event_entries[0], stat: 'no'),
  ResponseEntry.new(event_entry: e1u1.event_entries[1], stat: 'ok'),
  ResponseEntry.new(event_entry: e1u1.event_entries[2], stat: 'ok'),
  ResponseEntry.new(event_entry: e1u1.event_entries[3], stat: 'maybe'),
]

r3 = Response.create user: u2, event: e2u1, response_entries: [
  ResponseEntry.new(event_entry: e2u1.event_entries[0], stat: 'no'),
  ResponseEntry.new(event_entry: e2u1.event_entries[1], stat: 'ok'),
]

r4 = Response.create user: u1, event: e2u1, response_entries: [
  ResponseEntry.new(event_entry: e2u1.event_entries[0], stat: 'ok'),
  ResponseEntry.new(event_entry: e2u1.event_entries[1], stat: 'no'),
]
