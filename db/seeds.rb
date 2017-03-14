# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

d1=Device.create(title: 'Raptor Reloaded')
d2=Device.create(title: 'Phoenix')
d3=Device.create(title: 'UnLimbited Arm')
d4=Device.create(title: 'Python')

m1=Member.create(first_name: 'Joe', last_name: 'C', email: 'joecross@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456', admin: true)
m2=Member.create(first_name: 'Amanda', last_name: 'J', email: 'joecross.2@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')
m3=Member.create(first_name: 'Maker1', last_name: 'J', email: 'joecross.3@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')
m10=Member.create(first_name: 'Maker2', last_name: 'J', email: 'joecross.10@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')
m4=Member.create(first_name: 'Recipient1', last_name: 'T', email: 'joecross.4@gmail.com', city: 'Budapest', country: 'Hungary', password: '123456', password_confirmation: '123456')
m5=Member.create(first_name: 'Recipient2', last_name: 'T', email: 'joecross.5@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')
m6=Member.create(first_name: 'Recipient3', last_name: 'T', email: 'joecross.6@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')
m7=Member.create(first_name: 'Recipient4', last_name: 'T', email: 'joecross.7@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')
m8=Member.create(first_name: 'Recipient5', last_name: 'T', email: 'joecross.8@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')
m9=Member.create(first_name: 'Recipient6', last_name: 'T', email: 'joecross.9@gmail.com', city: 'San Diego', country: 'USA', password: '123456', password_confirmation: '123456')


r1=Request.create(member_id: m1.id, device_id: d2.id, side: 'Left', stage: 'Open', shipping_address: 'San Diego, USA')
r2=Request.create(member_id: m5.id, device_id: d3.id, side: 'Right', stage: 'Open', shipping_address: 'Budapest, Hungary')
r3=Request.create(member_id: m6.id, device_id: d2.id, side: 'Left', stage: 'Matched', shipping_address: 'Los Angeles, USA')
r4=Request.create(member_id: m7.id, device_id: d4.id, side: 'Left', stage: 'Completed', shipping_address: '1351 La Mancha Pl\nChula Vista, CA, 91910\nUSA')
r5=Request.create(member_id: m8.id, device_id: d4.id, side: 'Left', stage: 'Completed', shipping_address: 'London, England')
r6=Request.create(member_id: m9.id, device_id: d4.id, side: 'Right', stage: 'Open', shipping_address: 'San Francisco, CA')
r7=Request.create(member_id: m9.id, device_id: d4.id, side: 'Left', stage: 'Completed', shipping_address: '612 First St, Miami, CA, 92109')
r8=Request.create(member_id: m4.id, device_id: d2.id, side: 'Left', stage: 'Matched', shipping_address: 'San Diego, USA')
r9=Request.create(member_id: m4.id, device_id: d2.id, side: 'Right', stage: 'Matched', shipping_address: 'Dallas, TX')
r10=Request.create(member_id: m6.id, device_id: d4.id, side: 'Left', stage: 'Completed', shipping_address: 'San Diego, USA')
r11=Request.create(member_id: m6.id, device_id: d4.id, side: 'Left', stage: 'Completed', shipping_address: 'Madrid, Spain')
r12=Request.create(member_id: m6.id, device_id: d4.id, side: 'Left', stage: 'Completed', shipping_address: 'Accra, Ghana')

o1=Offer.create(request_id: r1.id, member_id: m3.id, stage: 'Offered')
o2=Offer.create(request_id: r3.id, member_id: m3.id, stage: 'Accepted')
o3=Offer.create(request_id: r1.id, member_id: m10.id, stage: 'Declined')
o4=Offer.create(request_id: r4.id, member_id: m1.id, stage: 'Abandoned')
o5=Offer.create(request_id: r8.id, member_id: m10.id, stage: 'Accepted')
o6=Offer.create(request_id: r9.id, member_id: m1.id, stage: 'Accepted')
o7=Offer.create(request_id: r4.id, member_id: m2.id, stage: 'Accepted')
o8=Offer.create(request_id: r5.id, member_id: m1.id, stage: 'Accepted')
o9=Offer.create(request_id: r10.id, member_id: m10.id, stage: 'Declined')
o12=Offer.create(request_id: r10.id, member_id: m9.id, stage: 'Declined')
o10=Offer.create(request_id: r11.id, member_id: m10.id, stage: 'Declined')
o11=Offer.create(request_id: r12.id, member_id: m10.id, stage: 'Declined')