# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(
	name: 'Jane Doe',
	email: 'test@gmail.com',
	password: '123456',
	password_confirmation: '123456'
	)

Event.create(
	name: 'learn ruby',
	location: 'boelter',
	start_time: Time.now,
	end_time: Time.now,
  	description:
    %{  Ruby is the fastest growing and most exciting dynamic language
        out there. If you need to get working programs delivered fast,
        you should add Ruby to your toolbox. }
  )

Event.create(
	name: 'Go to Disneyland',
	location: 'Disneyland',
	start_time: Time.now,
	end_time: Time.now, 
  	description:
    %{The Hill is going to Disneyland! }
  )