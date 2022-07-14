require "rails_helper"
include SessionsHelper

RSpec.describe Admin::SubjectsController, type: :controller do
  let!(:user) {FactoryBot.create :user, role: :user}
  let!(:admin) {FactoryBot.create :user}
  let(:valid_params) {{subject: {name: "Bài thi sun", content: "Đề thi về ruby sun"}}}
  let(:invalid_params) {{subject: {name: "", content: "test thoi"}}}
  let(:subject){FactoryBot.create(:subject)}
  let(:question){FactoryBot.create(:question,subject_id: subject.id)}

  describe "when not login" do
    before do
      get :new
    end
    it "redirect to login page" do
      expect(response).to redirect_to login_path
    end

    it "show flag danger require login" do
      expect(flash[:danger]).to eq I18n.t("admin.subjects.new.require_login")
    end
  end

  describe "when login but not admin" do
    before do
      log_in user
      get :new
    end

    it "redirect to subjecs page" do
      expect(response).to redirect_to subjects_path
    end

    it "show flag danger require login" do
      expect(flash[:danger]).to eq I18n.t(".required_admin")
    end
  end

  describe "when login with permission admin" do
    before do
      log_in admin
      get :new
    end

    it "render new admin subject" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    before do
      log_in admin
    end

    context "when params valid" do
      before do
        post :create, params: valid_params
        @last_subject = Subject.last
      end

      it "create a new subject" do
        expect(@last_subject.name).to eq  valid_params.dig(:subject, :name)
      end

      it "create a new subject" do
        expect(@last_subject.content).to eq  valid_params.dig(:subject, :content)
      end

      it "flash message suscess" do
        expect(flash[:info]).to eq I18n.t("admin.subjects.create.create_success")
      end

      it "redirect to subject" do
        expect(response).to redirect_to subject_path(@last_subject.id)
      end
    end

    context "when params invalid" do
      before do
        post :create, params: invalid_params
        @last_subject = Subject.last
      end

      it "create a new subject failed" do
        expect(@last_subject).to be_nil
      end

      it "flash message failed" do
        expect(flash[:danger]).to eq I18n.t("admin.subjects.create.create_failed")
      end

      it "render new " do
        expect(response).to render_template(:new)
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
        delete :destroy, params: {id: subject.id}, xhr: true
      end

      it "Delete subject successed" do
        expect(Subject.find_by id: subject.id).to be_nil
      end

      it "flash delete successed" do
        expect(flash[:success]).to eq I18n.t("admin.subjects.destroy.delete_successed")
      end
    end

    context "when delete failed" do
      before do
        subject
        allow_any_instance_of(Subject).to receive(:destroy).and_return(false)
        delete :destroy, params: {id: subject.id}, xhr: true
      end

      it "Delete subject failed" do
        expect(Subject.find_by id: subject.id).to eq subject
      end

      it "flash delete successed" do
        expect(flash[:danger]).to eq I18n.t("admin.subjects.destroy.delete_failed")
      end
    end
  end

  describe "#show.pdf" do
    let!(:subject){FactoryBot.create(:subject)}
    let(:question){FactoryBot.create(:question, subject_id: subject.id)}
    before do
      log_in admin
    end
    context "when show successed" do
      before do
        question
        get :export, params: { id: subject.id, format: :pdf }
      end
      it "status" do
        expect(response.status).to eq 200
      end

      it "creates a PDF" do
        expect(assigns(:subject)).to eq subject
      end
    end

    context "when show failed" do
      before do
        get :export, params: { id: subject.id, format: :pdf }
      end

      it "creates a PDF" do
        expect(response.status).to eq 302
      end
    end

    context "when show failed with wrong id" do
      before do
        get :export, params: { id:-1, format: :pdf }
      end

      it "creates a PDF" do
        expect(response.status).to eq 302
      end
    end
  end
end
