# frozen_string_literal: true
require "ransack"
require "kaminari"
module Scaffoldable
  module Base
    extend ActiveSupport::Concern

    included do
      include ::Scaffoldable::Helper

      before_action :set_model_instance, only: %i[show edit update destroy].freeze
      before_action :auth_check, only: %i[show edit update destroy].freeze
      before_action :set_search_params, only: %i[index]
    end

    module ClassMethods
      def local_prefixes
        super + ["scaffoldable"]
      end
    end

    def index
      process_index
      after_index
      render_index
    end

    def show
      after_show
      render_show
    end

    def new
      process_new
      after_new
      render_new
    end

    def edit
      render_edit
    end

    def create
      process_create
    end

    def update
      process_update
    end

    def destroy
      process_destroy
    end

    def process_new
      new_model_instance
      # ユーザーIDを設定
      set_relation_model_instance
    end

    def ransack_search(search_model, ransack_params)
      @search = search_model.ransack
      return nil if ransack_params.blank?
      ransack_params = if search_model.try(:ransack_params, ransack_params)
                         search_model.ransack_params(ransack_params)
                       else
                         ransack_params
                       end
      ransack_params.try(:merge, ransack_base_params) if try(:ransack_base_params)
      @search = search_model.ransack(ransack_params)
      @search.result
    end

    def process_index
      resources = ransack_search(search_model, params[:q])
      resources = index_resources if resources.nil?
      resources = resources_wheres(resources)
      resources = resources_order(resources)
      resources = resources_paginate(resources) if paging?
      resources = resources.includes(*resources_includes) if resources_includes.present?
      resources = resources.references(*resources_references) if resources_references.present?
      to_model_instances(resources)
    end

    def process_create
      new_model_instance(controller_params)

      # ユーザーIDを設定
      set_relation_model_instance

      if model_instance_create
        after_succeeded_creating
        render_succeeded_creating
      else
        after_failed_creating
        render_failed_creating
      end
    end

    def model_instance_create
      model_instance.save
    end

    def model_instance_update
      model_instance.update(controller_params)
    end

    def render_succeeded_creating
      respond_to do |format|
        format.html do
          redirect_to(
            url_after_creating,
            notice: message_successfully_created
          )
        end
        format.json { render_show status: :created, location: model_instance }
        format.js { render_show status: :created, location: model_instance }
      end
    end

    def render_failed_creating
      respond_to do |format|
        format.html { render_new }
        format.json { render json: model_instance.errors, status: :unprocessable_entity }
        format.js { render json: model_instance.errors, status: :unprocessable_entity }
      end
    end

    def process_update
      if model_instance_update
        after_succeeded_updating
        render_succeeded_updating
      else
        after_failed_updating
        render_failed_updating
      end
    end

    def render_succeeded_updating
      respond_to do |format|
        format.html do
          redirect_to(
            url_after_updating,
            notice: message_successfully_updated
          )
        end
        format.json { render_show status: :ok, location: model_instance }
        format.js { render_show status: :ok, location: model_instance }
      end
    end

    def render_failed_updating
      respond_to do |format|
        format.html { render_edit }
        format.json { render json: model_instance.errors, status: :unprocessable_entity }
        format.js { render json: model_instance.errors, status: :unprocessable_entity }
      end
    end

    def process_destroy
      notice = message_successfully_destroyed
      model_instance_destroy
      respond_to do |format|
        format.html do
          redirect_to(
            url_after_destroyed,
            notice: notice
          )
        end
        format.json { head :no_content }
        format.js { head :no_content }
      end
    end

    include ::Scaffoldable::PrivateMethods
  end
end
