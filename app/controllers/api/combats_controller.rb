# frozen_string_literal: true

module Api
  class CombatsController < ApplicationController
    respond_to :json
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    expose :combats, -> { current_user.combats.where(active: true).order('id ASC') }
    expose :combat

    def index
      respond_with :api, combats
    end

    def show
      respond_with :api, combat
    end

    def names
      combats = current_user.combats.select('id, name').where(active: true).order('id ASC')
      combat_names = combats.map { |c| { id: c.id, name: c.name } }
      respond_with :api, combat_names
    end

    def create
      respond_with :api, combats.create(combat_params)
    end

    def update
      combat.update(combat_params)
      respond_with :api, combat
    end

    def destroy
      combat.active = false
      combat.save
      respond_with :api, combat
    end

    private

    def combat_params
      combatants_attributes = %i[id user_id hit_points notes display_order
                                 active character_id calculated_roll]
      params.require(:combat).permit(:id, :user_id, :name, :active,
                                     combatants_attributes: combatants_attributes)
    end
  end
end
