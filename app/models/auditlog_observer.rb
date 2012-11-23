class AuditlogObserver < ActiveRecord::Observer
	include UserInfo
	observe :device, :user

	def after_save(model)
		unless model.audit_log_message == nil
			msg =  model.audit_log_message 
			msg.merge!(:user_id => current_user)
			Auditlog.create!(msg) 
		end
	end

	def after_destroy(model)
		msg =  model.audit_log_message
		msg.merge!(:user_id => current_user)
		Auditlog.create!(msg) 
	end
end
