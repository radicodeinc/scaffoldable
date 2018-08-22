
# HINT: RESTfulな設定画面の機能を付与出来ます。
# 機能の組み合わせ可能一覧
# - Scaffoldable::Confirming

module Scaffoldable
  module SingleRecordable
    # HINT: routes.rbは「resource :レコード名, only: %i[show update]」と入力しましょう。
    # HINT: モデルには「models/concerns/single_support.rb」をincludeして下さい。

    def render_show(options = {})
      render :show, options
    end

    def render_new(options = {})
      render :show, options
    end

    def render_edit(options = {})
      render :show, options
    end

    def show_path
      url_for(action: :show)
    end

    def find_model_instance
      model.first
    end
  end
end
