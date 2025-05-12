RSpec.describe JobApplication, type: :model do
  describe 'associations' do
    it { should have_many(:events) }
    it { should belong_to(:job_offer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:candidate_name) }
  end

  describe 'factory' do
    it 'is valid' do
      expect(FactoryBot.build(:job_application)).to be_valid
    end
  end
end
