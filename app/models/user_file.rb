class UserFile < ActiveRecord::Base


  # Uncomment below line if you want to use local storage
  # has_attached_file :attachment


  # Uncomment below lines if you want to use Amazon s3 storage ---
  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => ":attachment/:id/:style/:basename.:extension",
    :bucket => 'devinc'
  # Uncomment above lines if you want to use Amazon s3 storage ---


  validates_attachment_presence :attachment
  belongs_to :user
end

