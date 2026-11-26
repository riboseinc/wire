# frozen_string_literal: true

RSpec.describe Wire::Models::NewsItem do
  subject(:item) { described_class.from_yaml(File.read(sample_path)) }

  let(:sample_path) { File.expand_path("../items/2026/09/ribose-wire-format/item.yaml", __dir__) }

  it "loads the sample envelope" do
    expect(item.id).to eq("urn:ribose:news:2026-09-02:ribose-wire-format")
    expect(item.version).to eq(1)
    expect(item.status).to eq("draft")
    expect(item.plain_headline).to include("interoperable news")
    expect(item.language).to eq("en")
    expect(item.origin.site).to eq("ribose-com")
    expect(item.distribution).to include("metanorma-org")
    expect(item.media.first.id).to eq("hero")
    expect(item.dateline.place).to eq("Hong Kong")
  end

  it "round-trips through serialization" do
    reloaded = described_class.from_yaml(item.to_yaml)
    expect(reloaded.id).to eq(item.id)
    expect(reloaded.version).to eq(item.version)
    expect(reloaded.plain_headline).to eq(item.plain_headline)
    expect(reloaded.origin.canonical).to eq(item.origin.canonical)
    expect(reloaded.media.map(&:id)).to eq(item.media.map(&:id))
    expect(reloaded.body.path).to eq(item.body.path)
  end

  it "knows its public lifecycle state" do
    item.status = "published"
    expect(item).to be_public
    item.status = "draft"
    expect(item).not_to be_public
  end
end
