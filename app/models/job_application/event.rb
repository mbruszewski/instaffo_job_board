class JobApplication::Event < Event
  STATUS_EVENTS = %w[
    JobApplication::Event::Hired
    JobApplication::Event::Rejected
    JobApplication::Event::Interview
  ].freeze
end
