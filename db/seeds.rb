# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TimesheetEntry.create( [{entry_date: '2019-04-29', start_time: '10:00', finish_time: '17:00' },
                        {entry_date: '2019-04-16', start_time: '12:00', finish_time: '20:15' },
                        {entry_date: '2019-04-17', start_time: '04:00', finish_time: '21:30' },
                        {entry_date: '2019-04-20', start_time: '15:00', finish_time: '20:00' }])