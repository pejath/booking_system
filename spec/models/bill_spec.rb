require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe 'enum' do
    it { should define_enum_for(:status).with_values(%i[pending paid canceled]) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:client) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:bill) }
    it { is_expected.to monetize(:final_price) }
    it { is_expected.to validate_numericality_of(:final_price).is_greater_than(0) }

  end

  describe 'class_methods' do
    describe '#final_price' do
      it 'creates Bill' do
        expect{ Bill.final_price(create(:request), create(:apartment)) }.to change(Bill, :count).by(1)
      end
    end
  end
end
