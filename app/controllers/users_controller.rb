# encoding: utf-8
class UsersController < ApplicationController
  before_filter :require_user_sign_out  
  before_filter :require_profile_without_user

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      store_user(@user)
      current_profile.user = @user
      current_profile.save
      redirect_to root_url
    else
      render :new
    end
  end
  
  protected
  
  def require_profile_without_user
    if current_profile.try(:user)
      flash[:notice] = '已经绑定到其他账户，请先登录后解除绑定'
      redirect_to root_path
    elsif current_profile.blank?
      flash[:notice] = '请先通过第三方账户登录，登录后可以创建用户'
      redirect_to sign_in_path
    end
  end
end
