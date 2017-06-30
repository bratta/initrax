# frozen_string_literal: true

module Api
  class CharactersController < ApplicationController
    respond_to :json
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    expose :characters, -> { current_user.characters.where(active: true).order('display_order ASC') }
    expose :character

    def index
      respond_with :api, characters
    end

    def show
      respond_with :api, character
    end

    def create
      new_character = character_params
      new_character[:display_order] = next_display_order
      respond_with :api, characters.create(new_character)
    end

    def update
      character.update(character_params)
      respond_with :api, character
    end

    def destroy
      character.active = false
      character.save
      respond_with :api, character
    end

    def order
      order_params[:order].each do |order_param|
        char = Character.where(id: order_param[:id], user_id: current_user.id, active: true).first
        char&.update_attribute(:display_order, order_param[:display_order])
      end
      render json: { status: :ok, message: :success }
    end

    private

    def character_params
      params.require(:character).permit(:id, :user_id, :name, :hit_points, :initiative_bonus,
                                        :roll_automatically, :is_player, :level, :active)
    end

    def order_params
      params[:characters][:order] ||= []
      params.require(:characters).permit(order: %i[id display_order])
    end

    def next_display_order
      character = current_user.characters.where(active: true).maximum(:display_order) || -1
      character + 1
    end
  end
end
