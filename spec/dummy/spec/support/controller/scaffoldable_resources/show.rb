module Support
  module Controller
    module ScaffoldableResources
      module Show
        extend ActiveSupport::Concern

        included do
          describe "GET #show" do
            let!(:resource) do
              if defined?(target_resource)
                target_resource
              else
                if defined?(valid_attributes) && valid_attributes.present?
                  model_class.create valid_attributes
                else
                  model_class.try(:accessible_by).nil? ? model_class.first : model_class.accessible_by(@current_ability).first
                end
              end
            end

            it "assigns the requested" do
              params = defined?(base_params) ? base_params : { id: resource.to_param }
              get :show, params: params, session: valid_session
              expect(assigns(defined?(singular_name) ? singular_name : model_class.model_name.singular.to_sym)).to eq(resource)
            end
          end
        end
      end
    end
  end
end
