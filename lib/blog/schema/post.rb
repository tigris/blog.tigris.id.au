module Blog
  module Schema
    class Post < Swift::Scheme
      store :posts
      attribute :id,         Swift::Type::Integer, serial: true, key: true
      attribute :slug,       Swift::Type::String
      attribute :title,      Swift::Type::String
      attribute :content,    Swift::Type::String
      attribute :created_at, Swift::Type::Time, default: proc{ Time.now }
    end
  end
end
