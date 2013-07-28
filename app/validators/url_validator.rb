# encoding: utf-8
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present?
      uri = URI.parse(value)
      unless [URI::HTTP, URI::HTTPS].include?(uri.class)
        record.errors.add(attribute, '不合法')
      end
    end
  end
end
