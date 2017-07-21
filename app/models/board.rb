class Board < ApplicationRecord
  belongs_to :user
  has_many :pins, dependent: :destroy
  validates :name, presence: true
end
