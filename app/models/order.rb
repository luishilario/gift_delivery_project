class Order < ApplicationRecord
  belongs_to :school
  has_and_belongs_to_many :recipients
  has_and_belongs_to_many :gifts

  enum status: [:ORDER_CANCELLED, :ORDER_RECEIVED, :ORDER_PROCESSING, :ORDER_SHIPPED]
end
