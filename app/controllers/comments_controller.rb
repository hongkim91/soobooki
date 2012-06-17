class CommentsController < ApplicationController
  def create
    if params[:book_post_id].present?
      @post = BookPost.find(params[:book_post_id])
    else
      @post = MoviePost.find(params[:movie_post_id])
    end
    @comment = @post.comments.build(body: params[:comment][:body])
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.js
      end
    end
  end

  def destroy
#    return render text: "#{params}"
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.js
    end
  end
end
