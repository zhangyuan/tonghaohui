# encoding: utf-8
class TaggingsController < ApplicationController
  def show
    @taggings = Tagging.published_as(:published).order('taggings.id desc').where('taggings.taggable_id > 0').where(indexable: params[:title].to_s.downcase).page(current_page).per_page(20)
    @taggables = Post.published_as(:published).where(id: @taggings.pluck(:taggable_id)).includes([:user, :published_taggings])
    append_seo_title(params[:title])
    append_seo_title(" (标签)")
    append_seo_title " - "
    append_seo_title(seo_site_title)
  end
end
