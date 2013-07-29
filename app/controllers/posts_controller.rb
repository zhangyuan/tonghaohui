# encoding: utf-8
class PostsController < ApplicationController
  require_sign_in only: [:new, :create, :edit, :update, :destroy]
  
  def new
    @post = Post.new
  end
  
  def edit
    @post = Post.published_as(:published).find(params[:id])
    return unless can_edit_post?(@post)
  end
  
  def update
    @post = Post.published_as(:published).find(params[:id])
    return unless can_edit_post?(@post)
    
    if @post.update_attributes(post_params)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end
  
  def index
    @posts = Post.order('id desc').includes(:user, :published_taggings).published_as(:published).page(current_page).per_page(30)
    respond_to do |format|
      format.html
      format.rss {render layout: false}
    end
  end
  
  def show
    @post = Post.published_as(:published).find(params[:id])

    append_seo_title(@post.title)
    append_seo_title " - "
    append_seo_title(seo_site_title)
  end
  
  def create
    @post = current_user.posts.new(post_params)
    @post.published_as = :published
    if @post.save
      redirect_to posts_url
    else
      render :new
    end
  end
  
  def destroy
    @post = Post.published_as(:published).find(params[:id])
    return unless can_destroy_post?(@post)
    @post.set_deleted!
    redirect_to posts_path
  end

  def request_from_self?
    request.referer.present? and
      URI.parse(request.referer).host.split('.').last(2) == request.host.split('.').last(2)
  end

  def view
    @post = Post.published_as(:published).find(params[:id]) 
    if request_from_self?
      @post.r_views_count.increment
    end

    respond_to do |format|
      format.html { render text: '^_^' }
      format.json { render json: {status: 0}}
    end
  end

  def click
    @post = Post.published_as(:published).find(params[:id]) 

    logger.debug "click referer: #{request.referer}"
    logger.debug "click host: #{request.host}"

    if request_from_self?
      @post.r_clicks_count.increment
    end

    respond_to do |format|
      format.html { render text: '^_^' }
      format.json { render json: {status: 0}}
    end
  end
  
  protected
  
  def post_params
    params[:post].slice(:title, :url, :content, :tag_list)
  end
  
  def can_edit_post?(post)
    unless post.edited_by?(current_user)
      flash[:alert] = '对不起，你没有权限操作'
      redirect_to post_path(@post) and return
      false
    else
      true
    end
  end
  
  alias_method :can_destroy_post?, :can_edit_post?
end
