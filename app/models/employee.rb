# frozen_string_literal: true

class Employee
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  has_many :leave_requests, dependent: :destroy
  field :user_name, type: String
  field :password_digest, type: String

  validates :user_name, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password
end
