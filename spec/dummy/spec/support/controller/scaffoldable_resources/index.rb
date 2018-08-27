module Support
  module Controller
    module ScaffoldableResources
      module Index
        extend ActiveSupport::Concern

        included do
          describe "GET #index" do
            let!(:resources) do
              if defined?(target_resources)
                target_resources
              else
                if defined?(valid_attributes) && valid_attributes.present?
                  resource = model_class.create valid_attributes
                  model_class.where(id: resource.id)
                else
                  model_class.try(:accessible_by).nil? ? model_class.first : model_class.accessible_by(@current_ability).first
                end
              end
            end

            it "assigns all" do
              params = defined?(base_params) ? base_params : {}
              get :index, params: params, session: valid_session
              expect(assigns(defined?(plural_name) ? plural_name : model_class.model_name.plural.to_sym)).to match_array(resources)
            end
          end
        end
      end
    end
  end
end
