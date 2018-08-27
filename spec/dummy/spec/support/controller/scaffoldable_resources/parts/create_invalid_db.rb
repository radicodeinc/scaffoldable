module Support
  module Controller
    module ScaffoldableResources
      module Parts
        module CreateInvalidDb
          extend ActiveSupport::Concern

          included do
            let(:params) { defined?(base_params) ? base_params : {} }
            let(:request_options) do
              {
                session: valid_session,
                format: defined?(request_format) ? request_format : :html
              }
            end

            it "assigns a newly created but unsaved" do
              post :create,
                   params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": invalid_attributes),
                   session: valid_session,
                   format: defined?(request_format) ? request_format : :html
              expect(assigns(defined?(singular_name) ? singular_name : model_class.model_name.singular.to_sym)).to be_a_new(model_class)
            end
          end
        end
      end
    end
  end
end
