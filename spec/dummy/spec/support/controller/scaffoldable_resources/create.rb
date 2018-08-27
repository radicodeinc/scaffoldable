module Support
  module Controller
    module ScaffoldableResources
      module Create
        extend ActiveSupport::Concern

        included do
          describe "POST #create" do
            include ::Support::Controller::ScaffoldableResources::Parts::CreateValid
            include ::Support::Controller::ScaffoldableResources::Parts::CreateInvalid
          end
        end
      end
    end
  end
end
