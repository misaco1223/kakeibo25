class User < ApplicationRecord
  has_many :money_files, dependent: :destroy
  has_many :pay_methods, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :shops, dependent: :destroy
end
