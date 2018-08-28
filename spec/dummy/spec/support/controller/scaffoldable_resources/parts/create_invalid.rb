module Support
  module Controller
    module ScaffoldableResources
      module Parts
        module CreateInvalid
          extend ActiveSupport::Concern

          included do
            let(:params) { defined?(base_params) ? base_params : {} }
            let(:request_options) do
              {
                session: valid_session,
                format: defined?(request_format) ? request_format : :html
              }
            end

            context "with invalid params" do
              # DBへのinsertチェック
              include ::Support::Controller::ScaffoldableResources::Parts::CreateInvalidDb

              it "re-renders the 'new' template" do
                post :create,
                     params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": invalid_attributes),
                     session: valid_session,
                     format: defined?(request_format) ? request_format : :html
                template = defined?(template_failed_created) ? template_failed_created : :new
                expect(response).to render_template(template.to_s)
              end
            end
          end
        end
      end
    end
  end
end
