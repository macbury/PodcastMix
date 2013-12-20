class AddJobIdToMedia < ActiveRecord::Migration
  def change
    add_column :media, :job_id, :string
  end
end
