class User < ApplicationRecord
  has_many :money_files, dependent: :destroy
end
