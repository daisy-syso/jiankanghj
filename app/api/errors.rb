module Errors
  class AuthTokenError < StandardError
    def initialize(state)
      @state = state
    end

    def errors
      case @state
      when :missing
        '丢失 Token'
      when :invalid
        '非法 Token'
      else
      end
    end
  end

  class LoginError < StandardError
    def errors
      '用户名或者密码错误'
    end
  end
end