class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :poster
      t.datetime :last_update
      t.string :website, null: false
      t.string :author
      t.string :source_url, null: false
      t.string :hash, null: false
      t.timestamps
    end

      add_index :channels, :slug, unique: true
      add_index :channels, :source_url, unique: true
      add_index :channels, :hash, unique: true

  end
end
