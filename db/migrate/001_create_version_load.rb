class CreateVersionLoad < ActiveRecord::Migration
  def self.up
    create_table :version_loads do |t|
      t.column :name, :string
      t.column :weeks_before, :integer
      t.column :weeks_after, :integer
    end
    add_column :versions, :version_load_id, :integer
    VersionLoad.create(:name => '1', :weeks_before => 0, :weeks_after => 0)
    VersionLoad.create(:name => '2', :weeks_before => 0, :weeks_after => 1)
    VersionLoad.create(:name => '3', :weeks_before => 0, :weeks_after => 2)
    Version.update_all("version_load_id = 1")
  end

  def self.down
    drop_table :version_loads
    remove_column :versions, :version_load_id
  end
end
