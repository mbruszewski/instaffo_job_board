class JobOffer::Event < Event
  STATUS_EVENTS = %w[
    JobOffer::Event::Activated
    JobOffer::Event::Deactivated
  ].freeze
end
