require "rails_helper"
include SessionsHelper

RSpec.describe SubjectsController, type: :controller do
  let!(:subject_1) {FactoryBot.create :subject}
  let!(:subject_3) {FactoryBot.create :subject, status: :inactive}
  let!(:subject_2) {FactoryBot.create :subject}
  let!(:question_1) {FactoryBot.create :question, subject: subject_2}
  let!(:question_2) {FactoryBot.create :question, subject: subject_2}
  let!(:question_3) {FactoryBot.create :question, subject: subject_2}
  let!(:question_4) {FactoryBot.create :question, subject: subject_2}
  let!(:question_5) {FactoryBot.create :question}
  describe "GET show" do

    context "when show a subject with valid id" do
      before do
        get :show, params: {id: subject_2.id}
      end
      it "should be show a subject" do
        expect(assigns(:subject)).to eq subject_2
        expect(assigns(:subject).questions.length).to eq 4
      end
    end

    context "when show a subject with invalid id" do
      before do
        get :show, params: {id: "ABC"}
      end
      it "should be show a message danger" do
        expect(flash[:danger]).to eq I18n.t("subjects.show.find_failed")
      end
    end
  end

  describe "GET index" do

    context "when show all subject active" do
      before do
        get :index
      end
      it "should be show all subject active" do
        expect(assigns(:subjects).length).to eq 2
      end
    end
  end
end
