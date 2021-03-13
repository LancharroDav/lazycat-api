class Tagging < ApplicationRecord
  belongs_to :bookmark
  belongs_to :tag
end
