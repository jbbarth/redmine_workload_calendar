class VersionLoad < ActiveRecord::Base
  include Redmine::SafeAttributes

  has_many :versions

  validates_numericality_of :weeks_before, :only_integer => true
  validates_numericality_of :weeks_after, :only_integer => true

  safe_attributes :name, :weeks_before, :weeks_after
end
