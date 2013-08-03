module PostsHelper
  def find_related_posts(post)
    posts = post.published_posts_with_same_tags.includes(:published_taggings, :user)
    posts += post.published_posts_with_same_host.limit(10).includes(:published_taggings, :user)
    posts.delete_if {|p| p.id == post.id}
    posts.sample(3)
  end

  def rand_posts(post)
    post_ids = Post.order('id desc').limit(200).pluck(:id)
    post_ids = post_ids.sample(4)
    post_ids.delete_if {|id| id == post.id}
    Post.where(id: post_ids.sample(2)).includes(:user, :published_taggings).published_as(:published)
  end
end
