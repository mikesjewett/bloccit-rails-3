class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  attr_accessible :body, :post

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true

  after_create :send_favorite_emails

  private

  def send_favorite_emails
    # for every favorite associated with post, send email
    self.post.favorites.each do |fav|
      if fav.user_id != self.user_id && fav.user.email_favorites?
        FavoriteMailer.new_comment(fav.user, self.post, self).deliver
      end
    end
  end  
end
