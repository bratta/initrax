class Api::CombatsController < ApplicationController
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
    combats = current_user.combats.select('id, name').where(active: true).order('id ASC');
    respond_with :api, combats.map {|c| { id: c.id, name: c.name } }
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
    params.require(:combat).permit(:id, :user_id, :name, :active, combatants_attributes: [:id, :user_id, :hit_points, :notes, :display_order, :active, :character_id, :calculated_roll])
  end
end
