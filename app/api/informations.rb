class Informations < Grape::API
  resources :informations do

    desc '查询资讯Banner'
    get 'banners', each_serializer: InformationSerializer, root: 'data' do
      informations = Information.where(is_top: true).where.not(image_url: nil).order("created_at desc").limit(4)

      render informations
    end

    desc '热门图片'
    get 'hot_images', each_serializer: InformationSerializer, root: 'data' do
      informations = Information.where(types: 7).order("created_at desc").limit(2)

      render informations
    end
  end
end