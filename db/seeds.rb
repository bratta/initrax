# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create username: "bratta", email: "tgourley@gmail.com", password: "changeme"
characters = Character.create([
  { user: user, name: "Vegeta", hit_points: 42, initiative_bonus: 5, roll_automatically: false, is_player: true, level: 13, display_order: 0 },
  { user: user, name: "Goku", hit_points: 142, initiative_bonus: 2, roll_automatically: true, is_player: false, level: 13, display_order: 1 }
])
combat = Combat.create(user: user, name: "Combat 1")
combatants = Combatant.create([
  { user: user, combat: combat, character: characters[0], hit_points: characters[0].hit_points, display_order: 0 },
  { user: user, combat: combat, character: characters[1], hit_points: characters[1].hit_points, display_order: 1 }
])
