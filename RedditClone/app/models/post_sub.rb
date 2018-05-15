# == Schema Information
#
# Table name: post_subs
#
#  id         :bigint(8)        not null, primary key
#  post_id    :integer          not null
#  sub_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PostSub < ApplicationRecord
  validates :post_id, uniqueness: {scope: :sub_id}
  validates :post, :sub, presence: true
  #custom validation for uniqueness
  belongs_to :post, inverse_of: :post_subs
  belongs_to :sub, inverse_of: :post_subs
  
end
