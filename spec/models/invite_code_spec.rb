require 'rails_helper'

RSpec.describe InviteCode, type: :model do
  subject{FactoryGirl.create :invite_code}
  it {expect(subject).to belong_to(:user)}
end
