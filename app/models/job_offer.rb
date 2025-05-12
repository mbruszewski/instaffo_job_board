class JobOffer < ApplicationRecord
  include Eventable

  has_many :job_applications, dependent: :destroy

  scope :active, -> { by_last_status_event("JobOffer::Event::Activated") }
  scope :inactive, -> { by_last_status_event("JobOffer::Event::Deactivated") }

  validates :title, presence: true
end
