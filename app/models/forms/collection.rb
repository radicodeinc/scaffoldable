require "active_type"
module Forms
  class Collection < ActiveType::Object
    attribute :element_model
    nests_many :elements, reject_if: :all_blank
    validate :elements_validation

    class << self
      def generate(element_model, model_instances)
        Forms::Collection.new(
          element_model: element_model,
          elements: ActiveType.cast(
            model_instances,
            element_model
          )
        )
      end
    end

    def initialize(attributes = {})
      super attributes
    end

    def elements_attributes=(elements_attributes)
      self.elements = elements_attributes.map do |_key, element_attributes|
        element = element_model.find_or_initialize_by(id: element_attributes.with_indifferent_access[:id])
        element.attributes = element_attributes
        element
      end
    end

    def target_elements
      elements.select(&:selected)
    end

    def save
      return false unless valid?
      element_model.transaction { target_elements.each(&:save!) }
      true
    end

    private

    def elements_validation
      if target_elements.blank?
        errors.add(
          :elements,
          "一つ以上指定してください。"
        )
      end

      target_elements.each(&:valid?)

      target_elements.each do |record|
        record.errors.full_messages.each do |message|
          next if record.try(:same_error_message_once?) && errors.messages[:elements].include?(message)
          errors.add(:elements, "#{message}（id: #{record.id}）")
        end
      end
    end
  end
end
