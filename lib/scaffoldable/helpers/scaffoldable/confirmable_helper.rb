# frozen_string_literal: true
module Scaffoldable
  module ConfirmableHelper
    def confirmable?(object = nil)
      object.present? && object.class.include?(Confirming)
    end

    def confirmation_page?(object = nil)
      params[:back].nil? &&
        object.present? && object.class.include?(Confirming) && object.confirming?
    end

    def confirmation_field(form)
      confirmable?(form.object) ? form.hidden_field(:confirming) : ""
    end

    def confirmation_back_submit(form, params = {})
      form.button :submit, params.merge(name: "back", value: "戻る", 'data-disable-with': "戻る")
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include Scaffoldable::ConfirmableHelper
end
