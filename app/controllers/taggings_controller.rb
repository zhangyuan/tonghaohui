class TaggingsController < ApplicationController
  def show
    @taggings = Tagging.where(indexable: params[:title].to_s.downcase).includes(:post => [:user, :taggings]).page(current_page).per_page(20)
  end
end
