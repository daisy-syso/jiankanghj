class Users < Grape::API
  resources :users do

    desc '查询用户根据xids'
    params do
      optional :xids, type: String, desc: 'xids'
      optional :page, type: Integer, default: 1, desc: '第几页'
      optional :per, type: Integer, default: 25, values: 1..50, desc: '每页多少个'
    end
    get '', each_serializer: UserSerializer, root: 'data', serializer: PaginationSerializer do
      xids = params.xids.present? ? params.xids.split(',') : []

      if params.xids.present?
        users = User.where(xid: xids).page(page).per(per)
      else
        users = User.all.page(page).per(per)
      end

      render users
    end

    desc '所有在线用户(通过地理位置)'
    params do
      requires :lat, type: Float, desc: '纬度', default: 31.22
      requires :lon, type: Float, desc: '经度', default: 121.48
      requires :distance, type: String, desc: '距离', default: '12km'
      optional :page, type: Integer, default: 1, desc: '第几页'
      optional :per, type: Integer, default: 25, values: 1..50, desc: '每页多少个'
    end
    
    get 'neighbouring', each_serializer: UserSerializer, root: 'data', serializer: PaginationSerializer do
      users = User.neighbour(params.lat, params.lon, params.distance).records.page(params[:page]).per(params[:per])

      render users
    end

    route_param :id do
      after_validation do
        @user = User.or(id: params.id).or(xid: params.id).first
      end

      desc '用户信息'
      params do
        requires :id, type: String, desc: '用户ID', documentation: {example: '5677993da8250028b2000013'}
      end
      get '', serializer: UserSerializer, root: 'data' do
        render @user
      end

      desc '更新个人信息'
      params do 
        requires :id, type: String, desc: '用户ID', documentation: {example: '5677993da8250028b2000013'}
        requires :auth_token, type: String, desc: 'AUTH-TOKEN', documentation: {example: 'qSwxF6douB3UdRnAHukiwYgryF6RfasaIw8WOu+XPQHY3SYpz6cjG8aF9wl6fmKb+xylazHTQGaWvPEJGPdisA=='}
        requires :user, type: Hash do 
          optional :username, type: String, desc: '显示名称'
          optional :gender, type: String, desc: '性别'
          optional :summary, type: String, desc: '简介'
          optional :description, type: String, desc: '详细'
          optional :avatar, type: String, desc: '头像'
          optional :age, type: Integer, desc: '年纪'
          optional :university, type: String, desc: '学校'
          optional :profession, type: String, desc: '行业'
          optional :location, type: Hash do
            requires :lon, type: Float
            requires :lat, type: Float
          end
          optional :address, type: String, desc: '地址'
          optional :credit, type: Integer, desc: '信用'
          optional :email, type: String, desc: '邮箱'
          optional :telephone, type: String, desc: '电话'
          optional :university, type: String, desc: '学校'
          optional :last_online_time, type: DateTime, desc: '最后登录时间'
          optional :is_online, type: Boolean, desc: '是否在线'
          optional :is_indexed, type: Boolean, desc: '是否能够被搜索'
          optional :platform_id, type: String, desc: '平台号'
        end
      end
      put '', serializer: UserSerializer, root: 'data' do
        authenticate!

        if @user.update(update_params(params))
          render @user
        else
          raise Errors::ModelValidationError.new user.errors
        end
      end

      desc '退出登录'
      params do
        requires :id, type: String, desc: '用户ID', documentation: {example: '5677993da8250028b2000013'}
      end
      params do
        requires :auth_token, type: String, desc: 'AUTH-TOKEN', documentation: {example: 'qSwxF6douB3UdRnAHukiwYgryF6RfasaIw8WOu+XPQHY3SYpz6cjG8aF9wl6fmKb+xylazHTQGaWvPEJGPdisA=='}
      end
      delete do
        status 204
      end
    end

    desc '注册'
    params do
      requires :user, type: Hash do
        optional :email, type: String, desc: '邮箱'
        optional :telephone, type: String, desc: '手机号码'
        optional :username, type: String, desc: '用户名'
        requires :password, type: String, desc: '密码'
        at_least_one_of :email, :telephone, :username
      end
    end
    post '', serializer: UserSerializer, root: 'data' do
      user = User.new(register_params(params))
      begin
        xid = generate_uuid
        $openfire_client.add_user! username: xid, password: params.user.password, email: params.user.email
        user.xid = xid
      rescue Exception => e
        raise e
      end

      user.save
      
      render user
    end

    desc '登录'
    params do
      requires :account, type: String, desc: '账户telephone, email, platform_id。'
      requires :password, type: String, desc: '密码'
    end
    post 'login', serializer: UserSerializer, root: 'data' do
      account = params.account
      user = User.or(telephone: account).or(email: account).or(platform_id: account).first

      if user && user.password == params.password
        render user
      else
        raise Errors::LoginError.new
      end
    end

    desc '搜索'
    params do
      requires :query, type: String, desc: '查询用户，根据telephone, email, platform_id。'
      optional :page, type: Integer, default: 1, desc: '第几页'
      optional :per, type: Integer, default: 25, values: 1..50, desc: '每页多少个'
    end
    post 'search', serializer: UserSerializer, root: 'data' do
      query_str = CGI.unescape params.query
      user = User.or(telephone: query_str).or(email: query_str).or(platform_id: query_str).first

      render user
    end

    desc '加好友'
    params do
      requires :auth_token, type: String, desc: 'AUTH-TOKEN', documentation: {example: 'qSwxF6douB3UdRnAHukiwYgryF6RfasaIw8WOu+XPQHY3SYpz6cjG8aF9wl6fmKb+xylazHTQGaWvPEJGPdisA=='}
      requires :goodfriend_id, type: String, desc: '对方ID'
      requires :goodfriend_xid, type: String, desc: '对方XID'
    end
    post 'make_goodfriend' do
      authenticate!

      GoodfriendJob.perform_later(current_user.id.to_s, params.goodfriend_id, params.goodfriend_xid)

      status 201
    end

    desc '离线通知'
    params do
      requires :auth_token, type: String, desc: 'AUTH-TOKEN', documentation: {example: 'qSwxF6douB3UdRnAHukiwYgryF6RfasaIw8WOu+XPQHY3SYpz6cjG8aF9wl6fmKb+xylazHTQGaWvPEJGPdisA=='}
      requires :goodfriend_id, type: String, desc: '对方ID'
      requires :goodfriend_xid, type: String, desc: '对方XID'
      requires :content, type: String, desc: '内容, 如果是图片请发送（一张图片）', documentation: {example: '可以交往吗？'}
    end
    post 'offline' do
      authenticate!

      OfflineJob.perform_later(current_user.id.to_s, params.goodfriend_id, params.goodfriend_xid, params.content)

      status 201
    end
  end
end