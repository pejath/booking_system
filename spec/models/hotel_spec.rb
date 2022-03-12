require 'rails_helper'

RSpec.describe Hotel, type: :model do

  describe 'relations' do
    it { is_expected.to have_many(:apartments) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:hotel) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:rating).is_greater_than(0).is_less_than(6) }
  end

  describe '#image' do
    subject { create(:hotel).image }
    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }
  end
end
