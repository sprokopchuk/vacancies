require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:employer) {FactoryGirl.build_stubbed :employer}
  let(:vacancy) {FactoryGirl.build_stubbed :vacancy}
  let(:company) {FactoryGirl.build_stubbed :company, user: employer}
  let(:company_params) {FactoryGirl.attributes_for(:company).stringify_keys}
  let(:ability) {Ability.new(employer)}
  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(controller).to receive(:current_user).and_return employer
    allow(Company).to receive(:find).and_return company
    ability.can :manage, :all
  end

  describe "GET #show" do
    it "receives vacancies for @company" do
      expect(company).to receive_message_chain(:vacancies, :page)
      get :show, id: company.id
    end

    it "renders a :show template" do
      get :show, id: company.id
      expect(response).to render_template :show
    end

    context "without abilities to read" do
      before do
        ability.cannot :read, company
      end

      it "renders to root_path" do
        get :show, id: company.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    it "renders a :edit template" do
      get :edit, id: company.id
      expect(response).to render_template :edit
    end

    context "without abilities to update" do
      before do
        ability.cannot :update, company
      end
      it "redirects to root_path" do
        get :edit, id: company.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PUT #update" do
    before do
      allow(company).to receive(:update).and_return true
    end
    it "receives a update for company" do
      expect(company).to receive(:update).with(company_params)
      put :update, id: company.id, company: company_params
    end

    it "redirects to @company after successful update" do
      put :update, id: company.id, company: company_params
      expect(response).to redirect_to company_path(company)
    end

    it "sends a successful message after update" do
      put :update, id: company.id, company: company_params
      expect(flash[:notice]).to eq "Information about company was successfully updated"
    end

    it "renders :edit template if update is fail" do
      allow(company).to receive(:update).and_return false
      put :update, id: company.id, company: company_params
      expect(response).to render_template :edit
    end

    context "without abilities to update" do
      before do
        ability.cannot :update, company
      end

      it "redirects to root_path" do
        put :update, id: company.id, company: company_params
        expect(response).to redirect_to root_path
      end
    end
  end
end