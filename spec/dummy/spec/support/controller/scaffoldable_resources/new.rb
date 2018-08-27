module Support
  module Controller
    module ScaffoldableResources
      module New
        extend ActiveSupport::Concern

        included do
          describe "GET #new" do
            it "assigns the requested" do
              params = defined?(base_params) ? base_params : {}
              get :new, params: params, session: valid_session
              expect(assigns(defined?(singular_name) ? singular_name : model_class.model_name.singular.to_sym)).to_not be_nil
            end
          end
        end
      end
    end
  end
end
