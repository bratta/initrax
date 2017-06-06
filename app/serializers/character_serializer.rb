class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :hit_points, :initiative_bonus, :roll_automatically, :is_player, :level, :display_order, :user_id

  has_many :combats
end
