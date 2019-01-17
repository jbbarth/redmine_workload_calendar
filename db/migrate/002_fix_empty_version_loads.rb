class FixEmptyVersionLoads < ActiveRecord::Migration[4.2]
  def self.up
    Version.open.where(:version_load_id => nil).each do |version|
      version.version_load_id = VersionLoad.first.id
      version.save
    end
  end

  def self.down
  end
end
