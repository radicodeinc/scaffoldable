# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  # 除外するファイルを以下のように指定
  # add_filter 'app/controllers/users/unlocks_controller.rb'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'mock_redis'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UserController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # テスト実行時にlocalのredis等を使わないように設定
  config.before(:all) do
    # for Spring
    $REDIS.client.reconnect if $REDIS.present?
  end
  config.before(:each) do
    redis_instance = MockRedis.new
    allow(Redis).to receive(:new).and_return(redis_instance)
    $REDIS = Redis.new
  end

  # travel_to（timecop と同じ機能）を使用するため
  config.include ActiveSupport::Testing::TimeHelpers

  # rspec内で、ファイルアップロードのテストに使用する
  config.include ActionDispatch::TestProcess
  # FactoryBot内での呼び出し
  FactoryBot::SyntaxRunner.class_eval do
    include ActionDispatch::TestProcess
    def self.fixture_path
      Rails.root.join('spec', 'fixtures')
    end
  end
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerMacros, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view

  # fixtureのパス指定
  # ファイルアップロードテストする際のアップするファイルを指定するパスをfixtures以下から省略して指定
  config.fixture_path = ::Rails.root.join('spec', 'fixtures')

  config.before(:suite) do
    begin
      DatabaseRewinder.clean_all(multiple: false)
    rescue => e
      p 'テーブル(article?)が壊れいてる可能性があります。'
      p e
    end
  end

  config.after(:each) do
    DatabaseRewinder.clean(multiple: false)
  end

  config.infer_base_class_for_anonymous_controllers = true


  # bullet(N+1問題)でチェック
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    FactoryBot.reload
    DatabaseCleaner.start
    Bullet.start_request if Bullet.enable?
  end

  config.after(:each) do
    DatabaseCleaner.clean
    if Bullet.enable?
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end

  # Active Storageのテスト後、ファイル削除
  config.after(:each) do
    FileUtils.rm_rf("#{Rails.root}/tmp/storage")
  end

  config.include MailerMacros
end
