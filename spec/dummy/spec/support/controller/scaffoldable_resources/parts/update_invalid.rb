module Support
  module Controller
    module ScaffoldableResources
      module Parts
        module UpdateInvalid
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

            context "with invalid params" do
              # DBへのupdateチェック
              include ::Support::Controller::ScaffoldableResources::Parts::UpdateInvalidDb

              it "re-renders the 'edit' template" do
                put :update, params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": invalid_attributes), session: valid_session
                template = defined?(template_failed_updated) ? template_failed_updated : :edit
                expect(response).to render_template(template.to_s)
              end
            end
          end
        end
      end
    end
  end
end
