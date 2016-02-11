require 'rails_helper'

RSpec.describe AppliedJob, type: :model do
  subject {FactoryGirl.create :applied_job}
  it {expect(subject).to belong_to :user}
  it {expect(subject).to belong_to :vacancy}
end
