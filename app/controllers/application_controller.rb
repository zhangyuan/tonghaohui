# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current
    if request_from_self?
      visits_count = Statistic.r_visits_counter.increment    
      render json: {status: 0, visits_count: visits_count}
    else
      render json: {status: 1}
    end
  end

  protected
  
  helper_method :current_user, :current_profile
    
  def request_from_self?
    request.referer.present? and
      URI.parse(request.referer).host.split('.').last(2) == request.host.split('.').last(2)
  end

  def store_user(user)
    session[:uid] = user.id
  end
  
  def clear_user
    session[:uid] = nil
  end
  
  def store_profile(profile)
    session[:pid] = profile.id
  end
  
  def clear_profile
    session[:pid] = nil
  end
  
  def current_profile
    if defined?(@current_profile)
      @current_profile
    else
      @current_profile = session[:pid] && Profile.where(id: session[:pid]).first
    end
  end

  def current_user
    if defined?(@current_user)
      @current_user
    elsif session[:uid].blank?
      @current_user = nil
    else
      @current_user = session[:uid] && User.where(id: session[:uid]).first
    end
  end
  
  def require_user_sign_out
    if current_user
      flash[:notice] = '请先退出'
      redirect_to root_path
    end
  end
  
  def self.require_sign_in(options = {})
    before_filter :require_sign_in, options
  end
  
  def require_sign_in
    if current_user.blank?
      flash[:notice] = '请先登录'
      redirect_to sign_in_path
    end
  end
  
  def current_page
    [[params[:page].to_i, 1].max, 100].min
  end

  helper_method :seo_title, :append_seo_title, :prepend_seo_title

  def seo_title
    @seo_title ||= default_seo_title
  end

  def append_seo_title(title)
    @seo_title ||= ""
    @seo_title.concat title
  end

  def prepend_seo_title(title)
    @seo_title ||= ""
    @seo_title.prepend title
  end

  def default_seo_title
    t('seo.title')
  end

  def seo_site_title
    t('seo.title')
  end

  alias seo_site_title default_seo_title
end
