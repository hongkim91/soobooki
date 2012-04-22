require 'test_helper'

class BookPostsControllerTest < ActionController::TestCase
  setup do
    @book_post = book_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:book_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create book_post" do
    assert_difference('BookPost.count') do
      post :create, book_post: { book_id: @book_post.book_id, review: @book_post.review, user_id: @book_post.user_id }
    end

    assert_redirected_to book_post_path(assigns(:book_post))
  end

  test "should show book_post" do
    get :show, id: @book_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @book_post
    assert_response :success
  end

  test "should update book_post" do
    put :update, id: @book_post, book_post: { book_id: @book_post.book_id, review: @book_post.review, user_id: @book_post.user_id }
    assert_redirected_to book_post_path(assigns(:book_post))
  end

  test "should destroy book_post" do
    assert_difference('BookPost.count', -1) do
      delete :destroy, id: @book_post
    end

    assert_redirected_to book_posts_path
  end
end
