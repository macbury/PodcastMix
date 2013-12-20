class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :file
      t.string :waveform
      t.integer :duration
      t.string :mime_type
      t.string :hash_sum
      t.integer :size
      t.string :source_url, null: false

      t.timestamps
    end
  end
end
