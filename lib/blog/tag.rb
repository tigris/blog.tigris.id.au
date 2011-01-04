module Blog
  class Tag < Class.new(Swift::Scheme) do
      attribute :post_id, Swift::Type::Integer
      attribute :name,    Swift::Type::String
    end
    store :tags

    def to_s
      name
    end
  end
end
