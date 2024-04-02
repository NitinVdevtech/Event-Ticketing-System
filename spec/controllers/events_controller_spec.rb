require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event, user: user) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: event.to_param }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    context "when user is signed in" do
      before { sign_in user }

      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: { id: event.to_param }
      expect(response).to be_truthy
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before { sign_in user }

      it "creates a new Event" do
        expect {
          post :create, params: { event: FactoryBot.attributes_for(:event) }
        }.to change(Event, :count).by(1)
      end

      it "redirects to the created event" do
        post :create, params: { event: FactoryBot.attributes_for(:event) }
        expect(response).to redirect_to(Event.last)
      end
    end

    context "with invalid params" do
      before { sign_in user }

      it "returns a success response (i.e., to display the 'new' template)" do
        post :create, params: { event: FactoryBot.attributes_for(:event, name: nil) }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH #update" do
    before { sign_in user }

    context "with valid params" do
      it "updates the requested event" do
        patch :update, params: { id: event.to_param, event: { name: "New Name" } }
        event.reload
        expect(event.name).to eq("New Name")
      end

      it "redirects to the event" do
        patch :update, params: { id: event.to_param, event: { name: "New Name" } }
        expect(response).to redirect_to(event)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e., to display the 'edit' template)" do
        patch :update, params: { id: event.to_param, event: { name: nil } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before { sign_in user }

    it "destroys the requested event" do
      event = FactoryBot.create(:event, user: user)
      expect {
        delete :destroy, params: { id: event.to_param }
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = FactoryBot.create(:event, user: user)
      delete :destroy, params: { id: event.to_param }
      expect(response).to redirect_to(events_url)
    end
  end
end
