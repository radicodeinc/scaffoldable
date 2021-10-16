# frozen_string_literal: true

module Scaffoldable
  module PrivateMethods
    private

    def model_instance
      instance_variable_get("@#{model.model_name.singular}".to_sym)
    end

    def model_instances
      instance_variable_get("@#{model.model_name.plural}".to_sym)
    end

    def new_model_instance(params = nil)
      instance_variable_set(
        "@#{model.model_name.singular}".to_sym,
        new_model(params)
      )
    end

    def new_model(params = nil)
      params.nil? ? model.new : model.new(params)
    end

    def controller_params
      # 定義されていなければ空のハッシュオブジェクトを返す
      return {} unless respond_to?("#{model.model_name.singular}_params", true)
      send("#{model.model_name.singular}_params")
    end

    def model_instance_create
      model_instance.save
    end

    def model_instance_destroy
      model_instance.destroy
    end

    def message_successfully_created
      t("you_successfully_created", name: human_readable_now_model_name)
    end

    def message_successfully_updated
      t("you_successfully_updated", name: human_readable_now_model_name)
    end

    def message_successfully_destroyed
      t("you_successfully_destroyed", name: human_readable_now_model_name)
    end

    def relation_model_symbol
      nil
    end

    def call_relation_model
      nil
    end

    def set_relation_model_instance
      return if relation_model_symbol.nil?
      return unless model_instance.has_attribute?(relation_model_symbol) &&
                    model_instance.send(relation_model_symbol).nil?
      return if call_relation_model.nil?
      model_instance.send("#{relation_model_symbol}=", call_relation_model.id)
      set_relation_model_instance_id
    end

    def set_relation_model_instance_id
      request.path_info.split("/").reject(&:blank?)[1..-1].each_slice(2) do |resource, id|
        break unless id.match?(/\A\d+\z/)
        break unless model_instance.class.attribute_names.include?("#{resource.singularize}_id")
        model_instance.send("#{resource.singularize}_id=", id.to_i)
      end
    end

    def after_index; end

    def after_show; end

    def after_new; end

    def after_edit; end

    def set_model_instance
      instance = find_model_instance
      return if instance.nil?
      instance_variable_set(
        "@#{model.model_name.singular}".to_sym,
        instance
      )
    rescue StandardError => e
      Rails.logger.debug e
      raise e
    end

    def to_model_instance(resource = nil)
      instance_variable_set(
        "@#{model.model_name.singular}".to_sym,
        resource
      )
    end

    def to_model_instances(resources = nil)
      instance_variable_set(
        "@#{search_model.model_name.plural}".to_sym,
        resources
      )
    end

    def index_resources
      search_model
    end

    def resources_includes
      []
    end

    def resources_references
      []
    end

    def resources_wheres(resources = nil)
      return nil if resources.nil?
      resources
    end

    def resources_order(resources = nil)
      return nil if resources.nil?
      resources.order(id: :desc)
    end

    def resources_paginate(resources = nil)
      return nil if resources.nil?
      resources = resources.page(params[:page])
      return resources if resources_per_max.nil?
      resources.per(resources_per_max)
    end

    def resources_per_max
      nil
    end

    def paging?
      true
    end

    def action?(*key)
      key.include?(action_name.to_sym)
    end

    def format?(*key)
      key.include?(params[:format].blank? ? :html : params[:format].to_sym)
    end

    def find_model_instance
      model.find(params[:id])
    end

    def url_after_creating
      show_path
    end

    def after_succeeded_creating; end

    def after_failed_creating; end

    def url_after_updating
      show_path
    end

    def after_succeeded_updating; end

    def after_failed_updating; end

    def url_after_destroyed
      index_path
    end

    def index_path
      url_for(action: :index)
    end

    def edit_path
      if begin
            url_for(action: :edit, id: model_instance.id)
          rescue StandardError
            false
          end
        url_for(action: :edit, id: model_instance.id)
      elsif begin
               url_for(action: :show, id: model_instance.id)
             rescue StandardError
               false
             end
        url_for(action: :show, id: model_instance.id)
      else
        url_for(action: :index)
      end
    end

    def show_path
      if begin
            url_for(action: :show, id: model_instance.id)
          rescue StandardError
            false
          end
        url_for(action: :show, id: model_instance.id)
      elsif begin
               url_for(action: :edit, id: model_instance.id)
             rescue StandardError
               false
             end
        url_for(action: :edit, id: model_instance.id)
      else
        url_for(action: :index)
      end
    end

    def render_index(options = {})
      render :index, options
    end

    def render_new(options = {})
      render :new, options
    end

    def render_edit(options = {})
      render :edit, options
    end

    def render_show(options = {})
      render :show, options
    end

    def human_readable_now_model_name
      model.model_name.human
    end

    def model
      controller_name.camelize.singularize.constantize
    end

    def search_model
      model
    end

    def auth_check
      authorize model_instance
    end

    def set_search_params
      @search_params = params.permit!.to_h[:q] if params[:q].present?
    end

    def render_succeeded_creating_by_js(options)
      head options[:status]
    end

    def render_failed_creating_by_js(options)
      head options[:status]
    end

    def render_succeeded_updating_by_js(options)
      head options[:status]
    end

    def render_failed_updating_by_js(options)
      head options[:status]
    end

    def authorize(showing_record)
      # HINT: レコードの権限チェックを行う。
      # 違反しているならraiseを発生させるか、別のページへリダイレクトさせる
      # 権限チェックを行わない場合は何もしない
    end
  end
end
