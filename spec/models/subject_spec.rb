require "rails_helper"

RSpec.describe Subject, type: :model do
  describe "associations" do
    it {should have_many(:questions).dependent(:destroy)}
    it {should belong_to(:user)}
  end

  describe "validates" do
    context "validate presence" do
      it {should validate_presence_of :name}
      it {should validate_presence_of :content}
    end

    context "validate length" do
      it {should validate_length_of(:name).is_at_most(Settings.subject.name.max_50)}
      it {should validate_length_of(:content).is_at_most(Settings.subject.content.max_1000)}
    end
  end

  describe "define enum" do
    context "status" do
      it {should define_enum_for :status}
    end
  end

  describe "accept nested attributes for questions" do
    it {should accept_nested_attributes_for :questions}
  end

  describe "scope" do
    let!(:subject_1) {FactoryBot.create(:subject, created_at: DateTime.current)}
    let!(:subject_2) {FactoryBot.create(:subject, created_at: DateTime.current + 1.day)}

    context "scope for recent subjects" do
      it {expect(Subject.recent_subjects).to eq([subject_2, subject_1])}
    end
  end
end
