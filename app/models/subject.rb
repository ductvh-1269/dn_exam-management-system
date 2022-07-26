class Subject < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions
  ransack_alias :questions, :question_content
  enum status: {inactive: 0, active: 1}, _default: 1
  validates :name, presence: true,
            length: {maximum: Settings.subject.name.max_50}
  validates :content, presence: true,
            length: {maximum: Settings.subject.content.max_1000}
  scope :recent_subjects, ->{order created_at: :desc}

  def self.ransackable_attributes _auth_object = nil
    %w(created_at name content)
  end
end
