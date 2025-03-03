# frozen_string_literal: true

require "spec_helper"

RSpec.describe Blogify::Post do
  describe "validations" do
    it "requires a title" do
      post = described_class.new(content: "Some content")
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it "validates uniqueness of slug" do
      described_class.create(title: "First Post", slug: "unique-slug")
      post = described_class.new(title: "Second Post", slug: "unique-slug")
      expect(post).not_to be_valid
      expect(post.errors[:slug]).to include("has already been taken")
    end
  end

  describe "callbacks" do
    it "generates a slug from title before validation" do
      post = described_class.create(title: "My Awesome Title")
      expect(post.slug).to eq("my-awesome-title")
    end

    it "does not overwrite existing slug" do
      post = described_class.create(title: "My Title", slug: "custom-slug")
      expect(post.slug).to eq("custom-slug")
    end

    it "sets meta_title from title if not provided" do
      post = described_class.create(title: "My Title")
      expect(post.meta_title).to eq("My Title | Blogify")
    end

    it "does not overwrite existing meta_title" do
      post = described_class.create(title: "My Title", meta_title: "Custom Meta Title")
      expect(post.meta_title).to eq("Custom Meta Title")
    end
  end

  describe "scopes" do
    let!(:draft_post) { described_class.create!(title: "Draft Post", content: "Draft Content") }
    let!(:published_post) do
      described_class.create!(
        title: "Published Post #{Time.current.to_i}",
        content: "Published Content",
        published_at: Time.current
      )
    end

    describe ".published" do
      it "returns posts with a published_at value" do
        posts = described_class.published
        expect(posts).to include(published_post)
        expect(posts).not_to include(draft_post)
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

  describe "instance methods" do
    let(:post) { described_class.create(title: "Test Post", content: "Content") }

    describe "#publish!" do
      it "sets published_at" do
        expect { post.publish! }.to change { post.published_at }.from(nil).to(be_present)
      end
    end

    describe "#unpublish!" do
      it "clears published_at" do
        post.publish!
        expect { post.unpublish! }.to change { post.published_at }.from(be_present).to(nil)
      end
    end

    describe "#published?" do
      it "returns true when published_at is present" do
        post.publish!
        expect(post).to be_published
      end

      it "returns false when published_at is nil" do
        expect(post).not_to be_published
      end
    end

    describe "#to_param" do
      it "returns slug when present" do
        post.slug = "test-slug"
        expect(post.to_param).to eq("test-slug")
      end

      it "returns id as string when slug is blank" do
        post.slug = nil
        expect(post.to_param).to eq(post.id.to_s)
      end
    end
  end

  describe "basic creation" do
    it "creates a valid post with default attributes" do
      post = described_class.create(title: "My Title", content: "Some content")
      expect(post).to be_persisted
      expect(post.published_at).to be_nil
    end
  end
end
