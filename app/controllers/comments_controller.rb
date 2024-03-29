class CommentsController < ApplicationController
	
	before_filter :authenticate_user!

	# create a comment and bind it to an article and a user  
	def create
	  @article = Article.find(params[:article_id])
	  @comment = @article.comments.build(params[:comment])
	  @comment.user = current_user

	  respond_to do |format|
	    if @article.state > 2
	      if @comment.save
	        format.html { redirect_to(@article, :notice => 'Comment was successfully created.') }
	      else
	        format.html { redirect_to(@article, :notice => 'There was an error saving your comment (empty comment or comment way to long).') }
	      end
	    else
	      format.html { redirect_to(@article, :notice => 'Comments are limited to published articles.') }
	    end  
	  end
	end

	# remove a comment
	def destroy
	  @comment = current_user.comments.find(params[:id])
	  @article = Article.find(params[:article_id])
	  @comment.destroy
  
	  respond_to do |format|
	    format.html { redirect_to @article }
	  end
	end
end
