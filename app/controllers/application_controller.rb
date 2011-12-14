class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :count_articles
	
	protected 
		def count_articles
			@num_all = Article.where(:state => ['3', '4']).count.to_s
			@num_featured = Article.where(:state => '4').count.to_s
		end
	
end
