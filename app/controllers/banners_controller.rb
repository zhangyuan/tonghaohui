class BannersController < ApplicationController
  def click
    @banner = Banner.find(params[:id])
    @banner.r_clicks_count.increment
    redirect_to @banner.url
  end
end
