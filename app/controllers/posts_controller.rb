class PostsController < ApplicationController
  require_sign_in only: [:new, :create]
  
  def new
    @post = Post.new
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to post_path(@post)
    else
      render :edit
    end
  end
  
  def index
    @posts = Post.order('id desc')
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to posts_url
    else
      render :new
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    redirect_to posts_path
  end
end
