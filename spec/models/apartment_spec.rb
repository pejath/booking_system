require 'rails_helper'

RSpec.describe Apartment, type: :model do
  describe 'enum' do
    it { should define_enum_for(:apartment_class).with_values(%i[A B C Luxe]) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:hotel) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:apartment) }
    it { is_expected.to monetize(:price) }
    it { is_expected.to validate_presence_of(:room_number) }
    it { is_expected.to validate_numericality_of(:room_number) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it { is_expected.to validate_uniqueness_of(:room_number).scoped_to(:hotel_id) }
  end

  describe '#images' do
    subject { create(:apartment).images }
    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::Many) }
  end
end
