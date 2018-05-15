class PostsController < ApplicationController
  before_action :require_log_in, except: [:show]
  
  def new
    @post = Post.new
    render :new
  end
  
  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if params[:post][:sub_ids] == [""]
      flash.now[:errors] = ["Must pick a sub"]
      render :new
      return
    end
    if @post.save
      redirect_to post_url(@post)
    else 
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end
  
  def update
    @post = Post.find(params[:id])
    if params[:post][:sub_ids] == [""]
      flash.now[:errors] = ["Must pick a sub"]
      render :new
      return
    end
    if @post.author != current_user
      flash[:notice] = ["You may not edit posts for which you are not the author."]
      redirect_to post_url(@post)
    elsif @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    render :show
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = ["Post has been deleted!"]
    redirect_to :root
  end

  
  private
  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
