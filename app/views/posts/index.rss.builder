xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "同好汇"
    xml.description "网络书签"
    xml.link posts_url

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description do 
          xml.cdata! auto_link(simple_format(post.content), link: :urls, html: { target: '_blank', rel: "nofollow" })
        end
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link post_url(post)
        xml.guid post_url(post)
      end
    end
  end
end
