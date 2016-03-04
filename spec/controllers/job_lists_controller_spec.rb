require 'rails_helper'

RSpec.describe JobListsController, type: :controller do
  let(:authenticated_user) {FactoryGirl.build_stubbed :user}
  let(:vacancy) {FactoryGirl.build_stubbed :vacancy}

  describe "GET #show" do
    before do
      allow(controller).to receive(:current_user).and_return authenticated_user
    end
    it "renders :show template" do
      allow(request.env['warden']).to receive(:authenticate!).and_return(authenticated_user)
      allow(authenticated_user).to receive_message_chain(:vacancies, :page).and_return [vacancy]
      get :show
      expect(response).to render_template :show
    end

    it "redirects to sign_in page if current_user is nil" do
      get :show
      expect(response).to redirect_to new_user_session_path
    end

  end

end