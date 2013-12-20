class AddPosterSourceUrlToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :poster_source_url, :string
  end
end
