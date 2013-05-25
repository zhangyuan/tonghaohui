# encoding: utf-8
class SessionsController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.where(username: params[:username]).first
    if @user && @user.authenticate(params[:password])
      store_user(@user)
      flash[:notice] = '登录成功'
      redirect_to root_url
    else
      flash.now[:alert] = '用户名或密码错误'
      render :new
    end
  end
  
  def destroy
    clear_user
    clear_profile
    redirect_to root_url
  end
end
