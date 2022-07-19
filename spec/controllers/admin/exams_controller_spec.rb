require "rails_helper"
include SessionsHelper

RSpec.describe Admin::ExamsController, type: :controller do
  let!(:subject_1) {FactoryBot.create :subject}
  let!(:subject_2) {FactoryBot.create :subject}
  let!(:user_1) {FactoryBot.create :user, role: :user, last_name: "mock"}
  let!(:exam_1) {FactoryBot.create :exam, user: user_1, subject: subject_1}
  let!(:exam_2) {FactoryBot.create :exam, user: user_1, subject: subject_2}
  let!(:exam_3) {FactoryBot.create :exam, user: user_1}
  let!(:exam_4) {FactoryBot.create :exam, user: user_1}
  let!(:exam_5) {FactoryBot.create :exam, user: user_1}
  let!(:exam_5a) {FactoryBot.create :exam, user: user_1}
  let!(:exam_5b) {FactoryBot.create :exam, user: user_1}
  let!(:exam_6) {FactoryBot.create :exam}
  let!(:exam_6a) {FactoryBot.create :exam}
  let!(:exam_6b) {FactoryBot.create :exam}
  let!(:exam_6c) {FactoryBot.create :exam}
  let!(:exam_7) {FactoryBot.create :exam}
  let!(:admin) {FactoryBot.create :user, role: :admin}
  describe "GET index exams" do
    context "when index exams without params" do
      before do
        log_in admin
        get :index
      end
      it "should be show all exams" do
        expect(assigns(:pagy).count).to eq 12
      end
    end

    context "when index exams with params 'query=mock'" do
      before do
        log_in admin
        get :index, params: {query: "mock"}
      end
      it "should be show all exams" do
        expect(assigns(:pagy).count).to eq 7
      end
    end
  end

  describe "GET show exam" do
    context "when invalid params" do
      before do
        log_in admin
        get :show, params: {id: "abc"}
      end
      it "should be show a danger message" do
        expect(flash[:danger]).to eq I18n.t("admin.exams.show.exam_not_found")
      end
    end

    context "when valid params" do
      before do
        log_in admin
        get :show, params: {id: exam_2.id}
      end
      it "should be show exam_details of exam" do
        expect(assigns(:exam)).to eq exam_2
      end
    end
  end
end
