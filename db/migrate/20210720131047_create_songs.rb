class CreateSongs < ActiveRecord::Migration[6.1]
  def change
    create_table :songs do |t|
      t.integer :trackId
      t.text :artistName
      t.text :collectionName
      t.text :trackName

      t.timestamps
    end
  end
end
