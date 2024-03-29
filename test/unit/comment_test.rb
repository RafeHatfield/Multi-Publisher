require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should not have empty body" do
    comment = Comment.new 
    comment.user_id = 1
    comment.article_id = 1
    assert comment.invalid? 
    assert comment.errors[:body].any?
    assert !comment.save
  end

  test "should belong to user" do
    comment = Comment.new :body => "Body"
    comment.article_id = 1
    assert comment.invalid? 
    assert !comment.save
  end
  
  test "should belong to article" do
    comment = Comment.new :body => "Body"
    comment.user_id = 1
    assert comment.invalid? 
    assert !comment.save
  end
end