class Combatant < ApplicationRecord
  belongs_to :user
  belongs_to :combat
  belongs_to :character

  scope :active, -> { where(active: true) }
end
