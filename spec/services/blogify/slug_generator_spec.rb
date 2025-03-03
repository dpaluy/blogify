# frozen_string_literal: true

require "spec_helper"

RSpec.describe Blogify::SlugGenerator do
  let(:published_at) { Time.new(2023, 4, 15, 12, 0, 0) }
  let(:post) do
    Blogify::Post.new(
      title: "Test Post Title",
      published_at: published_at
    )
  end

  describe "#generate" do
    context "with default format" do
      before do
        allow(Blogify::Engine.config).to receive(:slug_format).and_return(:default)
      end

      it "returns a parameterized version of the title" do
        generator = described_class.new(post)
        expect(generator.generate).to eq("test-post-title")
      end
    end

    context "with date_prefix format" do
      before do
        allow(Blogify::Engine.config).to receive(:slug_format).and_return(:date_prefix)
      end

      it "returns a slug with date prefix" do
        generator = described_class.new(post)
        expect(generator.generate).to eq("2023-04-15-test-post-title")
      end
    end

    context "with date_month_prefix format" do
      before do
        allow(Blogify::Engine.config).to receive(:slug_format).and_return(:date_month_prefix)
      end

      it "returns a slug with year-month prefix" do
        generator = described_class.new(post)
        expect(generator.generate).to eq("2023-04-test-post-title")
      end
    end

    context "with nil published_at" do
      let(:post) do
        Blogify::Post.new(
          title: "Test Post Title",
          published_at: nil
        )
      end

      before do
        allow(Blogify::Engine.config).to receive(:slug_format).and_return(:date_prefix)
        allow(Time).to receive(:current).and_return(published_at)
      end

      it "uses current time for date formatting" do
        generator = described_class.new(post)
        expect(generator.generate).to eq("2023-04-15-test-post-title")
      end
    end

    context "with special characters in title" do
      let(:post) do
        Blogify::Post.new(
          title: "Test: Post & Title!",
          published_at: published_at
        )
      end

      before do
        allow(Blogify::Engine.config).to receive(:slug_format).and_return(:default)
      end

      it "properly parameterizes the title" do
        generator = described_class.new(post)
        expect(generator.generate).to eq("test-post-title")
      end
    end
  end
end
