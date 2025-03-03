# frozen_string_literal: true

require "spec_helper"

RSpec.describe Blogify::FeaturedImageHelper, type: :helper do
  let(:post) { Blogify::Post.new(title: "Test Post") }

  describe "#featured_image_url" do
    context "when no featured image is attached" do
      it "returns the default URL" do
        default_url = "https://example.com/default.jpg"
        expect(helper.featured_image_url(post, :medium, default_url)).to eq(default_url)
      end

      it "returns nil when no default URL is provided" do
        expect(helper.featured_image_url(post)).to be_nil
      end
    end
  end

  describe "#featured_image_tag" do
    context "when no featured image is attached" do
      it "returns nil when no default URL is provided" do
        expect(helper.featured_image_tag(post)).to be_nil
      end

      it "returns an image tag with the default URL when provided" do
        default_url = "https://example.com/default.jpg"
        # The helper automatically adds alt text from the post title
        expect(helper).to receive(:image_tag).with(default_url, { alt: "Test Post" })
        helper.featured_image_tag(post, :medium, {}, default_url)
      end

      it "respects custom options when provided" do
        default_url = "https://example.com/default.jpg"
        custom_options = { alt: "Custom Alt", class: "featured-image" }
        expect(helper).to receive(:image_tag).with(default_url, custom_options)
        helper.featured_image_tag(post, :medium, custom_options, default_url)
      end
    end
  end
end
