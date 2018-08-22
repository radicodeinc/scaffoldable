module SingleRecording
  extend ActiveSupport::Concern

  # includeするだけでシングルトンパターンで扱える、
  # 一つしかレコードを持たないモデル化出来る
  included do
    before_destroy :valid_single_record_by_destroy
    before_save :valid_single_record_by_save

    class << self
      def instance
        row = first
        return row if row
        row = self.new(default_params)
        row.save!
        row
      end

      # レコードを作成する時のデフォルト値
      def default_params
        {}
      end
    end

    private

    def valid_single_record_by_destroy
      errors[:base] << I18n.t("errors.messages.can_not_destroy_single_record")
      false
    end

    def valid_single_record_by_save
      return true if self.class.first.nil?
      errors[:base] << I18n.t("errors.messages.can_not_insert_single_record")
      false
    end
  end
end
