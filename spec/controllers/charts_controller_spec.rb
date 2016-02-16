require 'rails_helper'

RSpec.describe Vacancies::ChartsController, type: :controller do

  let(:admin) {FactoryGirl.build_stubbed :admin}
  let(:company) {FactoryGirl.build_stubbed :company}
  let(:ability) {Ability.new(admin)}
  let(:chart_form) {ChartForm.new params: params}
  let(:params) {{company_id:  company.id, :from => 14.days.ago.to_s, :to => Date.current.to_s}}
  before(:each) do
    request.env["HTTP_REFERER"] = "localhost:3000/where_i_came_from"
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(controller).to receive(:current_user).and_return admin
    ability.can :manage, :all
  end

  describe "GET #show" do
    it "renders :show template" do
      get :show
      expect(response).to render_template :show
    end

    it "receives new for @chart_form" do
      expect(ChartForm).to receive(:new)
      get :show
    end
    context "without abilities to read" do
      before do
        ability.cannot :read, :chart
      end

      it "redirects to root_path" do
        get :show
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    before do
      allow(ChartForm).to receive(:new).and_return chart_form
      allow(chart_form).to receive(:graph_data).and_return ""
    end
    it "receives new for @chart_form with params" do
      expect(ChartForm).to receive(:new).with({params: params})
      post :create, chart_form: params, format: :js
    end

    it "receive graph_data for @chart_form" do
      expect(chart_form).to receive(:graph_data)
      post :create, chart_form: params, format: :js
    end
    it "renders layout false" do
      post :create, chart_form: params, format: :js
      expect(response).not_to render_template(layout: "application")
    end
    context "without abilities to create" do
      before do
        ability.cannot :create, :chart
      end

      it "redirects to root_path" do
        post :create, chart_form: params, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end


end
