FactoryBot.define do
  factory :sample do
    name do
      "サンプル(#{Sample.count + 1})"
    end
    memo do
      "メモ(#{Sample.count + 1})"
    end
  end
end
