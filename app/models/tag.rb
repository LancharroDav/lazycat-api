class Tag < ApplicationRecord
  belongs_to :user

  has_many :taggings,  dependent: :destroy
  has_many :bookmarks, through: :taggings

  validates :title, length: { minimum: 1 }, presence: true
end
