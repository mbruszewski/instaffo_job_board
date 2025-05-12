RSpec.describe 'Api::V1::JobOffersController', type: :request do
  describe 'GET /api/v1/job_offers' do
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

    it 'returns a list of all job_offers' do
      get '/api/v1/job_offers'

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(2)

      expect(json_response[0]['job_name']).to eq(active_job_offer.title)
      expect(json_response[0]['status']).to eq("JobOffer::Event::Activated")
      expect(json_response[0]['hired_count']).to eq(2)
      expect(json_response[0]['rejected_count']).to eq(0)
      # expect(json_response[0]['ongoing_count']).to eq(1)


      expect(json_response[1]['job_name']).to eq(inactive_job_offer.title)
      expect(json_response[1]['status']).to eq("JobOffer::Event::Deactivated")
      expect(json_response[1]['hired_count']).to eq(0)
      expect(json_response[1]['rejected_count']).to eq(0)
      # expect(json_response[1]['ongoing_count']).to eq(0)
    end
  end
end
