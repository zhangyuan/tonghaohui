module Admin::ApplicationHelper
  def will_paginate(collection = nil, options = {})
    options[:renderer] ||= WillPaginate::ActionView::BootstrapLinkRenderer
    super
  end
end
