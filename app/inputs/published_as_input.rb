# -*- encoding : utf-8 -*-
class PublishedAsInput < SimpleForm::Inputs::CollectionSelectInput
  def collection
    @collection ||= begin
      object.class.publishing_statuses.map do |name|
        [object.class.publishing_status_i18n_name(name), name]
      end
    end
  end

  def skip_include_blank?
    true
  end
end
