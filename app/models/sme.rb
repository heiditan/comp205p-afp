class Sme < ActiveRecord::Base 
	has_one :user, :as => :rolable
end
	