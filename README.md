[![CircleCI](https://circleci.com/gh/radicodeinc/scaffoldable.svg?style=svg)](https://circleci.com/gh/radicodeinc/scaffoldable)

# Scaffoldable
RESTfulに様々な場面で使える機能を提供します。

## Usage

ドキュメントは後に記入します。
少々お待ち下さい。

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'scaffoldable'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install scaffoldable
```

## 使い方

### 基本的な使い方

```
# ※こちらをコピーして使うと慣れないうちは使いやすいです。

class SamplesController < ApplicationController
  # RESTfulなアクションを全て実装します。
  include Scaffoldable

  ### 主に使用するオーバーライド用のmethods:
  # - controller_params … リクエストされた時に受け取ったパラメータ
  # - model_instances … 取得したモデルインスタンスリストを取り出す
  # - model_instance … 現在選択中のモデルインスタンスを取り出す
  # - find_model_instance … 現在選択中のモデルインスタンスを取り出す

  ### #index について
  # 概要：
  # ransackを使って実装しています。

  ### #edit,#update,#show について
  # 概要：
  # 編集、閲覧するモデルインスタンスを取得しています。

  ### #indexのincludesを編集したい場合
  # 以下をオーバーライドする事で可能にします。
  # パス：controllers/**/*.rb
  def resources_includes
    %i[addresses profile]
  end

  ### #indexのreferencesを編集したい場合
  # 以下をオーバーライドする事で可能にします。
  # パス：controllers/**/*.rb
  def resources_references
    %i[addresses profile]
  end

  ### #indexのviewの定義方法
  # パス：views/**/*.html.slim
  # --- index.html.slim
  = search_form_for @search, url: url_for(action: :index) do |f|
    = f.label :name_cont, '名前'
    = f.search_field :name_cont
    = f.submit "検索"

  ### 各アクションで別々のモデルを使いたい場合
  # 以下をオーバーライドする事で可能にします。
  # パス：controllers/**/*.rb
  def model
    if action? :new, :create
      User::Register
    elsif action? :edit, :update
      User::Editor
    else
      # #show,#indexで使われる
      User
    end
  end

  ### 登録や編集時に確認画面を挟みたい場合
  # パス：controllers/**/*.rb
  include Scaffoldable::Confirmable

  # パス：models/**/*.rb
  class Model
    include Confirming
  end

  # パス：views/**/*.html.slim
  = simple_form_for([:users, @user_child]) do |f|
    - confirming = confirmation_page?(f.object)
    = confirmation_field(f)
    = confirming_field confirming, f, :last_name
    = confirming_field confirming, f, :first_name
    = confirming_field confirming, f, :last_name_kana
    = confirming_field confirming, f, :first_name_kana
    = confirming_field confirming, f, :birthed_on, as: :date
    = confirming_field confirming, f, :nickname
    - if confirming
      = confirmation_back_submit(f)
      = f.button :submit, "登録する"
    - else
      = f.button :submit, "確認する"

  ### #createのトランザクション処理を書き換えたい場合
  # 以下をオーバーライドする事で可能にします。
  # 成功時はtrue, 失敗時はfalseを返してください。
  # controllers/**/*.html.slim
  def model_instance_create
    model_instance.save
  end

  ### #updateのトランザクション処理を書き換えたい場合
  # 以下をオーバーライドする事で可能にします。
  # 成功時はtrue, 失敗時はfalseを返してください。
  def model_instance_update
    model_instance.update(controller_params)
  end


  ### RESTfulなアクション後、描画前に行いたい処理がある場合
  # 以下をオーバーライドする事で可能にします。
  def after_succeeded_updating; end
  def after_failed_updating; end
  def after_succeeded_creating; end
  def after_failed_creating; end
  def after_new; end
  def after_edit; end
  def after_show; end
  def after_index; end

  ### create,update,destroy後の通知メッセージの内容を変えたい場合
  # 以下をオーバーライドする事で可能にします。
  # ※通知メッセージ（文字列）をreturnします。
  def message_successfully_created; end
  def message_successfully_updated; end
  def message_successfully_destroyed; end

  ### create,update,destroy後のリダイレクト先を変えたい場合
  # 以下をオーバーライドする事で可能にします。
  # ※リダイレクト先のURLをreturnします。
  def url_after_creating; end
  def url_after_updating; end
  def url_after_destroyed; end

  ### --- Q & A

  # Q. edit,updateで使用するレコードが決まっている場合の対応方法は？
  # A. find_model_instanceをオーバーライドして使用するレコードをreturnする事で解決します。
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
