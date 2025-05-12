# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

return if JobOffer.count > 0

JobOffer.create!(title: "Software Engineer", description: "Develop and maintain software applications.").tap do |job_offer|
  job_offer.events.create!(type: "JobOffer::Event::Activated")
  job_offer.job_applications.create!(candidate_name: "John Doe").tap do |job_application|
    job_application.events.create!(type: "JobApplication::Event::Interview", data: { interview_date: Time.current })
    job_application.events.create!(type: "JobApplication::Event::Note", data: { content: "First round interview" })
    job_application.events.create!(type: "JobApplication::Event::Note", data: { content: "Second round interview" })
    job_application.events.create!(type: "JobApplication::Event::Hired", data: { hire_date: Time.current })
  end
end

JobOffer.create!(title: "Data Scientist", description: "Analyze and interpret complex data.").tap do |job_offer|
  job_offer.events.create!(type: "JobOffer::Event::Activated")
  job_offer.job_applications.create!(candidate_name: "Jane Smith").tap do |job_application|
    job_application.events.create!(type: "JobApplication::Event::Interview", data: { interview_date: Time.current })
    job_application.events.create!(type: "JobApplication::Event::Note", data: { content: "Technical interview" })
    job_application.events.create!(type: "JobApplication::Event::Note", data: { content: "Final interview" })
  end
  job_offer.job_applications.create!(candidate_name: "Alice Johnson").tap do |job_application|
    job_application.events.create!(type: "JobApplication::Event::Interview", data: { interview_date: Time.current })
    job_application.events.create!(type: "JobApplication::Event::Note", data: { content: "Technical interview" })
    job_application.events.create!(type: "JobApplication::Event::Rejected", data: { hire_date: Time.current })
  end
end

JobOffer.create!(title: "Product Manager", description: "Lead product development and strategy.").tap do |job_offer|
  job_offer.events.create!(type: "JobOffer::Event::Deactivated")
  job_offer.job_applications.create!(candidate_name: "Bob Brown").tap do |job_application|
    job_application.events.create!(type: "JobApplication::Event::Interview", data: { interview_date: Time.current })
    job_application.events.create!(type: "JobApplication::Event::Note", data: { content: "Product strategy discussion" })
    job_application.events.create!(type: "JobApplication::Event::Note", data: { content: "Final interview" })
  end
end
