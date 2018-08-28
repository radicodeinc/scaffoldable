module Support
  module Controller
    module ScaffoldableResources
      module Parts
        module CreateValidDb
          extend ActiveSupport::Concern

          included do
            let(:params) { defined?(base_params) ? base_params : {} }

            it "creates a new" do
              expect do
                post :create,
                     params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": valid_attributes),
                     session: valid_session,
                     format: defined?(request_format) ? request_format : :html
              end.to change(model_class, :count).by(1)
            end
          end
        end
      end
    end
  end
end
