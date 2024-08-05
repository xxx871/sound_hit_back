class Score < ApplicationRecord
  validates :user_id, uniqueness: { scope: [:mode_id, :difficulty_id] }

  belongs_to :user
  belongs_to :mode
  belongs_to :difficulty
end
