class Bookmark < ApplicationRecord
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :kittings, dependent: :destroy
  has_many :kits, through: :kittings

  validates :url, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true
  # validates :icon, presence: true
  # validates :all_tags, presence: true


  def self.tagged_with(title)
    Tag.find_by!(title: title).favorites
  end

  # def all_tags=(tag_titles)
  #   self.tags = tag_titles.downcase.split(", ").map do |title|
  #     Tag.where(title: title).first_or_create!
  #   end
  # end

  def all_tags
    tags.map(&:title).join(", ")
  end
end

