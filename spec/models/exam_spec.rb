require "rails_helper"
RSpec.describe Exam, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:subject) }
    it { should have_many(:exam_details).dependent(:destroy) }
    it { should have_many(:questions).through(:exam_details) }
  end

  describe "Exam Nested attributes exam detail" do
    it { should accept_nested_attributes_for(:exam_details) }
  end


  describe "scopes" do
    let(:subject_1) {FactoryBot.create :subject, name: "mock subject"}
    let(:user_1) {FactoryBot.create :user, last_name: "mock last name", role: :user}
    let(:user_2) {FactoryBot.create :user, email: "mock@gmail.com"}
    let(:exam_1) {FactoryBot.create :exam, subject: subject_1, created_at: DateTime.now-20}
    let(:exam_2) {FactoryBot.create :exam, user: user_1, created_at: DateTime.now-10}
    let(:exam_3) {FactoryBot.create :exam, user: user_2, created_at: DateTime.now}
    context "when exam sort by recent exam do" do
      it "should be order created date" do
        expect(Exam.recent_exam).to eq [exam_3, exam_2, exam_1]
      end
    end

    context "with search exam" do
      it "search by subject name do " do
        expect(Exam.by_key_word_with_relation_tables("subject")).to eq [exam_1]
      end

      it "search by user last name do " do
        expect(Exam.by_key_word_with_relation_tables("last")).to eq [exam_2]
      end

      it "search by user email do " do
        expect(Exam.by_key_word_with_relation_tables("mock@")).to eq [exam_3]
      end
    end
  end
end
