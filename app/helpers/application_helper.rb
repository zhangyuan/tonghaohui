module ApplicationHelper
  def fetch_url_host(url)
    URI.parse(url).host rescue ''
  end
  
  def sidebar_sign_in_form?
    true
  end
  
  def sidebar_submit_new_post_button?
    true
  end

  def tracking_code
    Settings.tracking_code.to_s.html_safe
  end

  def will_paginate(collection = nil, options = {})
    options[:renderer] ||= WillPaginate::ActionView::LinkRenderer
    super
  end

  def fetch_banner(type_name)
    banners = Banner.published_as(:published).with_type_name(type_name).current.limit(30).to_a.sample
  end
end
