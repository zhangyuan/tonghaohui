# encoding: utf-8
class ConnectsController < ApplicationController  
  def auth
    redirect_to oauth_client.authorize_url
  end
  
  def callback
    oauth_client.get_auth_token(params[:code])
    
    profile = Profile.find_with_oauth_client(oauth_client)

    if current_user
      if profile.try(:user) == current_user
        redirect_to root_url and return
      else
        flash[:alert] = '已经绑定到其他账户'
        redirect_to root_url and return
      end
    else
      if profile and profile.user
        store_user(profile.user)
        store_profile(profile)
        redirect_to root_url and return
      else
        profile = Profile.build_from_oauth_client(oauth_client)
        profile.save!
      end
      store_profile(profile)
      redirect_to register_path
    end
  end
  
  def cancel
    render text: 'cancel'
  end
  
  protected
  
  def oauth_client
    @oauth_client ||= begin
      provider = params[:provider].to_s.classify
      Auth.const_get(provider).new
    end
  end
end
