module PostsHelper
  def find_related_posts(post)
    posts = post.related_posts.order('id DESC').limit(5).includes(:published_taggings, :user).to_a
    posts.delete_if {|p| p.id == post.id}
    posts
  end

  def rand_posts(post)
    post_ids = Post.order('id desc').limit(400).pluck(:id)
    post_ids = post_ids.sample(4)
    post_ids.delete_if {|id| id == post.id}
    Post.where(id: post_ids.first(3)).includes(:user, :published_taggings).published_as(:published)
  end
end
