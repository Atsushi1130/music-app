class User < ApplicationRecord
  validates :password, {presence: true}
  validates :email, {presence: true, uniqueness: true}
  validates :name, {presence: true}

  def songs
    return Song.where(user_id: self.id)
  end
end
