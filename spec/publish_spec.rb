# frozen_string_literal: true

RSpec.describe Wire::Publish::Publisher do
  let(:sample_dir) { File.expand_path("../items/2026/09/ribose-wire-format", __dir__) }
  let(:now) { Time.parse("2026-09-02T12:00:00+08:00") }

  def stage(root, status, published_at = nil)
    dir = File.join(root, "2026/09/story")
    FileUtils.mkdir_p(dir)
    item = Wire::Models::NewsItem.from_yaml(File.read(File.join(sample_dir, "item.yaml")))
    item.status = status
    item.embargo = nil
    if published_at
      item.timestamps.published = published_at
    end
    File.write(File.join(dir, "item.yaml"), item.to_yaml)
    FileUtils.cp(File.join(sample_dir, "body.adoc"), dir)
    FileUtils.cp_r(File.join(sample_dir, "media"), dir)
    Wire::ItemLoader.new(root: root).records
  end

  it "publishes a published item with all artifacts" do
    Dir.mktmpdir do |tmp|
      records = stage(tmp, "published", Time.parse("2026-09-01T09:00:00+08:00"))
      out = File.join(tmp, "publish")
      result = described_class.new(items_root: tmp, output_dir: out,
                                   base_url: "https://news.example", now: now).call(records)

      expect(result.published_ids).to eq(["urn:ribose:news:2026-09-02:ribose-wire-format"])
      index = JSON.parse(File.read(File.join(out, "news.json")))
      expect(index["articles"].first["path"]).to eq("articles/2026-09-02-ribose-wire-format/1/")
      full = JSON.parse(File.read(File.join(out, "index-full.json")))
      full_article = full["articles"].first
      expect(full_article["path"]).to eq("articles/2026-09-02-ribose-wire-format/1/")
      expect(full_article["bodyAdoc"]).not_to be_empty
      expect(full_article["headline"]).to be_a(String)
      expect(full_article["media"]).to all(include("id" => anything, "href" => anything))
      expect(File).to exist(File.join(out, "articles/2026-09-02-ribose-wire-format/1/body.adoc"))
      expect(File).to exist(File.join(out, "articles/2026-09-02-ribose-wire-format/1/media/hero.svg"))
      feed = JSON.parse(File.read(File.join(out, "feed.json")))
      expect(feed["items"].first["uri"]).to start_with("https://www.ribose.com")
      expect(File.read(File.join(out, "feed.xml"))).to include("<title>")
      newsml = Newsmlg2.parse(File.read(File.join(out, "newsml.xml")))
      expect(newsml.item).to be_a(Newsmlg2::NewsMessage)
      carried = newsml.item.item_set.items
      expect(carried.length).to eq(1)
      expect(carried.first.guid)
        .to eq("urn:ribose:news:2026-09-02:ribose-wire-format")
      expect(carried.first.content_meta.headlines.first.to_s)
        .to eq(Wire::Models::NewsItem.from_yaml(
          File.read(File.join(sample_dir, "item.yaml"))
        ).plain_headline)
    end
  end

  it "skips drafts and embargoed items deterministically" do
    Dir.mktmpdir do |tmp|
      records = stage(tmp, "scheduled")
      out = File.join(tmp, "publish")
      result = described_class.new(items_root: tmp, output_dir: out,
                                   base_url: "https://news.example", now: now).call(records)
      expect(result.published_ids).to be_empty
      expect(result.skipped).not_to be_empty
      index = JSON.parse(File.read(File.join(out, "news.json")))
      expect(index["articles"]).to be_empty
      full = JSON.parse(File.read(File.join(out, "index-full.json")))
      expect(full["articles"]).to be_empty
    end
  end
end
