module Support
  module Controller
    module ScaffoldableResources
      module Parts
        module CreateValid
          extend ActiveSupport::Concern

          included do
            let(:params) { defined?(base_params) ? base_params : {} }
            let(:request_options) do
              {
                session: valid_session,
                format: defined?(request_format) ? request_format : :html
              }
            end

            context "with valid params" do
              # DBへのinsertチェック
              include ::Support::Controller::ScaffoldableResources::Parts::CreateValidDb

              it "assigns a newly created" do
                post :create,
                     params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": valid_attributes),
                     session: valid_session,
                     format: defined?(request_format) ? request_format : :html
                expect(assigns(defined?(singular_name) ? singular_name : model_class.model_name.singular.to_sym)).to be_a(model_class)
                expect(assigns(defined?(singular_name) ? singular_name : model_class.model_name.singular.to_sym)).to be_persisted
              end

              it "check created" do
                post :create,
                     params: params.merge("#{defined?(singular_name) ? singular_name : model_class.model_name.singular}": valid_attributes),
                     session: valid_session,
                     format: defined?(request_format) ? request_format : :html
                resource = model_class.last
                if defined?(template_succeed_created)
                  expect(response).to render_template(template_succeed_created.to_s)
                else
                  redirect_url = defined?(created_redirect_url) ? created_redirect_url : nil
                  if redirect_url.nil?
                    redirect_url = defined?(created_redirect_url_method) ? send(created_redirect_url_method, id: resource.id) : controller.url_for(action: :show, id: resource.id)
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
end
