require "rails_helper"
include SessionsHelper
RSpec.describe SessionsController, type: :controller do

  let!(:user) {FactoryBot.create :user, email:"user@gmail.com", password: "123123"}
  describe "POST /create" do
    context "when email  not exist" do
      before do
        post :create, params: {session: {email: "21354abs@"}}
      end

      it "couldn't login with not exist email" do
        expect(flash[:danger]).to eq I18n.t("sessions.create.user_not_found")
      end
    end
  end

  context "when email is exist and correct password" do
    before do
      post :create, params: {session: {email: "user@gmail.com", password: "123123"}}
    end
    it "should login in sucess" do
      expect(logged_in?).to eq true
    end
  end

  context "with exist email, correct password and remember params" do
    before do
      post :create, params: {session: {email: "user@gmail.com", password: "123123", remember_me: 1}}
    end

    it "should login in success and remember" do
      expect(assigns(:user).remember_digest.present?).to eq true
    end
  end

  context "with exist email and incorrect password" do
    before do
      post :create, params: {session: {email: "user@gmail.com", password: "123123123"}}
    end

    it "should login in failed" do
      expect(flash[:danger]).to eq I18n.t("sessions.create.invalid_email_password_combination")
    end
  end

  describe "DELETE destroy" do
    context "when logout" do
      before do
        log_in user
        delete :destroy
      end

      it "should logout success" do
        expect(logged_in?).to eq false
      end
    end
  end
end
