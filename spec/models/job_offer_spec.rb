RSpec.describe JobOffer, type: :model do
  describe 'associations' do
    it { should have_many(:events) }
    it { should have_many(:job_applications).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'factory' do
    it 'is valid' do
      expect(FactoryBot.build(:job_offer)).to be_valid
    end
  end

  describe 'scopes' do
    let!(:active_job_offer) { create(:job_offer, :active) }
    let!(:inactive_job_offer) { create(:job_offer, :inactive) }
    let!(:activated_inactive_job_offer) do
      create(:job_offer, :inactive) do |job_offer|
        create(:job_offer_event, :activated, eventable: job_offer)
      end
    end
    let!(:deactivated_active_job_offer) do
      create(:job_offer, :active) do |job_offer|
        create(:job_offer_event, :deactivated, eventable: job_offer)
      end
    end

    describe '.active' do
      it 'returns only active job offers' do
        expect(JobOffer.active).to include(active_job_offer, activated_inactive_job_offer)
        expect(JobOffer.active).not_to include(inactive_job_offer, deactivated_active_job_offer)
      end
    end

    describe '.inactive' do
      it 'returns only inactive job offers' do
        expect(JobOffer.inactive).to include(inactive_job_offer, deactivated_active_job_offer)
        expect(JobOffer.inactive).not_to include(active_job_offer, activated_inactive_job_offer)
      end
    end
  end
end
