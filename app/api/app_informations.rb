class AppInformations < Grape::API
  resources :apps do

    desc 'App大全'
    get '', each_serializer: AppInformationSerializer, root: 'data' do
      apps = AppInformation.group(:type_id).order(:type_id).first(5)

      render apps
    end
  end
end

