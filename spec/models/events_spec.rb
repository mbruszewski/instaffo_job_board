RSpec.describe Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:eventable_id) }
    it { should validate_presence_of(:eventable_type) }
  end
end
