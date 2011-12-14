require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  test "should not have empty title teaser body" do
    article = Article.new 
    article.user_id = 1
    assert article.invalid? 
    assert article.errors[:title].any?
    assert article.errors[:teaser].any?
    assert article.errors[:body].any?
    assert !article.save
  end

  test "must belong to a user" do
    article = Article.new :title => "Title", :teaser => "Teaser", :body => "Body"
    assert article.invalid? 
    assert !article.save
  end
  
  test "should not have a state outside boundaries" do
    article = Article.new :title => "Title", :teaser => "Teaser", :body => "Body"
    article.user_id = 1
    
    article.state = -1
    assert !article.save
    article.state = 'a'
    assert !article.save
    article.state = 5
    assert !article.save
    
    article.state = 0   
    assert article.save
    article.state = 2
    assert article.save
    article.state = 4   
    assert article.save 
  end
end
