require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do

  let(:authenticated_user) {FactoryGirl.create :user}
  let(:company) {FactoryGirl.build_stubbed :company, user: authenticated_user}
  let(:ability) {Ability.new(authenticated_user)}
  let(:vacancy) {FactoryGirl.build_stubbed :vacancy, company: company}
  let(:vacancy_params) {FactoryGirl.attributes_for(:vacancy).stringify_keys}
  before(:each) do
    request.env["HTTP_REFERER"] = "localhost:3000/where_i_came_from"
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(controller).to receive(:current_user).and_return authenticated_user
    allow(Company).to receive(:find).and_return company
    ability.can :manage, :all
  end

  describe "GET #new" do
    it "renders :new template" do
      get :new, company_id: company.id
      expect(response).to render_template :new
    end
  end

  describe "GET #show" do
    before do
      allow(company).to receive_message_chain(:vacancies, :find).and_return vacancy
    end
    it "renders :show template" do
      get :show, company_id: company.id, id: vacancy.id
      expect(response).to render_template :show
    end
  end

  describe "GET #edit" do

    before do
      allow(company).to receive_message_chain(:vacancies, :find).and_return vacancy
    end
    it "renders :edit template" do
      get :edit, company_id: company.id, id: vacancy.id
      expect(response).to render_template :edit
    end
    context "without abilitties to edit" do
      before do
        ability.cannot :update, vacancy
      end

      it "redirects to root_path" do
        get :edit, id: vacancy.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #index" do
    before do
      allow(Vacancy).to receive(:all).and_return [vacancy]
      allow(VacancySearch).to receive_message_chain(:new, :call).and_return [vacancy]
    end
    it "receives new for VacancySearch" do
      expect(VacancySearch).to receive(:new).with([vacancy], nil)
      get :index
    end
    it "renders :index template" do
      get :index
      expect(response).to render_template :index
    end
  end
  describe "POST #create" do
    before do
      allow(Vacancy).to receive(:new).and_return vacancy
      allow(vacancy).to receive(:save).and_return true
    end

    it "redirects to created @vacancy" do
      post :create, company_id: company.id, vacancy: vacancy_params
      expect(response).to redirect_to vacancy_path(vacancy)
    end

    it "sends success message when @vacancy created" do
      post :create, company_id: company.id, vacancy: vacancy_params
      expect(flash[:notice]).to eq('Vacancy was successfully created.')
    end

    it "render :new template when create a @vacancy is fail" do
      allow(vacancy).to receive(:save).and_return false
      post :create, company_id: company.id, vacancy: vacancy_params
      expect(response).to render_template :new
    end

    context "without abilities to create" do
      before do
        ability.cannot :create, Vacancy
      end

      it "redirects to root_path" do
        post :create, company_id: company.id, vacancy: vacancy_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PUT #update" do
    before do
      allow(company).to receive_message_chain(:vacancies, :find).and_return vacancy
    end
    it "receives update with vaccancy_params for @vacancy" do
      expect(vacancy).to receive(:update).with(vacancy_params)
      put :update, company_id: company.id, id: vacancy.id, vacancy: vacancy_params
    end

    it "sends success message when update vacancy a is successfull" do
      allow(vacancy).to receive(:update).and_return true
      put :update, company_id: company.id, id: vacancy.id, vacancy: vacancy_params
      expect(flash[:notice]).to eq 'Vacancy was successfully updated.'
    end

    it "renders :edit template when update vacancy a is fails" do
      allow(vacancy).to receive(:update).and_return false
      put :update, company_id: company.id, id: vacancy.id, vacancy: vacancy_params
      expect(response).to render_template :edit
    end

    context "without abilities to update" do
      before do
        ability.cannot :update, vacancy
      end

      it "redirect to root_path" do
        put :update, company_id: company.id, id: vacancy.id, vacancy: vacancy_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(company).to receive_message_chain(:vacancies, :find).and_return vacancy
    end
    it "receives destroy with no params for @vacancy" do
      expect(vacancy).to receive(:destroy)
      delete :destroy, company_id: company.id, id: vacancy.id
    end

    it "redirects to vacancies_path when vacancy is destroyed" do
      allow(vacancy).to receive(:destroy).and_return true
      delete :destroy, company_id: company.id, id: vacancy.id
      expect(response).to redirect_to vacancies_path
    end

    context "without abilities to destroy" do
      before do
        ability.cannot :destroy, vacancy
      end

      it "redirect to root_path" do
        delete :destroy, company_id: company.id, id: vacancy.id
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
