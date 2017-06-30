# frozen_string_literal: true

RSpec.describe Api::CombatantsController, type: :controller do
  login_user

  describe 'PUT update' do
    it 'updates a combatant and returns some json' do
      combatant = Combatant.first
      params = JSON.parse(combatant.to_json, symbolize_names: true)
      new_notes = Faker::HarryPotter.quote
      params[:notes] = new_notes
      put :update, params: { id: combatant.id, combatant: params }, format: :json
      expect(response).to be_success
      combatant.reload
      expect(combatant.notes).to eq(new_notes)
    end
  end

  describe 'DELETE destroy' do
    it 'sets the active flag instead of hard deleting a combatant' do
      combatant = Combatant.first
      delete :destroy, params: { id: combatant.id }, format: :json
      expect(response).to be_success
      combatant.reload
      expect(combatant.active).to eq(false)
    end
  end

  describe 'POST order' do
    it 'updates display order for a list of combatant ids' do
      combatants = user.combats.first.combatants.reverse
      params = combatants.map.with_index { |c, i| { id: c.id, display_order: i } }
      post :order, params: { combatants: { order: params } }, format: :json
      expect(response).to be_success
      combatants.each do |combatant|
        combatant.reload
        char_param = params.select { |param| param[:id] == combatant.id }
        expect(char_param).to_not be_empty
        expect(combatant.display_order).to eq(char_param.first[:display_order])
      end
    end
  end
end
