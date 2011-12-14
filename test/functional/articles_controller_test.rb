require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase

  setup do
    @article_user1 = articles(:one)
    @article_user2 = articles(:three)
  end

	#submit
	
	# submit
	test "should not submit article anonymous" do  
	  put :submit, :id => @article_user1.to_param
	  assert_redirected_to new_user_session_path
	end
	test "should not submit article for other user" do
	  sign_in users(:user2)
	  put :submit, :id => articles(:one).id
	  assert_redirected_to root_url, "Should be redirected to root url if article of other user is requested"
	  assert_equal 'The article you requested could not be found.', flash[:error]
	end
	test "should submit draft article" do
	  sign_in users(:user2)
	  put :submit, :id => articles(:three).id
	  assert assigns(:article).state == 1, "Article state is not 1 (submitted)" 
	  assert_redirected_to myarticles_articles_path
	  assert_equal 'Your article was successfully submitted for approval.', flash[:notice]
	end
	test "should resubmit rejected article" do
	  sign_in users(:user2)
	  put :submit, :id => articles(:five).id
	  assert assigns(:article).state == 1, "Article state is not 1 (submitted)" 
	  assert_redirected_to myarticles_articles_path
	  assert_equal 'Your article was successfully submitted for approval.', flash[:notice]    
	end  
	test "should not submit submitted article again" do
	  sign_in users(:user2)
	  put :submit, :id => articles(:four).id
	  assert_redirected_to myarticles_articles_path
	  assert_equal 'This article can not be submitted.', flash[:error]
	end
	test "should not submit accepted article again" do
	  sign_in users(:user2)
	  put :submit, :id => articles(:six).id
	  assert_redirected_to myarticles_articles_path
	  assert_equal 'This article can not be submitted.', flash[:error]   
	end
	test "should not submit featured article again" do
	  sign_in users(:user2)
	  put :submit, :id => articles(:seven).id
	  assert_redirected_to myarticles_articles_path
	  assert_equal 'This article can not be submitted.', flash[:error]  
	end
	
	# myarticles
	test "should not get myarticles anonymous" do
	  get :myarticles
	  assert_redirected_to new_user_session_path
	end
	test "should get myarticles signed in" do
	  sign_in users(:user2)
	  get :myarticles
	  assert_response :success
	end
	
  # index and all
  test "should get index and all anonymous" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
    get :all
    assert_response :success
    assert_not_nil assigns(:articles)
  end  
  test "should get index and all signed in" do
    sign_in users(:user2)
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
    get :all
    assert_response :success
    assert_not_nil assigns(:articles)
  end  
  
  # about  
  test "should get about anonymous" do 
    get :about
    assert_response :success        
  end
  test "should get about signed in" do
    sign_in users(:user2)
    get :about
    assert_response :success        
  end
 
  # show
  test "should show article anonymous" do
    get :show, :id => @article_user1.to_param
    assert_response :success
  end
  test "should show article signed in" do
    sign_in users(:user2)
    get :show, :id => @article_user1.to_param
    assert_response :success
  end 
 
  # new and edit
  test "should not get new and edit anonymous" do
    get :new
    assert_redirected_to new_user_session_path
    get :edit, :id => @article_user1.to_param
    assert_redirected_to new_user_session_path
  end
  test "should get new signed in" do
    sign_in users(:user2)
    get :new
    assert_response :success
  end
  test "new article has to belong to current user" do
    sign_in users(:user2)
    get :new
    assert assigns(:article).user_id == users(:user2).id, "Article does not belong to current user"
  end
  test "should get edit to own article signed in" do
    sign_in users(:user2)
    get :edit, :id => @article_user2.to_param
    assert_response :success
  end
  test "edited article has to belong to current user" do
    sign_in users(:user2)
    get :edit, :id => @article_user1.to_param
    assert_redirected_to root_url, "Should be redirected to root url if article of other user is requested"
    assert_equal 'The article you requested could not be found.', flash[:error]
  end
  
  # create
  test "should not create article anonymous" do
    assert_no_difference('Article.count') do
      post :create, :article => @article_user1.attributes
    end
  end
  test "should not create article linked to other user" do
    sign_in users(:user2)
    post :create, :article => { :user_id => users(:user1).id, :title => 'Title', :teaser => 'Teaser', :body => 'Body' }
    assert assigns(:article).user_id == users(:user2).id, "Article does not belong to current user"   
  end
  test "should create article signed in" do
    sign_in users(:user2)
    assert_difference('Article.count', 1, "Article count has not changed") do
       post :create, :article => { :user_id => users(:user2).id, :title => 'Title', :teaser => 'Teaser', :body => 'Body' }
    end
    assert_redirected_to article_path(assigns(:article))
    assert_equal 'Article was successfully created.', flash[:notice]
  end
  
  # update
  test "should not update article anonymous" do  
    put :update, :id => @article_user1.to_param, :article => @article_user1.attributes
    assert_redirected_to new_user_session_path
  end
  test "should update article signed in" do
    sign_in users(:user2)
    put :update, :id => @article_user2.to_param, :article => @article_user2.attributes
    assert_redirected_to article_path(assigns(:article))
  end
  test "should not update article linked to other user" do
    sign_in users(:user2)
    put :update, :id => @article_user1.to_param, :article => @article_user1.attributes
    assert_redirected_to root_url, "Should be redirected to root url if article of other user is requested"
    assert_equal 'The article you requested could not be found.', flash[:error]
  end
	test "should not update title teaser if published" do
	  sign_in users(:user2)
	  # :six has state 3, :seven has state 4
	  put :update, :id => articles(:six).id, :article => { :title => 'newtitle', :teaser => 'newteaster'}
	  assert assigns(:article).title != 'newtitle'
	  assert assigns(:article).teaser != 'newteaser'
	  assert_redirected_to article_path(assigns(:article))
	  put :update, :id => articles(:seven).id, :article => { :title => 'newtitle', :teaser => 'newteaster'}
	  assert assigns(:article).title != 'newtitle'
	  assert assigns(:article).teaser != 'newteaser'
	  assert_redirected_to article_path(assigns(:article))
	end

  # destroy
  test "should not destroy article anonymous" do
    assert_no_difference('Article.count') do
      delete :destroy, :id => @article_user1.to_param
    end
    assert_redirected_to new_user_session_path
  end
  test "should destroy article signed in" do
    sign_in users(:user2)
    assert_difference('Article.count', -1) do
      delete :destroy, :id => @article_user2.to_param
    end
    assert_redirected_to myarticles_articles_path
  end
  test "should not destroy article linked to other user" do
    sign_in users(:user2)
    assert_no_difference('Article.count', "Article count has changed") do
      delete :destroy, :id => @article_user1.to_param
    end
    assert_redirected_to root_url, "Should be redirected to root url if article of other user is requested"
    assert_equal 'The article you requested could not be found.', flash[:error]
  end  
	test "should not destroy accepted article" do
	  sign_in users(:user2)
	  assert_no_difference('Article.count', "Article count has changed but should not") do
	    delete :destroy, :id => articles(:six).id
	  end
	  assert_redirected_to myarticles_articles_path
	  assert_equal 'The article could not be deleted.', flash[:error]
	end
	test "should not destroy featured article" do
	  sign_in users(:user2)
	  assert_no_difference('Article.count', "Article count has changed but should not") do
	    delete :destroy, :id => articles(:seven).id
	  end
	  assert_redirected_to myarticles_articles_path
	  assert_equal 'The article could not be deleted.', flash[:error]
	end
end