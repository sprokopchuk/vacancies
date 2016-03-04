require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do

  let(:authenticated_user) {FactoryGirl.build_stubbed :user}
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
      allow(Vacancy).to receive_message_chain(:unscoped, :find).and_return vacancy
    end
    it "renders :show template" do
      get :show, id: vacancy.id
      expect(response).to render_template :show
    end
  end

  describe "GET #index" do
    before do
      allow(Vacancy).to receive(:all).and_return [vacancy]
      allow(VacancySearch).to receive_message_chain(:new, :call, :page).and_return [vacancy]
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

  describe "POST #attach_resume" do
    before do
      allow(Vacancy).to receive_message_chain(:unscoped, :find).and_return vacancy
      vacancy_params.merge!(file: authenticated_user.resume)
    end

    it "receives attach_resume with file" do
      expect(vacancy).to receive(:attach_resume).with(authenticated_user, authenticated_user.resume.to_s)
      post :attach_resume, id: vacancy.id, company_id: company.id, vacancy: vacancy_params
    end

    it "redirects to @vacancy if resume is attached" do
      allow(vacancy).to receive(:attach_resume).and_return authenticated_user.resume
      post :attach_resume, id: vacancy.id, company_id: company.id, vacancy: vacancy_params
      expect(response).to redirect_to(vacancy_path(vacancy))
    end

    it "sends success message if resume is attached" do
      allow(vacancy).to receive(:attach_resume).and_return authenticated_user.resume
      post :attach_resume, id: vacancy.id, company_id: company.id, vacancy: vacancy_params
      expect(flash[:notice]).to eq('Your resumne was successfully sent.')
    end

    context "without abilities to attach resume" do
      before do
        ability.cannot :attach_resume, vacancy
      end

      it "redirects to root_path" do
        post :attach_resume, id: vacancy.id, company_id: company.id, vacancy: vacancy_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST #close" do
    before do
      allow(company).to receive_message_chain(:vacancies, :find).and_return vacancy
      allow(vacancy).to receive(:close).and_return true
    end

    it "receives close" do
      expect(vacancy).to receive(:close)
      post :close, id: vacancy.id, company_id: company.id
    end

    it "sends a succeful message when vacancy is closed" do
      post :close, id: vacancy.id, company_id: company.id
      expect(flash[:notice]).to eq "Vacancy is closed"
    end

    it "sends a failure message when vacancy is not closed" do
      allow(vacancy).to receive(:close).and_return false
      post :close, id: vacancy.id, company_id: company.id
      expect(flash[:alert]).to eq "Something is wrong. Vacancy is not closed"
    end

    context "without abilities to close a vacancy" do
      before do
        ability.cannot :close, vacancy
      end

      it "redirects to root_path" do
        post :close, id: vacancy.id, company_id: company.id
        expect(response).to redirect_to(root_path)
      end
    end


  end
end
