class Kit < ApplicationRecord
  belongs_to :user
  has_many :kittings, dependent: :destroy
  has_many :bookmarks, through: :kittings

  validates :title, presence: true, uniqueness: true
end
