# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

robot = Robot.create(name: 'XX1', attributes: { size: '100cm', weight: '10kg', status: 'good conditions', color: 'white', age: '123years' })
robot.update(attributes: { age: '124 years', color: 'dirty white', number_of_eyes: 1, number_of_antennas: 2 })
