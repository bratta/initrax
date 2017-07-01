# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user, username: Faker::Pokemon.name) }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of(:username).case_insensitive }

  it { should have_many :characters }
  it { should have_many :combats }
  it { should have_many :combatants }

  describe '#to_json_ui' do
    it 'has the expected json format' do
      expect(subject.to_json_ui).to eq({
        id: subject.id,
        username: subject.username,
        email: subject.email,
        homepage: subject.homepage,
        facebook: subject.facebook,
        twitter: subject.twitter,
        mastodon: subject.mastodon,
        avatar_url: subject.avatar_url
      }.to_json)
    end
  end

  describe '#avatar_url' do
    it 'formats the url for gravatar' do
      user = FactoryGirl.build(:user, email: Faker::Internet.email)
      md5 = Digest::MD5.new.hexdigest(user.email)
      expect(user.avatar_url).to eq "https://www.gravatar.com/avatar/#{md5}?s=48"
    end
  end

  describe '#update_without_password' do
    it 'filters out passwords if empty' do
      username = Faker::Pokemon.name
      params = { username: username, password: '', password_confirmation: '' }
      allow(subject).to receive(:update_attributes).with(username: username).and_return(true)
      allow(subject).to receive(:clean_up_passwords)
      subject.update_without_password(params)
    end
  end
end
