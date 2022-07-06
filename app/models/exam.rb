class Exam < ApplicationRecord
  attr_accessor :exam_details_attributes

  belongs_to :user
  belongs_to :subject
  has_many :exam_details, dependent: :destroy
  has_many :questions, through: :exam_details
  delegate :name, to: :subject, prefix: true
  accepts_nested_attributes_for :exam_details
  scope :recent_exam, ->{order created_at: :desc}
  scope :by_key_word_with_relation_tables, lambda {|key_search|
  joins(:subject, :user).where("subjects.name like ?", "%#{key_search}%")
                        .or(where("users.last_name like ?", "%#{key_search}%"))
                        .or(where("users.email like ?", "%#{key_search}%"))}
end
