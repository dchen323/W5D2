class CommentsController < ApplicationController
  
  before_action :require_log_in
  
  def new
    @comment = Comment.new
    render :new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    @comment.post_id = params[:post_id]
    
    if @comment.save
      redirect_to post_url(@comment.post_id)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end
  
  def edit 
    @comment = Comment.find(params[:id])
    render :edit
  end
  
  def update
    @comment = Comment.find(params[:id])
    
    if @comment.author != current_user
      flash[:notice] = ["You may not edit comments for which you are not the author."]
      redirect_to post_url(@comment.post_id)
    elsif @comment.update(comment_params)
      redirect_to post_url(@comment.post_id)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :edit
    end
  end 
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_url(@comment.post_id)
  end

  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
  
end
