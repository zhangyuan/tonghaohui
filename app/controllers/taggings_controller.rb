class TaggingsController < ApplicationController
  def show
    @taggings = Tagging.published_as(:published).order('id desc').where('taggable_id > 0').where(indexable: params[:title].to_s.downcase).includes(:post => [:user, :taggings]).page(current_page).per_page(20)
  end
end
