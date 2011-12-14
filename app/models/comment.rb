class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :article

	attr_accessible :body

	validates :user_id, :presence => true
	validates :article_id, :presence => true
	validates :body, :presence => true, :length => { :maximum => 50000 }     # spam protection

	default_scope :order => 'comments.created_at asc'
end
