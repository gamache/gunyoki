class Account < ActiveRecord::Base
  belongs_to :player
  belongs_to :server

end
