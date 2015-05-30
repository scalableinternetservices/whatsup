# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Documentation for Faker: http://www.rubydoc.info/github/stympy/faker/Faker
require 'faker'

number_of_events = 50

User.create!(
	name: Faker::Name.name,
	email: Faker::Internet.safe_email(name = nil),
	password: '123456',
	password_confirmation: '123456'
	)

number_of_events.times do |x|
	Event.create!(
	name: 'Test Event' +  x.to_s,
	location: 'New York',
	start_time: Time.new(2016),
	end_time: Time.new(2020), 
  	description: Faker::Hacker.say_something_smart
  )
end
