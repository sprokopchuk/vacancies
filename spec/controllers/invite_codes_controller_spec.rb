require 'rails_helper'

RSpec.describe InviteCodesController, type: :controller do

  let(:employer) {FactoryGirl.build_stubbed :employer}
  let(:ability) {Ability.new(employer)}
  let(:invite_code) {FactoryGirl.build_stubbed :invite_code, user: employer}
  before(:each) do
    request.env["HTTP_REFERER"] = "localhost:3000/where_i_came_from"
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(controller).to receive(:current_user).and_return employer
    ability.can :manage, :all
  end

  describe "GET #index" do
    it "renders :index template" do
      get :index
      expect(response).to render_template :index
    end

    context "without abilities to read" do
      before do
        ability.cannot :read, InviteCode
      end

      it "redirects to root_path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "POST #create" do
    before do
      allow(InviteCode).to receive(:new).and_return invite_code
      allow(invite_code).to receive(:save).and_return true
    end
    it "receives a save for @invte_code" do
      expect(invite_code).to receive(:save)
      post :create
    end

    it "sends success message when @invite_code generated" do
      post :create
      expect(flash[:notice]).to eq "Invite code was generated successfully"
    end

    it "sends fail message when @invite_code not generated" do
      allow(invite_code).to receive(:save).and_return false
      post :create
      expect(flash[:alert]).to eq "Something is wrong. Invite code was not generated"
    end
  end


end
