class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :money_files, dependent: :destroy
  has_many :pay_methods, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :shops, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password
end
