class Normaluser
	class Device < Device
		scope :all, where(:status => true)
	end
end