FactoryBot.define do
  factory :job_offer_event, class: Event do
    eventable { association(:job_offer) }
    data { "" }

    trait :activated do
      type { JobOffer::Event::Activated }
    end

    trait :deactivated do
      type { JobOffer::Event::Deactivated }
    end
  end

  factory :job_application_event, class: Event do
    eventable { association(:job_application) }
    data { "" }

    trait :hired do
      type { JobApplication::Event::Hired }
      data { { hire_date: Time.current } }
    end

    trait :interview do
      type { JobApplication::Event::Interview }
      data { { interview_date: Time.current } }
    end

    trait :note do
      type { JobApplication::Event::Note }
      data { { content: "This is a note." } }
    end

    trait :rejected do
      type { JobApplication::Event::Rejected }
    end
  end
end
