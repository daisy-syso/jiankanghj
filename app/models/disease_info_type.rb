class DiseaseInfoType < ActiveRecord::Base
  belongs_to :parent, class_name: 'DiseaseInfoType', foreign_key: 'parent_id'
  has_many :children, class_name: 'DiseaseInfoType', foreign_key: 'parent_id'

  belongs_to :follow
end