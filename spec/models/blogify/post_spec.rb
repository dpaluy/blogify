# frozen_string_literal: true

require "spec_helper"

RSpec.describe Blogify::Post do
  describe "scopes" do
    let!(:draft_post) { described_class.create(title: "Draft Post", content: "Draft Content") }
    let!(:published_post) do
      described_class.create(
        title: "Published Post",
        content: "Published Content",
        published_at: Time.current
      )
    end

    describe ".published" do
      it "returns posts with a published_at value" do
        expect(described_class.published).to include(published_post)
        expect(described_class.published).not_to include(draft_post)
      end
    end

    describe ".draft" do
      it "returns posts without a published_at value" do
        expect(described_class.draft).to include(draft_post)
        expect(described_class.draft).not_to include(published_post)
      end
    end

    describe ".ordered" do
      it "orders posts by published_at descending" do
        newer_post = described_class.create(
          title: "Newer Post",
          content: "Content",
          published_at: 1.day.from_now
        )
        ordered_posts = described_class.ordered
        expect(ordered_posts.first).to eq(newer_post)
      end
    end
  end

  describe "basic creation" do
    it "creates a valid post with default attributes" do
      post = described_class.create(title: "My Title", content: "Some content")
      expect(post).to be_persisted
    end
  end
end
