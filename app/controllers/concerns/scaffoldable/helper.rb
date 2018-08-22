module Scaffoldable
  module Helper
    def scaffold_model_instance_name
      controller_path.split("/").last.singularize
    end

    def scaffoldable_url_for(options = nil)
      options.delete(:id) if route_single_resource?
      url_for(options)
    end

    def resource_name
      request.path_info.split("/").select do |path|
        /^[^\d]+$/ =~ path &&
          %w[new edit].include?(path) == false
      end.last
    end

    # routes.rbで単数で呼ばれているか、複数で呼ばれているかの判定
    # 単複同型を想定していない
    def route_single_resource?
      resource_name == resource_name.singularize
    end

    def scaffoldable_form_for(*args, &block)
      if route_single_resource?
        url_hash = {}
        args[0][0...-1].select do |name|
          [String, Symbol].include?(name.class) == false
        end.each do |name|
          url_hash["#{name.class.name.underscore}_id".to_sym] = name.id
        end
        url_hash[:action] = scaffoldable_form_action
        args[0] = scaffoldable_resource_instance
        args[1][:url] = url_for(url_hash)
      end
      active_engine_design_table_form_for(*args, &block)
    end

    def scaffoldable_form_action
      scaffoldable_resource_instance.new_record? ? "create" : "update"
    end

    def scaffoldable_resource_instance
      instance_variable_get("@#{scaffold_model_instance_name}".to_sym)
    end

    def scaffoldable_form_url
      request.path_info.split("/").select do |path|
        /^[^\d]+$/ =~ path &&
          %w[new edit].include?(path) == false
      end.map do |name|
        ins =
          begin
            instance_variable_get("@#{name.singularize}".to_sym)
          rescue StandardError
            nil
          end
        if ins.nil?
          name.to_sym
        else
          ins
        end
      end
    end
  end
end
