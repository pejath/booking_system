require 'rails_helper'

RSpec.describe Client, type: :model do

  describe 'relations' do
    it { is_expected.to have_many(:requests) }
    it { is_expected.to have_many(:bills) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:client) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:surname) }
    it { is_expected.to validate_presence_of(:birthdate) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('2000.01.18').for(:birthdate) }
    it { is_expected.to_not allow_value('01.18').for(:birthdate) }
    it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
  end
end
