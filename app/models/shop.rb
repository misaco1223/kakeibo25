class Shop < ApplicationRecord
  has_many :payments
  belongs_to :user
  validates :name, presence: true
end