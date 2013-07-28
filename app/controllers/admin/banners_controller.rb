# encoding: utf-8
class Admin::BannersController < Admin::ApplicationController
  before_filter :find_banner_type, only: [:index]

  def home
    @banners = Banner.order('id DESC').page(current_page).per_page(20)
  end

  def current
    @banners = Banner.published_as(:published).current.order('id DESC').page(current_page).per_page(20)
  end

  def new
    @banner = Banner.new(type_name: params[:type_name], begin_time: Time.now, end_time: 7.days.from_now)
  end

  def create
    @banner = Banner.new(params[:banner])   
    @banner.published_as = :published
    if @banner.save
      redirect_to admin_banner_path(@banner.id)
    else
      render :new
    end
  end

  def index
    @banners = Banner.with_type_name(current_type_name).order('id DESC').page(current_page).per_page(20)
  end

  def show
    @banner = Banner.find(params[:id]) 
  end

  def edit
    @banner = Banner.find(params[:id])
  end

  def update
    @banner = Banner.find(params[:id])
    if @banner.update_attributes(params[:banner])
      redirect_to admin_banner_path(@banner.id)
    else
      render :edit
    end
  end

  def destroy
    @banner = Banner.find(params[:id])   
    @banner.published_as = :deleted
    @banner.save!
    respond_to do |format|
      format.html { redirect_to (request.referer || admin_banners(@banner.type_name)) }
    end
  end

  protected

  def find_banner_type
    if type_id = Banner.fetch_type_id(params[:type_name])
      @current_type_name = params[:type_name]
    else
      flash[:notice] = "广告类型不存在"
      redirect_to admin_banners_home_path
    end
  end

  helper_method :current_type_name

  def current_type_name
    @current_type_name    
  end
end
