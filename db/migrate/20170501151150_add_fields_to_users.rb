class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :username, :string
    add_column :users, :homepage, :string
    add_column :users, :twitter, :string
    add_column :users, :mastodon, :string
    add_column :users, :facebook, :string
  end
end
