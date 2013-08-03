namespace :post do
  desc 'sync visits_count between mysql and redis'
  task sync_visits_count: :environment do
    Post.published_as(:published).find_each do |post|
      updated_columns = {}
      if post.clicks_count > (count = post.r_clicks_count.value)
        post.r_clicks_count.increment(post.clicks_count - count)
      elsif post.clicks_count < post.r_clicks_count.value
        updated_columns[:clicks_count] = post.r_clicks_count.value
      end

      if post.views_count > (count = post.r_views_count.value)
        post.r_views_count.increment(post.views_count - count)
      elsif post.views_count < post.r_views_count.value
        updated_columns[:views_count] = post.r_views_count.value
      end

      unless updated_columns.empty?
        Post.unscoped.update_all(updated_columns, post.class.primary_key => post.id)
      end
    end
  end
end
