RSpec.describe Api::CombatsController, type: :controller do
  login_user

  describe "GET index" do
    it 'returns a json array of combats for the user' do
      get :index, format: :json
      expect(response).to be_success
      result = JSON.parse(response.body)
      expect(result.count).to eq(2)
    end
  end

  describe "GET show" do
    it 'returns json for an individual combat' do
      existing_combat = user.combats.first
      get :show, format: :json, params: { id: existing_combat.id }
      expect(response).to be_success
      result = JSON.parse(response.body)
      expect(result.keys).to include("name")
    end
  end

  describe "POST create" do
    it 'saves a combat and returns some json' do
      combat_name = Faker::Zelda.location
      character = Character.first
      params = { combat: {
        name: combat_name, combatants_attributes: [{
            hit_points: 10, notes: Faker::RickAndMorty.quote, calculated_roll: 10, character_id: character.id
          }]
        }
      }
      post :create, format: :json, params: params
      expect(response).to be_success
      new_combat = JSON.parse(response.body)
      expect(new_combat.keys).to include("id", "name", "combatants")
      expect(new_combat["name"]).to eq(combat_name)
      expect(new_combat["user_id"]).to eq(user.id)
      expect(new_combat["combatants"].count).to eq(1)
      expect(new_combat["combatants"][0]["character"]["id"]).to eq(character.id)
    end
  end
  
  describe "PUT update" do
    it 'updates a combat and returns some json' do
      combat = Combat.first
      params = JSON.parse(combat.to_json, symbolize_names: true)
      new_name = Faker::Zelda.location
      params[:name] = new_name
      put :update, params: { id: combat.id, combat: params }, format: :json
      expect(response).to be_success
      combat.reload
      expect(combat.name).to eq(new_name)
    end
  end
  
  describe "DELETE destroy" do
    it 'sets the active flag instead of hard deleting a combat' do
      combat = Combat.first
      delete :destroy, params: { id: combat.id }, format: :json
      expect(response).to be_success
      combat.reload
      expect(combat.active).to eq(false)
    end
  end

  describe "GET names" do
    it 'returns a light payload of ids and names for combat sessions' do
      get :names, format: :json
      expect(response).to be_success
      names = JSON.parse(response.body)
      expect(names.count).to eq(2)
      expect(names[0].keys).to include('id', 'name')
      expect(names[1].keys).to include('id', 'name')
    end
  end
end