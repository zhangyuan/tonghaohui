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
  
  def seo_title
    t('seo.title')
  end
end
