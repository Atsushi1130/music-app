class AddUserIdToSongs < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :user_id, :integer
  end
end
