class Character < ApplicationRecord
  belongs_to :user
  has_many :combatants, -> { active }, inverse_of: :character
  has_many :combats, -> { active}, through: :combatants

  accepts_nested_attributes_for :combatants

  scope :active, -> { where(active: true) }
end
