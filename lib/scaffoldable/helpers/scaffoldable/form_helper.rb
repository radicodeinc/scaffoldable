# frozen_string_literal: true
module Scaffoldable
  module FormHelper
    def style_id(form, name)
      (form.lookup_model_names + [name.to_s]).join("_")
    end

    def none_display_hidden_field(form, name, value = nil, options = {})
      options = options.merge(value: value) if value.present?
      form.hidden_field name, options
    end

    def required?(form, field_name)
      form.object.class.validators_on(field_name).select do |v|
        v.is_a?(ActiveRecord::Validations::PresenceValidator)
      end.present?
    end
  end
end
