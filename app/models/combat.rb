class Combat < ApplicationRecord
  belongs_to :user
  has_many :combatants, -> { active }, inverse_of: :combat
  has_many :characters, -> { active }, through: :combatants

  accepts_nested_attributes_for :combatants

  scope :active, -> { where(active: true) }
end
