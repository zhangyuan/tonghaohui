# encoding: utf-8
class MyController < ApplicationController
  require_sign_in
  
  def change_password
  end
  
  def update_password
    if current_user.update_attributes(params[:user].slice(:password, :password_confirmation))
      flash[:notice] = '密码已修改'
      redirect_to root_path
    else
      render :change_password
    end
  end
end
