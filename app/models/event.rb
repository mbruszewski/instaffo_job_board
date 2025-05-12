class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true

  validates :eventable_type, presence: true
  validates :eventable_id, presence: true
end
