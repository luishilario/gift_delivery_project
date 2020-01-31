class School < ApplicationRecord
    has_many :recipients
    has_many :orders
end

