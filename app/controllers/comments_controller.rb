class CommentsController < ApplicationController
  def create
#    return render text: "#{params}"
    @book_post = BookPost.find(params[:book_post_id])
    @comment = @book_post.comments.build(body: params[:comment][:body])
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end
end
