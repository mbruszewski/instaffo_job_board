FactoryBot.define do
  factory :job_application do
    candidate_name { Faker::Name.name }
    job_offer { association(:job_offer) }
  end
end
