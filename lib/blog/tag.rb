module Blog
  class Tag < Swift::Scheme
    store :tags
    attribute :id,   Swift::Type::Integer, serial: true, key: true
    attribute :name, Swift::Type::String

    def to_s
      name
    end
  end
end
