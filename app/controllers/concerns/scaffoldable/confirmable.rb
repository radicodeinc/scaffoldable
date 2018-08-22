# frozen_string_literal: true

# HINT: 登録や更新へ確認画面の機能を付与出来ます。「戻る」ボタンも対応

module Scaffoldable
  module Confirmable
    def back?
      params[:back].present?
    end

    def model_instance_create
      model_instance.confirming = Confirmable::CONFIRMED_BACK_KEY if back?
      model_instance.save
    end

    def model_instance_update
      update_attributes = controller_params
      update_attributes[:confirming] = Confirmable::CONFIRMED_BACK_KEY if back?
      model_instance.update(update_attributes)
    end
  end
end
