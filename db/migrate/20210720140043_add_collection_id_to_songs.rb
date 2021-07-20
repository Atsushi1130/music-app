class AddCollectionIdToSongs < ActiveRecord::Migration[6.1]
  def change
    add_column :songs, :collectionId, :integer
  end
end
