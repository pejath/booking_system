require 'rails_helper'

RSpec.describe Client, type: :model do

  describe 'relations' do
    it { is_expected.to have_many(:requests) }
    it { is_expected.to have_many(:bills).through(:requests) }
  end

  describe 'validations' do
    subject { FactoryBot.build(:client) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('2000.01.18').for(:birthdate) }
    it { is_expected.to allow_value('').for(:birthdate) }
    it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
  end
end
