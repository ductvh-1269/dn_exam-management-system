require "rails_helper"

RSpec.describe Question, type: :model do
  describe "associations" do
    it {should have_many(:answers).dependent(:destroy)}
    it {should have_many(:exam_details).dependent(:destroy)}
    it {should have_many(:exams).through(:exam_details)}
    it {should belong_to(:subject)}
  end

  describe "validates" do
    context "validate presence" do
      it {should validate_presence_of :content}
    end
    context "validate length" do
      it {should validate_length_of(:content).is_at_most(Settings.question.content.max_1000)}
    end
  end

  describe "define enum" do
    it {should define_enum_for :question_type}
    it {should define_enum_for :status}
  end

  describe "accept nested attributes" do
    it {should accept_nested_attributes_for(:answers).allow_destroy(true)}
  end

  describe "scope" do
    let!(:question_1) {FactoryBot.create(:question, created_at: DateTime.current)}
    let!(:question_2) {FactoryBot.create(:question, created_at: DateTime.current + 1.day)}

    context "scope for recent questions" do
      it {expect(Question.recent_questions).to eq([question_2, question_1])}
    end
  end
end
