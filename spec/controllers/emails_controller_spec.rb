require 'rails_helper'

RSpec.describe Users::EmailsController, type: :controller do

  let(:employer) {FactoryGirl.build_stubbed :employer}
  let(:company) {FactoryGirl.build_stubbed :company, user: employer}
  let(:user) {FactoryGirl.build_stubbed :user}
  let(:ability) {Ability.new(employer)}
  let(:params) {{denial_email: {subject: "Bla Bla", body: "Gla"}}}
  before(:each) do
    request.env["HTTP_REFERER"] = "localhost:3000/where_i_came_from"
    allow(User).to receive(:find).and_return user
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(controller).to receive(:current_user).and_return employer
    ability.can :manage, :all
  end

  describe "GET #new_email" do
    it "renders a :new_email template" do
      xhr :get, :new_email, id: user.id, format: :js
      expect(response).to render_template :new_email
    end

    context "without abilities  to get new_email" do
      before do
        ability.cannot :new_email, :email
      end

      it "redirects to root_path" do
        xhr :get, :new_email, id: user.id, format: :js
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #send_denial" do
    before do
      allow(employer).to receive(:company).and_return company
    end
    it "receives a send_denial_email with params" do
      expect(employer).to receive(:send_denial_email).with(user, params)
      post :send_denial, id: user.id, denial_email: params
    end

    it "redirects to :back after sending denial email" do
       post :send_denial, id: user.id, denial_email: params
       expect(response).to redirect_to(:back)
    end

    context "without abilities to send denial email" do
      before do
        ability.cannot :send_denial
      end

      it "redirects to root_path" do
        post :send_denial, id: user.id, denial_email: params
      end
    end
  end




end
