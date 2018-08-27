require "rails_helper"

RSpec.describe SamplesController, type: :controller do
  render_views
  let!(:sample) do
    create(:sample)
  end
  let(:building_source_site) do
    build(:sample)
  end

  let(:model_class) { Sample }
  let(:valid_session) { {} }
  let(:target_resource) do
    sample
  end
  let(:target_resources) do
    Sample.ransack.result
  end
  let(:valid_attributes) do
    building_source_site.attributes.with_indifferent_access
  end
  let(:invalid_attributes) do
    valid_attributes.merge(
        name: ""
    )
  end

  describe "#index" do
    include Support::Controller::ScaffoldableResources::Index

    context "検索フォームが空の場合" do
      it "正しい結果が出力されるか？" do
        get :index, params: { q: {} }
        expect(assigns(:samples)).to include(target_resource)
      end
    end

    context "検索フォームに`name`のみ入力の場合" do
      it "正しい結果が出力されるか？" do
        get :index, params: { q: { name_cont: target_resource.name.slice(-1) } }
        expect(assigns(:samples)).to include(target_resource)
      end
    end

    context "検索フォームに検索ヒットしない`name`のみ入力の場合" do
      it "正しい結果が出力されるか？" do
        get :index, params: { q: { name_cont: "#{target_resource.name}aaa" } }
        expect(assigns(:samples)).to_not include(target_resource)
      end
    end
  end

  describe "#new,#create,#edit,#update,#destroy" do
    include Support::Controller::ScaffoldableResources::New
    include Support::Controller::ScaffoldableResources::Create
    include Support::Controller::ScaffoldableResources::Edit
    include Support::Controller::ScaffoldableResources::Update
    include Support::Controller::ScaffoldableResources::Destroy
  end
end
