class User < ApplicationRecord
  has_many :subjects, dependent: :destroy
  has_many :histories, dependent: :destroy

  enum :role, %i(admin user), _default: :user
end
