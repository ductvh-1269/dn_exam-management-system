require "rails_helper"
include SessionsHelper

RSpec.describe Admin::QuestionsController, type: :controller do
  let(:user) {FactoryBot.create :user, role: :user}
  let!(:admin) {FactoryBot.create :user}
  let(:subject) {FactoryBot.create(:subject)}
  let(:answer) {FactoryBot.create(:answer)}
  let(:question) {FactoryBot.create(:question)}
  let(:answer_1) {FactoryBot.create(:answer, question: question)}
  let(:param_true_answers) {{
    content: Faker::Lorem.sentence,
    is_correct: :true_answer
  }}
  let(:param_false_answers) {{
    content: Faker::Lorem.sentence,
    is_correct: :false_answer
  }}
  let(:valid_create_params) {{
    subject_id: subject.id,
    question:
      {
        content: "Câu hỏi số 1",
        answers_attributes: [param_true_answers]
      }
  }}
  let(:invalid_id_create_params) {{
    subject_id: -1,
    question:
      {
        content: "Câu hỏi số 1",
        answers_attributes: [param_true_answers]
      }
  }}
  let(:invalid_content_create_params) {{
    subject_id: subject.id,
    question:
      {
        content: "",
        answers_attributes: [param_true_answers]
      }
  }}
  let(:invalid_fail_answer_create_params) {{
    subject_id: subject.id,
    question:
      {
        content: "Câu hỏi số 1",
        answers_attributes: [param_false_answers]
      }
  }}
  let(:valid_update_params) {{
    subject_id: subject.id,
    id: question.id,
    question:
      {
        content: "Câu hỏi số 1",
        answers_attributes:
        [param_true_answers, param_false_answers]
      }
  }}
  let(:invalid_content_update_params) {{
    subject_id: subject.id,
    id: question.id,
    question:
      {
        content: "",
        answers_attributes: [param_true_answers]
      }
  }}
  let(:invalid_fail_answer_update_params) {{
    subject_id: subject.id,
    id: question.id,
    question:
      {
        content: "Câu hỏi số 1",
        answers_attributes: [param_false_answers]
      }
  }}
  let(:invalid_question_id_update_params) {{
    subject_id: subject.id,
    id: -1,
    question:
      {
        content: "Câu hỏi số 1",
        answers_attributes: [param_true_answers]
      }
  }}
  describe "when not login" do
    before do
      get :new, params: { subject_id: subject.id}
    end

    it "should redirect to login page" do
      expect(response).to redirect_to login_path
    end

    it "show flag danger require login" do
      expect(flash[:danger]).to eq I18n.t("admin.questions.new.require_login")
    end
  end

  describe "when login but not admin" do
    before do
      user
      log_in user
      get :new, params: { subject_id: subject.id}
    end

    it "should redirect to subjecs page" do
      expect(response).to redirect_to subjects_path
    end

    it "should show flag danger require login" do
      expect(flash[:danger]).to eq I18n.t(".required_admin")
    end
  end

  describe "when login with permission admin" do
    before do
      log_in admin
      get :new, params: {subject_id: subject.id}
    end

    it "render new admin subject" do
      expect(response).to render_template(:new, params: {subject_id: subject.id})
    end
  end

  describe "POST #create" do
    before do
      log_in admin
    end

    context "when params valid" do
      before do
        subject
        valid_create_params
        post :create, params: valid_create_params
        @last_question = Question.last
      end

      it "should create a new question sucessed" do
        expect(@last_question.content).to eq  valid_create_params.dig(:question, :content)
      end

      it "should flash message suscess" do
        expect(flash[:info]).to eq I18n.t("admin.questions.create.create_question_successed")
      end
    end

    context "when params invalid (invalid id)" do
      before do
        @count_questions_before_create = Question.all
        post :create, params: invalid_id_create_params
      end

      it "should create a new question failed with invalid id" do
        expect(@count_questions_before_create.size).to eq  Question.count
      end

      it "should flash message failed" do
        expect(flash[:danger]).to eq I18n.t("admin.questions.create.subject_not_found")
      end
    end

    context "when params invalid (invalid content)" do
      before do
        @count_questions_before_create = Question.all
        post :create, params: invalid_content_create_params
      end

      it "should create a new question failed with invalid content" do
        expect(@count_questions_before_create.size).to eq  Question.count
      end

      it "should flash message failed" do
        expect(flash[:danger]).to eq I18n.t("admin.questions.create.create_question_failed")
      end
    end

    context "when params invalid (invalid fail answer)" do
      before do
        @count_questions_before_create = Question.all
        post :create, params: invalid_fail_answer_create_params
      end

      it "should create a new question failed with invalid answer" do
        expect(@count_questions_before_create.size).to eq  Question.count
      end

      it "should flash message failed" do
        expect(flash[:danger]).to eq I18n.t("admin.questions.create.must_a_true_answer")
      end
    end
  end

  describe "#update" do
    before do
      log_in admin
    end

    context "when param valid" do
      before do
        question
        put :update, params: valid_update_params
        @update_question = Question.find_by id: question.id
      end

      it "should update the question successed" do
        expect(@update_question.content).to eq  valid_update_params.dig(:question, :content)
      end

      it "should flash message suscess" do
        expect(flash[:success]).to eq I18n.t("admin.questions.update.update_successed")
      end
    end

    context "when param invalid (invalid content)" do
      before do
        question
        @before_update_question = Question.find_by id: question.id
        put :update, params: invalid_content_update_params
      end

      it "should update the question failed" do
        expect(@before_update_question.content).to eq  (Question.find_by id: question.id).content
      end
    end

    context "when param invalid (invalid fail answer)" do
      before do
        question
        @before_update_question = Question.find_by id: question.id
        put :update, params: invalid_fail_answer_update_params
      end

      it "should update the question failed" do
        expect(@before_update_question.content).to eq  (Question.find_by id: question.id).content
      end

      it "should flash message failed" do
        expect(flash[:danger]).to eq I18n.t("admin.questions.update.must_a_true_answer")
      end
    end

    context "when param invalid (invalid question id)" do
      before do
        question
        @before_update_question = Question.find_by id: question.id
        put :update, params: invalid_question_id_update_params
      end

      it "should update the question failed" do
        expect(@before_update_question.content).to eq  (Question.find_by id: question.id).content
      end

      it "should flash message failed" do
        expect(flash[:danger]).to eq I18n.t("admin.questions.update.question_not_found")
      end
    end

    context "when try update false answer failed" do
      before do
        question
        answer_1
        @before_update_question = Question.find_by id: question.id
        allow_any_instance_of(Question).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        put :update, params: valid_update_params
      end

      it "should update the question failed" do
        expect(@before_update_question.content).to eq  (Question.find_by id: question.id).content
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      log_in admin
    end

    context "when delete success" do
      before do
        subject
        question
        delete :destroy, params: {subject_id: subject.id, id: question.id}
      end

      it "Delete question successed" do
        expect(Subject.find_by id: question.id).to be_nil
      end

      it "should flash delete successed" do
        expect(flash[:success]).to eq I18n.t("admin.questions.destroy.delete_successed")
      end
    end

    context "when delete success" do
      before do
        subject
        question
        allow_any_instance_of(Question).to receive(:destroy).and_return(false)
        delete :destroy,  params: {subject_id: subject.id, id: question.id}
      end

      it "Delete question failed" do
        expect(Question.find_by id: question.id).to eq question
      end

      it "should flash delete failed" do
        expect(flash[:danger]).to eq I18n.t("admin.questions.destroy.delete_failed")
      end
    end
  end

end
