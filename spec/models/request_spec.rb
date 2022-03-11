require 'rails_helper'

RSpec.describe Request, type: :model do
  subject { create(:request) }

  describe 'enum' do
    it { should define_enum_for(:status).with_values(%i[pending in_progress approved canceled]) }
    it { should define_enum_for(:apartment_class).with_values(%i[A B C Luxe]) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:client) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:check_in_date) }
    it { is_expected.to validate_presence_of(:eviction_date) }
    it { is_expected.to validate_presence_of(:number_of_beds) }
    it { is_expected.to validate_presence_of(:apartment_class) }
    it { is_expected.to validate_numericality_of(:number_of_beds).is_greater_than(0) }
    it { is_expected.to allow_value('2000.01.18 12:00').for(:check_in_date) }
    it { is_expected.to allow_value('2000.01.19 12:00').for(:eviction_date) }
  end

  describe 'class_methods' do
    describe '#period' do
      it '' do
        Bill.final_price(create(:request, residence_time: 'P1DT', check_in_date: '2022-12-12 13:00', eviction_date: '2022-12-13 13:00'), create(:apartment, price: 1))
        expect(Bill.last.final_price_cents).to eq(10000)
      end
    end
  end
end
