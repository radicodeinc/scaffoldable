module Support
  module Controller
    module ScaffoldableResources
      module Parts
        module UpdateValidDb
          extend ActiveSupport::Concern

          included do
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

            let(:params) do
              defined?(base_params) ? base_params : { id: resource.to_param }
            end

            it "assigns the requested" do
              put :update, params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": valid_attributes), session: valid_session
              expect(assigns(defined?(singular_name) ? singular_name : model_class.model_name.singular.to_sym)).to eq(resource)
            end
          end
        end
      end
    end
  end
end
