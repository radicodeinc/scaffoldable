module Support
  module Controller
    module ScaffoldableResources
      module Parts
        module UpdateValid
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

            context "with valid params" do
              it "updates the requested" do
                skip("Add a hash of attributes valid for your model") unless defined?(new_attributes)
                put :update, params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": update), session: valid_session
                resource.reload
                skip("Add assertions for updated state") unless defined?(updated_check(resource))
              end

              # DBへのupdateチェック
              include ::Support::Controller::ScaffoldableResources::Parts::UpdateValidDb

              it "redirects to" do
                put :update, params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": valid_attributes), session: valid_session
                redirect_url = defined?(updated_redirect_url) ? updated_redirect_url : nil
                if redirect_url.nil?
                  redirect_url = defined?(updated_redirect_url_method) ? send(updated_redirect_url_method, id: resource.id) : controller.url_for(action: :show, id: resource.id)
                end
                expect(response).to redirect_to(redirect_url)
              end
            end
          end
        end
      end
    end
  end
end
