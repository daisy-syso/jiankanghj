require 'kaminari/grape'
require 'grape-active_model_serializers'
require "grape-swagger"

class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::ActiveModelSerializers

  rescue_from :all do |e|
    case e
    when ActiveRecord::RecordNotFound
      error!({ messages: '数据不存在' }, 404)
    when Grape::Exceptions::ValidationErrors
      error!({ messages: e.errors }, 400)
    when Errors::AuthTokenError
      error!({ messages: e.errors }, 401)
    when Errors::LoginError
      error!({ messages: e.errors }, 401)
    else
      Rails.logger.error "Api Error: #{e}\n#{e.backtrace.join("\n")}"
      error!({ messages: 'API 接口异常' }, 500)
    end
  end
  
  helpers Helper

  mount Users
  mount AppInformations
  mount InformationTypes
  mount Informations

  add_swagger_documentation(
    base_path: '/api',
    hide_documentation_path: true,
    hide_format: true
  )

  route :any, '*path' do
    status 404
    { error: 'Page not found.' }
  end

  
end