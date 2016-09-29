ActiveAdmin.register User do

  action_item :index, only: :index do
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
