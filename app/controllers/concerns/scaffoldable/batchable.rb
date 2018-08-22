# frozen_string_literal: true

# HINT: 一括処理を付与出来ます。
# 機能の組み合わせ可能一覧
# - Scaffoldable::Confirming

module Scaffoldable
  module Batchable
    extend ActiveSupport::Concern

    included do
      before_action :set_search_params, only: %i[index]
    end

    def model_instance
      if action?(:new, :create)
        instance_variable_get("@#{collection_model.model_name.singular}".to_sym)
      else
        instance_variable_get("@#{model.model_name.singular}".to_sym)
      end
    end

    def new_model_instance(params = nil)
      instance_variable_set(
        "@#{collection_model.model_name.singular}".to_sym,
        new_model(params)
      )
    end

    def after_index
      return unless action?(:index)
      @forms_collection = collection_model.new(
        element_model: element_model,
        elements: ActiveType.cast(
          model_instances, element_model
        ).includes(resources_includes).references(resources_references)
      )
    end

    def new_model(params = nil)
      if params.nil?
        collection_model.new(element_model: element_model)
      else
        collection_model.new(params.merge(element_model: element_model))
      end
    end

    def set_search_params
      @search_params = params.permit!.to_h[:q] if params[:q].present?
    end

    def url_after_creating
      set_search_params
      url_for(action: :index, q: @search_params)
    end

    def after_failed_creating
      set_search_params
      process_index
      after_index
    end

    def render_failed_creating
      render_index
    end

    def element_model
      raise NotImplementedError, "include先で定義すること"
    end

    def collection_model
      raise NotImplementedError, "include先で定義すること"
    end
  end
end
