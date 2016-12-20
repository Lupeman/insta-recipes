class Blog < ActiveRecord::Base
  belongs_to :cse
  validates :blog_name, presence: true
end
