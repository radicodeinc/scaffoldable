module Support
  module Controller
    module ScaffoldableResources
      module Update
        extend ActiveSupport::Concern

        included do
          describe "PUT #update" do
            include ::Support::Controller::ScaffoldableResources::Parts::UpdateValid
            include ::Support::Controller::ScaffoldableResources::Parts::UpdateInvalid
          end
        end
      end
    end
  end
end
