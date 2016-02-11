class AppliedJob < ActiveRecord::Base
  belongs_to :user
  belongs_to :vacancy
end
