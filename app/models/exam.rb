class Exam < ApplicationRecord
  attr_accessor :exam_details_attributes

  belongs_to :user
  belongs_to :subject
  has_many :exam_details, dependent: :destroy
  has_many :questions, through: :exam_details
  accepts_nested_attributes_for :exam_details
  scope :recent_exam, ->{order created_at: :desc}
#   scope :by_first_name, ->query {joins(:user)
# .where("users.first_name LIKE ?", "%#{query}%")}
#   scope :by_last_name, ->query {joins(:user)
#     .where("users.last_name LIKE ?", "%#{query}%")}
#   scope :by_email, ->query {joins(:user)
#     .where("users.email LIKE ?", "%#{query}%")}
  scope :by_subject, ->query {joins(:subject)
    .where("subjects.name LIKE ?", "%#{query}%")}
#   scope :by_user_id, ->id{joins(:user).where(users: {id:})}
#   scope :find_by_user, lambda {|query|
#   Exam.by_first_name(query).or(Exam.by_last_name(query)).or(Exam.by_email(query))}

  scope :by_key_word_with_relation_tables, ->(key_search){
    joins(:subject, :user).where("subjects.name like ?", "%#{key_search}%")
    .or(where("users.last_name like ?", "%#{key_search}%"))
    .or(where("users.email like ?", "%#{key_search}%"))}
end
