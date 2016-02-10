require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:authenticated_user) {FactoryGirl.build_stubbed :user}
  let(:vacancy) {FactoryGirl.build_stubbed :vacancy}
  let(:ability) {Ability.new(authenticated_user)}

  before(:each) do
    request.env["HTTP_REFERER"] = "localhost:3000/where_i_came_from"
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(controller).to receive(:current_user).and_return authenticated_user
    allow(User).to receive(:find).and_return authenticated_user
    ability.can :manage, :all
  end
  describe "GET #show" do

    it "renders :show template" do
      get :show, id: authenticated_user.id
      expect(response).to render_template :show
    end

    context "without abilities to read" do
      before do
        ability.cannot :read, authenticated_user
      end
      it "redirects to root_path" do
        get :show, id: authenticated_user.id
        expect(response).to redirect_to(root_path)
      end
    end


    describe "GET #download_resume" do

      it "respond successful status when downloading resume is okay" do
        get :download_resume, id: authenticated_user.id
        expect(response.status).to eq 200
      end

      it "redirects to user_path if user's resume is missing" do
        authenticated_user.remove_resume!
        get :download_resume, id: authenticated_user.id
        expect(response).to redirect_to user_path(authenticated_user)
      end
      context "without abilities to download user's resume" do
        before do
          ability.cannot :read, authenticated_user
        end

        it "redirects to root_path" do
          get :download_resume, id: authenticated_user.id
        end
      end
    end
  end

end