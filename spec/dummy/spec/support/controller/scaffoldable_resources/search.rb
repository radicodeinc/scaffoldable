module Support
  module Controller
    module ScaffoldableResources
      module Search
        extend ActiveSupport::Concern

        included do
          describe "GET #index for search" do
            it "assigns all" do
              resources = model_class.try(:accessible_by).nil? ? model_class.first : model_class.accessible_by(@current_ability).first
              params = defined?(base_params) ? base_params : {}
              get :index, params: params, session: valid_session
              expect(assigns(defined?(plural_name) ? plural_name : model_class.model_name.plural.to_sym)).to match_array(resources)
            end
          end
        end
      end
    end
  end
end
