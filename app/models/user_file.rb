class UserFile < ActiveRecord::Base
   has_attached_file :attachment
  validates_attachment_presence :attachment
  belongs_to :user
end

