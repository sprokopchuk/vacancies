require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  subject {FactoryGirl.create :vacancy}
  let(:opened_vacancies) {FactoryGirl.create_list(:vacancy, 3)}
  let(:archived_vacancies) {FactoryGirl.create_list(:archived_vacancy, 3)}
  it {expect(subject).to validate_presence_of(:title)}
  it {expect(subject).to validate_presence_of(:description)}
  it {expect(subject).to validate_presence_of(:deadline)}
  it {expect(subject).to validate_presence_of(:city)}
  it {expect(subject).to validate_presence_of(:country)}
  it {expect(subject).to belong_to(:company)}
  it {expect(subject).to belong_to(:speciality)}

  context "by default" do
    it "return the list of opened vacancies" do
      expect(Vacancy.all).to match_array(opened_vacancies)
    end

    it "doesn't return the list of opened vacancies" do
      expect(Vacancy.all).not_to match_array(archived_vacancies)
    end
  end

  context ".archived" do
    it "return the list of archived vacancies" do
      expect(Vacancy.archived).to match_array(archived_vacancies)
    end

    it "doesn't return the list of archived vacancies" do
      expect(Vacancy.archived).not_to match_array(opened_vacancies)
    end
  end
end
