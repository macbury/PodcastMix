class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer  :channel_id, null: false
      t.string   :title, null: false
      t.text     :description, null: false
      t.datetime :published_at, null: false
      t.string   :link, null: false
      t.string   :guid, null: false
      t.integer  :media_id, null: false
      t.timestamps
    end

    add_index :episodes, :channel_id
  end
end
