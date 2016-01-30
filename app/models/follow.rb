class Follow < ActiveRecord::Base
  belongs_to :user

  has_one :disease_info_type

  before_save do
    self.top_name = DiseaseInfoType.find(DiseaseInfoType.find(self.disease_info_type_id).parent_id).name
  end
end