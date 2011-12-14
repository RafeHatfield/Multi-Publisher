require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  # create 
  test "should not create rating anonymous" do
    assert_no_difference('Rating.count', 'Rating count has changed but should not') do
      post :create, :article_id => articles(:seven).id, :rating => { :user_id => users(:user2).id, :stars => 4 }
    end
    assert_redirected_to new_user_session_path
  end  
  test "should create rating signed in" do
    sign_in users(:user2)
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :article_id => articles(:seven).id, :rating => { :user_id => users(:user2).id, :stars => 4 }
    end
    assert_redirected_to article_path(assigns(:article))
    assert_equal 'Thank you for rating this article!', flash[:notice]
  end
  test "should not create rating not assigned to article" do
    sign_in users(:user2)
    assert_raises(ActiveRecord::RecordNotFound) do
      assert_no_difference('Rating.count', "Rating count has changed but should not") do
        post :create, :article_id => 100, :rating => { :user_id => users(:user2).id, :stars => 4 }
      end  
    end
  end
  test "should not create rating not assigned to other user" do
    sign_in users(:user2)
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :article_id => articles(:seven).id, :rating => { :user_id => users(:user1).id, :stars => 4 }
    end
    assert assigns(:rating).user_id == users(:user2).id, "Raing does not belong to the current user"   
  end    
  test "should not assign rating to other article" do
    sign_in users(:user2)
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :article_id => articles(:seven).id, :rating => { :article_id => articles(:six).id, :user_id => users(:user2).id, :stars => 4 }
    end
    assert_redirected_to article_path(assigns(:article))
    assert_equal 'Thank you for rating this article!', flash[:notice]
    assert assigns(:rating).article_id ==  articles(:seven).id, "Rating does not belong to the right article"   
  end
  test "should create rating for published articles only" do
    sign_in users(:user2)
    assert_no_difference('Rating.count', 'Rating count has changed but should not') do
      post :create, :article_id => articles(:three).id, :rating => { :user_id => users(:user2).id, :stars => 4 }
    end
    assert_no_difference('Rating.count', 'Rating count has changed but should not') do
      post :create, :article_id => articles(:four).id, :rating => { :user_id => users(:user2).id, :stars => 4 }
    end
    assert_no_difference('Rating.count', 'Rating count has changed but should not') do
      post :create, :article_id => articles(:five).id, :rating => { :user_id => users(:user2).id, :stars => 4 }
    end    
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :article_id => articles(:six).id, :rating => { :user_id => users(:user2).id, :stars => 4 }
    end    
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :article_id => articles(:seven).id, :rating => { :user_id => users(:user2).id, :stars => 4 }
    end
  end 
 
  # update
   test "should not update rating anonymous" do  
     put :update, :article_id => articles(:seven).id, :id => ratings(:three).id, :rating => { :user_id => users(:user2).id, :stars => 2 }
     assert_redirected_to new_user_session_path
   end
   test "should update rating signed in" do
     sign_in users(:user2)
     put :update, :article_id => articles(:seven).id, :id => ratings(:three).id, :rating => { :user_id => users(:user2).id, :stars => 2 }
     assert assigns(:rating).stars == 2, "Rating has not changed"
     assert_redirected_to article_path(assigns(:article))
   end
   test "should not update rating linked to other user" do
     sign_in users(:user2)
     assert_raises(ActiveRecord::RecordNotFound) do
       put :update, :article_id => articles(:one).id, :id => ratings(:one).id, :rating => { :user_id => users(:user1).id, :stars => 2 }
     end
   end  
  
  # delete
  test "should not destroy rating anonymous" do
     assert_no_difference('Rating.count') do
       delete :destroy, :article_id => ratings(:three).article_id, :id => ratings(:three).id
     end
     assert_redirected_to new_user_session_path
   end
   test "should destroy rating signed in" do
     sign_in users(:user2)
     assert_difference('Rating.count', -1) do
       delete :destroy, :article_id => ratings(:three).article_id, :id => ratings(:three).id
     end
     assert_redirected_to article_path(assigns(:article))
   end
   test "should not destroy rating linked to other user" do
     sign_in users(:user2)
     assert_raises(ActiveRecord::RecordNotFound) do
       assert_no_difference('Rating.count', "Rating count has changed but should not") do
         delete :destroy, :user_id => users(:user1).id, :article_id => ratings(:one).article_id, :id => ratings(:one).id
       end  
     end
   end
end