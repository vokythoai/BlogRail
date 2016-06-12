class PostData < ActiveRecord::Base
  validates :url,uniqueness: true

end