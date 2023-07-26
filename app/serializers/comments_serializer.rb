class CommentsSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :associated_user, :bargain_id

  def associated_user
    user = object.user

    { id: user.id, email: user.email }
  end
end
