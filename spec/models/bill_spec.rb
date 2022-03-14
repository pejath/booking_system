require 'rails_helper'

RSpec.describe Bill, type: :model do
  subject { create(:bill) }

  describe 'enum' do
    it { should define_enum_for(:status).with_values(%i[pending paid canceled]) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:request) }
    it { is_expected.to belong_to(:apartment) }
  end

  describe 'validations' do
    it { is_expected.to monetize(:final_price) }
  end

  describe 'class_methods' do
    describe '#calculate_final_price' do
      it 'creates Bill' do
        expect { Bill.create(request: create(:request), apartment: create(:apartment)) }.to change(Bill, :count).by(1)
        expect { Bill.create(request: create(:request), apartment: create(:apartment), final_price: 100) }.to change(Bill, :count).by(1)
      end
    end
  end
end
