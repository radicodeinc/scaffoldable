module Support
  module Controller
    module ScaffoldableResources
      module Destroy
        extend ActiveSupport::Concern

        included do
          describe "DELETE #destroy" do
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

            it "destroys the requested" do
              expect do
                delete :destroy, params: params, session: valid_session
              end.to change(model_class, :count).by(-1)
            end

            it "redirects to the list" do
              delete :destroy, params: params, session: valid_session
              expect(response).to redirect_to(controller.url_for(action: :index))
            end
          end
        end
      end
    end
  end
end
