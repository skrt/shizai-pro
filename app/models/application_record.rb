class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Assign UUID v7 as primary key before creating any record
  before_create :assign_uuid_v7

  private

  def assign_uuid_v7
    self.id ||= UUIDv7.generate
  end
end
