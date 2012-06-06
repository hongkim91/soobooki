class CommentsController < ApplicationController
  def create
    @book_post = BookPost.find(params[:book_post_id])
    @comment = @book_post.comments.build(body: params[:comment][:body])
    @comment.user_id = current_user.id

    d {params[:comment][:body]}
    d {@comment.body}

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
