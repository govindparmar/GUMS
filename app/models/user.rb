class User < ApplicationRecord
  validates :full_name, presence: true
  validates :email, presence: true
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true
  validates :password, presence: true, length: { minimum: 5 }
  has_secure_password
end
