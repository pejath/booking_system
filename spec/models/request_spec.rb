require 'rails_helper'

RSpec.describe Request, type: :model do
  subject { create(:request, check_in_date: '2022-12-12 13:00', eviction_date: '2022-12-13 13:00') }

  describe 'enum' do
    it { should define_enum_for(:status).with_values(%i[pending in_progress approved canceled]) }
    it { should define_enum_for(:apartment_class).with_values(%i[A B C Luxe]) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:client) }
    it { is_expected.to have_one(:bill) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:check_in_date) }
    it { is_expected.to validate_presence_of(:eviction_date) }
    it { is_expected.to validate_presence_of(:number_of_beds) }
    it { is_expected.to validate_numericality_of(:number_of_beds).is_greater_than(0) }
    it { is_expected.to allow_value('2000.01.18 12:00').for(:check_in_date) }
    it { is_expected.to allow_value('2000.01.19 12:00').for(:eviction_date) }
  end

  describe 'custom validations' do
    it 'check_residence_time without check_in_date' do
      request = build(:request, check_in_date: nil)
      expect(request).to_not be_valid
    end

    it 'check_residence_time without eviction_date' do
      request = build(:request, eviction_date: nil)
      expect(request).to_not be_valid
    end

    it 'check_residence_time without check_in_date' do
      request = build(:request, eviction_date: '2000.01.18 12:00', check_in_date: '2000.01.18 12:00')
      expect(request).to_not be_valid
    end
  end

  describe 'class_methods' do
    describe '#period' do
      it 'returns correct residence_time in ISO8601 format' do
        expect(subject.residence_time).to eq('P1D')
      end
    end
  end
end
