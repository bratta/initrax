# frozen_string_literal: true

class CombatantSerializer < ActiveModel::Serializer
  attributes :id, :hit_points, :notes, :display_order, :user_id, :calculated_roll
  attribute :character, serializer: CharacterSerializer

  belongs_to :combat
  belongs_to :character
end
