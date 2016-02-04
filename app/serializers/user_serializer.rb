class UserSerializer < BaseSerializer
  attributes :auth_token, :username, :avatar, :age, :gender, :university, :profession, :email, :location, :address, :max_publish, :visited, :summary, :telephone, :description, :platform_id, :credit, :role, :xid, :is_online, :is_indexed, :last_online_time, :day_publish, :total_publish

  def role
    'common'
  end

  def day_publish
    0
  end

  def total_publish
    0
  end
end