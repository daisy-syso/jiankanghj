class InformationTypes < Grape::API
  resources :information_types do

    desc '查询资讯分类'
    get '', each_serializer: InformationTypeSerializer, root: 'data' do
      information_types = InformationType.where(parent_id: nil).order("created_at desc")

      render information_types
    end

    desc '资讯'
    get 'informations', root: 'data'  do
      information_types = InformationType.where(parent_id: nil).order("created_at desc")

      information_lists = []

      information_types.each do |it|
        parent_id = it.parent_id || it.id
        pageset = (it.name == '头条' || it.name == '天天护理') ? 12 : 8
        top_infors = "(select * from informations where information_type_id = #{parent_id} and is_top is true and types = 0 order by str_to_date(created_at,'%Y-%m-%d %H:%i:%s') desc limit #{it.top_number})"
        if it.parent_id.blank?
          ids = it.children_items.map(&:id) + [it.id]
          select_infos = "(select * from informations where information_type_id in (#{ids.join(',')}) and is_top is not true and types = 0"
        else
          part_infors = "(select * from informations where information_type_id = #{it.id} and is_top is not true and types = 0)"
          ids = (it.parent_item.children_items.map(&:id) + [it.parent_item.id]).delete_if{|i| i == it.id}
          select_infos = part_infors + " union " + "(select * from informations where information_type_id in (#{ids.join(',')}) and is_top is not true and types = 0"
        end
        info_sql = top_infors + " union " + select_infos + " order by str_to_date(created_at,'%Y-%m-%d %H:%i:%s') desc limit #{pageset} offset #{((params[:page] || 1).to_i - 1) * pageset})"

        it.latest_informations = Information.unscope(:where).find_by_sql(info_sql)

        video_category2 = case it.name
        when '头条'
          video_category = VideoCategory.where(name: '资讯').first
        when '养生'
          video_category = VideoCategory.where(name: '养生').first
        when '长寿'
          video_category = VideoCategory.where(name: '老年').first
        when '健康管理'
          video_category = VideoCategory.where(name: '常识').first
        when '天天护理'
          video_category = VideoCategory.where(name: '美容').first
        when '寻医'
          video_category = VideoCategory.where(name: '医疗').first
        when '母婴'
          video_category = VideoCategory.where(name: '儿科').first
        when '两性健康'
          video_category = VideoCategory.where(name: '两性').first
        when '健身减肥'
          video_category = VideoCategory.where(name: '健身').first
        else
          video_category = ''
        end

        top_video = if video_category.present?
          Video.select('id, album_name, pic_url, tv_id, time_length, html5_play_url, create_time, video_category_id').where(video_category_id: video_category.id).order("create_time desc").limit(2)
        else
          {}
        end

        types_image = case it.name
        when '头条'
          Information.select('id, name, image_url').unscope(:where).where(types: 5).order("created_at desc").limit(2)
        when '天天护理'
          Information.select('id, name, image_url').unscope(:where).where(types: 6).order("created_at desc").limit(2)
        end

        information_lists << {
          id: it.id,
          name: it.name,
          informations: it.latest_informations,
          sub_types: it.children_items,
          top_videos: top_video,
          video_category: video_category2,
          types_images: types_image
        }
      end

      information_lists
    end
  end
end