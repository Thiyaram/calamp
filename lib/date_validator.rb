class ActiveRecord::Base
  include ActiveModel::Validations

  class DateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      date_value = record.send("#{attribute}_before_type_cast")
      unless record.errors[attribute].present?
        record.errors[attribute] << "is invalid" unless (Date.parse(date_value) rescue nil)
      end
    end
  end

  class DateTimeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      date_value = record.send("#{attribute}_before_type_cast")
      unless record.errors[attribute].present?
        record.errors[attribute] << "is invalid" unless (DateTime.parse(date_value) rescue nil)
      end
    end
  end

end
