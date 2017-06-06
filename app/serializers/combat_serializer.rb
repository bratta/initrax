class CombatSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id
  attribute :combatants, serializer: CombatantSerializer

  has_many :combatants

  def combatants
    object.combatants.order("display_order ASC")
  end
end
