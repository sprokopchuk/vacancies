require 'rails_helper'

RSpec.describe Companies::BuildController, type: :controller do
  let(:employer) {FactoryGirl.build_stubbed :employer}
  let(:vacancy) {FactoryGirl.build_stubbed :vacancy}
  let(:company) {FactoryGirl.build_stubbed :company, user: employer}
  let(:company_on_last_step) {FactoryGirl.build_stubbed :company, user: employer, status: steps.last.to_s}
  let(:company_params) {FactoryGirl.attributes_for(:company).stringify_keys}
  let(:steps) {[:add_country, :add_city, :add_info]}
  before do
    allow(Company).to receive(:find).and_return company
  end

  describe "GET #show" do
    it "renders template for step" do
      get :show, :company_id => company.id, id: steps.first
      expect(response).to render_template "companies/build/#{steps.first.to_s}"
    end
  end

  describe "PUT #update" do
    before do
      allow(company).to receive(:save).and_return true
      allow(controller).to receive(:step).and_return steps.first
      company_params.merge!(:status => steps.first.to_s)
    end
    it "receive update with company_params for @company" do
      expect(company).to receive(:update).with(company_params)
      put :update, :company_id => company.id, id: steps.first, company: company_params
    end

    it "render next step if @company is valid" do
      put :update, :company_id => company.id, id: steps.first, company: company_params
      expect(response).to redirect_to company_build_path(:company_id => company.id, id: steps[1].to_s)
    end

    it "render current step if @company is not valid" do
      allow(company).to receive(:save).and_return false
      put :update, :company_id => company.id, id: steps.first, company: company_params
      expect(response).to render_template "companies/build/#{steps.first.to_s}"
    end

  end

end