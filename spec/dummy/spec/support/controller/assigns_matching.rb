module Support
  module Controller
    module AssignsMatching
      extend ActiveSupport::Concern

      included do
        it "assigns" do
          subject
          expect(assigns(assigns_name)).to match_array(resources)
        end
      end
    end
  end
end
