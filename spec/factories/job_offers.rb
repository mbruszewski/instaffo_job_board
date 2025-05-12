FactoryBot.define do
  factory :job_offer do
    title { Faker::Job.title }
    description { Faker::Job.field }

    trait :active do
      after(:create) do |job_offer|
        create(:job_offer_event, :activated, eventable: job_offer)
      end
    end

    trait :inactive do
      after(:create) do |job_offer|
        create(:job_offer_event, :deactivated, eventable: job_offer)
      end
    end
  end
end
