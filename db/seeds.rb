# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

robot_1 = Robot.create(name: 'XX1')
robot_2 = Robot.create(name: 'XX2')
robot_1.robot_attributes.create([{ key: 'key_1', value: 'value_1' }, { key: 'key_2', value: 'value_2' }])
robot_2.robot_attributes.create([{ key: 'key_10', value: 'value_10' }, { key: 'key_20', value: 'value_20' }])
