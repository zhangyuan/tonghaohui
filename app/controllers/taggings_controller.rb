# encoding: utf-8
class TaggingsController < ApplicationController
  def show
    @taggings = Tagging.published_as(:published).order('id desc').where('taggable_id > 0').where(indexable: params[:title].to_s.downcase).includes(:post => [:user, :published_taggings]).page(current_page).per_page(20)
    append_seo_title(params[:title])
    append_seo_title(" (标签)")
    append_seo_title " - "
    append_seo_title(seo_site_title)
  end
end
