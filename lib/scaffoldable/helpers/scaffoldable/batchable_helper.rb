# frozen_string_literal: true
module Scaffoldable
  module BatchableHelper
    def batchable_element_viewable?(element_model_instance, options = {})
      result = (element_model_instance.selected.nil? || element_model_instance.selected)
      result = options[:confirming] ? result && options[:confirming] : true unless options[:confirming].nil?
      result
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include Scaffoldable::BatchableHelper
end
