module Blog
  class Tag < Class.new(Swift::Scheme) do
      store :tags
      attribute :post_id, Swift::Type::Integer
      attribute :name,    Swift::Type::String
      belongs_to :post
    end

    def to_s
      name
    end
  end
end
