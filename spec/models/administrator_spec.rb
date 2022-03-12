require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe 'validations' do
    subject { FactoryBot.build(:administrator) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
    it { is_expected.to_not allow_value('example.com').for(:email) }
  end
end
