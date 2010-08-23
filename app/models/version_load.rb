class VersionLoad < ActiveRecord::Base
  has_many :versions

  validates_numericality_of :weeks_before, :only_integer => true
  validates_numericality_of :weeks_after, :only_integer => true
end
