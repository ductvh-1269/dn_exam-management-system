require "rails_helper"
include SessionsHelper

RSpec.describe ExamsController, type: :controller do
  let(:subject_1) {FactoryBot.create :subject, name: "mock subject"}
  let(:subject_2) {FactoryBot.create :subject}
  let!(:user_1) {FactoryBot.create :user, role: :user}
  let!(:exam_1) {FactoryBot.create :exam, user: user_1, subject: subject_1}
  let!(:exam_2) {FactoryBot.create :exam, user: user_1, subject: subject_2}
  let!(:exam_3) {FactoryBot.create :exam, user: user_1}
  let!(:exam_4) {FactoryBot.create :exam, user: user_1}
  let!(:exam_5) {FactoryBot.create :exam, user: user_1}
  let!(:exam_6) {FactoryBot.create :exam}
  let!(:exam_7) {FactoryBot.create :exam}
  let!(:question_1) {FactoryBot.create :question, subject: subject_2}
  let!(:question_2) {FactoryBot.create :question, subject: subject_2}
  let!(:question_3) {FactoryBot.create :question, subject: subject_2}
  let!(:question_4) {FactoryBot.create :question, subject: subject_2}
  let!(:question_5) {FactoryBot.create :question, subject: subject_2}
  let!(:answer_1) {FactoryBot.create :answer, question: question_5}
  let!(:answer_2) {FactoryBot.create :answer, question: question_5}
  let!(:answer_3) {FactoryBot.create :answer, question: question_4}
  let!(:answer_4) {FactoryBot.create :answer, question: question_4, is_correct: :true_answer}

  let!(:exam_detail) {FactoryBot.create :exam_detail, exam: exam_1}
  let!(:exam_detail_2) {FactoryBot.create :exam_detail, exam: exam_2}
  let!(:exam_detail_3) {FactoryBot.create :exam_detail, exam: exam_2}

  describe "GET /exams" do
    context "exams#index loggin with role user" do
      before do
        log_in user_1
        get :index
      end

      it "logged in user role" do
        expect(assigns(:exams).length).to eq 5
      end
    end

    context "without login" do
      before do
        get :index
      end

      it "not logged in" do
        expect(response).to redirect_to :login
      end
    end
  end

  describe "GET/search" do
    context "when search with exist record" do
      before do
        log_in user_1
        get :search, params: {query: "mock"}, xhr: true
      end

      it "key word is 'mock'" do
        expect(assigns(:exams)).to eq [exam_1]
      end
    end

    context "when search with does not exist record" do
      before do
        log_in user_1
        get :search, params: {query: "abc"}, xhr: true
      end

      it "key word is 'abc'" do
        expect(assigns(:exams).length).to eq 0
      end
    end
  end

  describe "GET/new" do
    context "when subject is exist" do
      before do
        log_in user_1
        get :new, params: {subject_id: subject_1.id}
      end

      it "new an exam do" do
        expect(assigns(:subject)).to eq subject_1
      end
    end

    context "when subject does not exist" do
      before do
        log_in user_1
        get :new, params: {subject_id: nil}
      end

      it "new an exam do" do
        expect(flash[:danger]).to eq I18n.t("exams.new.resource_not_found")
      end
    end
  end

  describe "GET/show" do
    context "when exam is exist and correct user" do
      before do
        log_in user_1
        get :show, params: {id: exam_1.id}
      end

      it "show an exam do" do
        expect(assigns(:exam)).to eq exam_1
      end
    end

    context "when exam is exist or incorrect user" do
      before do
        log_in user_1
        get :show, params: {id: exam_6.id}
      end

      it "show an exam do" do
        expect(flash[:danger]).to eq I18n.t("exam_not_found")
      end
    end
  end

  describe "POST#create" do
    context "when create an exam with invalid subject" do
      before do
        log_in user_1
        post :create, params: {subject_id: subject_1.id}
      end

      it "create an exam do" do
        expect(flash[:danger]).to eq I18n.t("exams.create.question_not_implemented")
      end
    end

    context "when create an exam with valid subject" do
      before do
        log_in user_1
        post :create, params: {subject_id: subject_2.id}
      end

      it "create an exam do" do
        expect(assigns(:exam).exam_details.length).to eq 5
      end
    end

    context "when create an exam with invalid params" do
      before do
        log_in user_1
        post :create, params: {subject_id: subject_2.id}
      end

      it "create an exam do" do
        expect(assigns(:exam).exam_details.length).to eq 5
      end
    end
  end

  describe "PATCH#update" do
    context "when submit an exam" do
      before do
        log_in user_1
        put :update, params: {id: exam_2.id, exam: {id: exam_2.id, user_id: user_1.id,
          exam_details_attributes:{"0": {selected_answer_id: answer_1.id,id: exam_2.exam_details[0].id},
                                   "1": {selected_answer_id: answer_4.id, id: exam_2.exam_details[1].id} }}}
      end

      it "submit an exam do" do
        expect(flash[:success]).to eq I18n.t("exams.update.exam_done")
      end
    end

    context "when submit an exam with invalid params" do
      before do
        log_in user_1
        put :update, params: {id: exam_3.id, exam: {id: exam_2.id, user_id: user_1.id,
          exam_details_attributes:{"0": {selected_answer_id: "A",id: exam_2.exam_details[0].id},
                                   "1": {selected_answer_id: "B", id: exam_2.exam_details[1].id} }}}
      end

      it "submit an exam do" do
        expect(flash[:danger]).to eq I18n.t("submit_err")
      end
    end

  end
end
