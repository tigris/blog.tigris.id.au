module Blog
  class PostTag < Swift::Scheme
    store :posts_tags
    attribute :post_id, Swift::Type::Integer
    attribute :tag_id,  Swift::Type::Integer

    def tag
      Tag.get(tag_id)
    end
  end
end
