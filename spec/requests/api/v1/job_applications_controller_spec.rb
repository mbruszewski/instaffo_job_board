RSpec.describe 'Api::V1::JobApplicationsController', type: :request do
  describe 'GET /api/v1/job_applications' do
    let!(:active_job_offer) { create(:job_offer, :active) }
    let!(:activated_job_application_with_hire) do
      create(:job_application, job_offer: active_job_offer) do |job_application|
        create(:job_application_event, :interview, eventable: job_application)
        create(:job_application_event, :note, eventable: job_application)
        create(:job_application_event, :note, eventable: job_application)
        create(:job_application_event, :hired, eventable: job_application)
      end
    end

    let!(:activated_job_application_without_hire) do
      create(:job_application, job_offer: active_job_offer) do |job_application|
        create(:job_application_event, :interview, eventable: job_application)
        create(:job_application_event, :note, eventable: job_application)
        create(:job_application_event, :note, eventable: job_application)
      end
    end

    let!(:activated_job_application_without_interview) do
      create(:job_application, job_offer: active_job_offer) do |job_application|
        create(:job_application_event, :note, eventable: job_application)
        create(:job_application_event, :note, eventable: job_application)
        create(:job_application_event, :hired, eventable: job_application)
      end
    end

    let!(:inactive_job_offer) { create(:job_offer, :inactive) }
    let!(:inactive_job_application) { create(:job_application, job_offer: inactive_job_offer) }


    it 'returns a list of job_applications with activated job_offers' do
      get '/api/v1/job_applications'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(3)

      expect(json_response[0]['job_name']).to eq(active_job_offer.title)
      expect(json_response[0]['candidate_name']).to eq(activated_job_application_with_hire.candidate_name)
      expect(json_response[0]['status']).to eq("JobApplication::Event::Hired")
      expect(json_response[0]['notes_count']).to eq(2)
      expect(json_response[0]['last_interview_date']).to be_present

      expect(json_response[1]['job_name']).to eq(active_job_offer.title)
      expect(json_response[1]['candidate_name']).to eq(activated_job_application_without_hire.candidate_name)
      expect(json_response[1]['status']).to eq("JobApplication::Event::Interview")
      expect(json_response[1]['notes_count']).to eq(2)
      expect(json_response[1]['last_interview_date']).to be_present
    end
  end
end
