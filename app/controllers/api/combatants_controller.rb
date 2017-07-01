# frozen_string_literal: true

module Api
  class CombatantsController < ApplicationController
    respond_to :json
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    expose :combatant

    def update
      combatant.update(combatant_params)
      respond_with :api, combatant
    end

    def destroy
      combatant.active = false
      combatant.save
      respond_with :api, combatant
    end

    def order
      order_params[:order].each do |order_param|
        combatant = Combatant.where(id: order_param[:id], user_id: current_user.id, active: true).first
        combatant&.update_attribute(:display_order, order_param[:display_order])
      end
      render json: { status: :ok, message: :success }
    end

    private

    def combatant_params
      params.require(:combatant).permit(:id, :user_id, :hit_points, :notes, :display_order, :active)
    end

    def order_params
      params[:combatants][:order] ||= []
      params.require(:combatants).permit(order: %i[id display_order])
    end
  end
end
