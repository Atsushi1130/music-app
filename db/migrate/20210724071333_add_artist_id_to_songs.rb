class AddArtistIdToSongs < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :artist_id, :integer
  end
end
