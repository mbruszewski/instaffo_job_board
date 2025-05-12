class JobApplication < ApplicationRecord
  include Eventable

  belongs_to :job_offer

  scope :with_active_jobs, -> {
    joins(:job_offer).where(job_offer_id: JobOffer.active)
  }

  validates :candidate_name, presence: true
end
