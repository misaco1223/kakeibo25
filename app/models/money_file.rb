class MoneyFile < ApplicationRecord
  mount_uploader :money_file_image, MoneyFileImageUploader
  attr_accessor :remove_money_file_image
  belongs_to :user
  validates :title, presence: true
  validates :user_id, presence: true
  has_many :budgets, dependent: :destroy
end
