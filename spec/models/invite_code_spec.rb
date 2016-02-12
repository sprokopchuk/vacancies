require 'rails_helper'

RSpec.describe InviteCode, type: :model do
  subject{FactoryGirl.create :invite_code}
  let(:manager) {FactoryGirl.create :manager, invite_code: subject.code}
  it {expect(subject).to belong_to(:user)}

  context "#get_user_used_invite" do
    before do
      manager
    end
    it  "return a manager" do
      expect(subject.get_user_used_invite).to eq manager
    end
  end
end
