class CommentsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :body, :created_at
end
