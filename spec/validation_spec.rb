# frozen_string_literal: true

RSpec.describe Wire::Validation::Runner do
  subject(:runner) { described_class.build }

  let(:sample_dir) { File.expand_path("../items/2026/09/ribose-wire-format", __dir__) }
  let(:sample_yaml) { File.read(File.join(sample_dir, "item.yaml")) }

  def stage(root, item)
    dir = File.join(root, "2026/09/story")
    FileUtils.mkdir_p(dir)
    File.write(File.join(dir, "item.yaml"), item.to_yaml)
    FileUtils.cp(File.join(sample_dir, "body.adoc"), dir)
    FileUtils.cp_r(File.join(sample_dir, "media"), dir)
    Wire::ItemLoader.new(root: root).records
  end

  def prepared
    Wire::Models::NewsItem.from_yaml(sample_yaml)
  end

  it "accepts the shipped sample as-is" do
    records = Wire::ItemLoader.new(root: File.expand_path("../items", __dir__)).records
    expect(runner.run(records)).to be_empty
  end

  it "flags unknown vocabulary values" do
    item = prepared
    item.status = "weird"
    Dir.mktmpdir do |tmp|
      checks = runner.run(stage(tmp, item)).map(&:check)
      expect(checks).to include("vocabulary")
    end
  end

  it "flags missing alt text on content media" do
    item = prepared
    item.media.first.altText = nil
    Dir.mktmpdir do |tmp|
      messages = runner.run(stage(tmp, item)).map(&:message)
      expect(messages.join("\n")).to include("altText")
    end
  end

  it "flags unknown origin site" do
    item = prepared
    item.origin.site = "not-a-site"
    Dir.mktmpdir do |tmp|
      messages = runner.run(stage(tmp, item)).map(&:message)
      expect(messages.join("\n")).to include("not in sites registry")
    end
  end

  it "flags corrected items without supersedes" do
    item = prepared
    item.status = "corrected"
    item.timestamps.published = Time.parse("2026-09-01T09:00:00+08:00")
    Dir.mktmpdir do |tmp|
      messages = runner.run(stage(tmp, item)).map(&:message)
      expect(messages.join("\n")).to include("supersedes")
    end
  end
end
