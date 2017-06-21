RSpec.describe Api::CharactersController, type: :controller do
  login_user

  describe "GET index" do
    it 'returns a json array of characters for the user' do
      get :index, format: :json
      expect(response).to be_success
      result = JSON.parse(response.body)
      expect(result.count).to eq(10)
    end
  end

  describe "GET show" do
    it 'returns json for an individual character' do
      existing_character = Character.first
      get :show, format: :json, params: { id: existing_character.id }
      expect(response).to be_success
      result = JSON.parse(response.body)
      expect(result.keys).to include("name", "hit_points", "roll_automatically")
    end
  end

  describe "POST create" do
    it 'saves a user and returns some json' do
      name = Faker::Pokemon.name
      params = { character: { name: name, level: 5, is_player: true, roll_automatically: false } }
      post :create, format: :json, params: params
      expect(response).to be_success
      new_character = JSON.parse(response.body)
      expect(new_character.keys).to include("id", "name", "user_id")
      expect(new_character["name"]).to eq(name)
      expect(new_character["is_player"]).to eq(true)
      expect(new_character["roll_automatically"]).to eq(false)
      expect(new_character["user_id"]).to eq(user.id)
    end
  end
  
  describe "PUT update" do
    it 'updates a user and returns some json' do
      character = Character.first
      params = JSON.parse(character.to_json, symbolize_names: true)
      new_name = Faker::Pokemon.name
      params[:name] = new_name
      put :update, params: { id: character.id, character: params }, format: :json
      expect(response).to be_success
      character.reload
      expect(character.name).to eq(new_name)
    end
  end
  
  describe "DELETE destroy" do
    it 'sets the active flag instead of hard deleting a character' do
      character = Character.first
      delete :destroy, params: { id: character.id }, format: :json
      expect(response).to be_success
      character.reload
      expect(character.active).to eq(false)
    end
  end
  
  describe "POST order" do
    it 'updates display order for a list of character ids' do
      characters = user.characters.reverse
      params = characters.map.with_index {|c,i| { id: c.id, display_order: i } }
      post :order, params: { characters: { order: params } }, format: :json
      expect(response).to be_success
      characters.each do |character|
        character.reload
        char_param = params.select {|param| param[:id] == character.id}
        expect(char_param).to_not be_empty
        expect(character.display_order).to eq(char_param.first[:display_order])
      end
    end
  end
end