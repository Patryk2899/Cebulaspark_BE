ActiveAdmin.register Bargain do
  permit_params :id, :active, :link, :description, :title, :created_at, :user_id, :main_image
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :title, :active, :ends_at, :description, :link, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :active, :ends_at, :description, :link, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  filter :categories

  show do
    attributes_table do
      row :id
      row :active
      row :link
      row :description
      row :title
      row :created_at
      row :user_id
      active_admin_comments
    end
  end
end
