require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it {should have_many(:subjects).dependent(:destroy)}
    it {should have_many(:exams).dependent(:destroy)}
  end

  describe "validates" do
    context "validate presence" do
      it {should validate_presence_of :first_name}
      it {should validate_presence_of :last_name}
      it {should validate_presence_of :password}
      it {should validate_presence_of :email}
      it {should validate_presence_of :role}
    end

    context "validate length" do
      it {should validate_length_of(:first_name).is_at_most(Settings.user.name.max_length)}
      it {should validate_length_of(:last_name).is_at_most(Settings.user.name.max_length)}
      it {should validate_length_of(:email).is_at_least(Settings.user.email.min_length).is_at_most(Settings.user.email.max_length)}
      it {should validate_length_of(:last_name).is_at_most(Settings.user.name.max_length)}
      it {should validate_length_of(:password).is_at_least(Settings.user.password.min_length)}
    end

    context "validate format" do
      it {should allow_value("voduclong@gmail.com").for(:email)}
      it {should_not allow_value("invalid").for(:email)}
    end
  end

  describe "define enum" do
    context "role" do
      it {should define_enum_for :role}
    end
  end

  describe "has secure password" do
    it {should have_secure_password}
  end

  describe "function of user" do
    let!(:user) {FactoryBot.create(:user)}

    context "remember" do
      it {expect(user.remember).to be_truthy}
    end

    context "forget" do
      it {expect(user.forget).to be_truthy}
    end
  end
end
