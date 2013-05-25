class ConnectsController < ApplicationController  
  def new
    redirect_to oauth_client.authorize_url
  end
  
  def callback
    oauth_client.get_auth_token(params[:code])
    profile = Profile.build_from_oauth_client(oauth_client)
    if profile.save
      render json: profile.inspect
    else
      render json: {e: profile.errors.full_messages, a: profile.inspect, s: profile.provider}
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
