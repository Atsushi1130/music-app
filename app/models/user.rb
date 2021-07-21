class User < ApplicationRecord
  validates :password, {presence: true}

  def songs
    return Song.where(user_id: self.id)
  end
end
