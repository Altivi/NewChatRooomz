ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
#   permit_params :email, :password, :nickname
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  action_item only: :index do
    link_to 'Upload users', action: 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, method: :post do
    user_skip_confirmation = lambda { |object| object.skip_confirmation! }
    fields = [:email, :password, :nickname]
    if errors = CsvImportable.convert_and_save("user", params[:dump][:file], fields, user_skip_confirmation)
      flash[:notice] = errors
    end
    redirect_to action: :index
  end

end
