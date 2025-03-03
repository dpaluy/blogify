# frozen_string_literal: true

require "spec_helper"

RSpec.describe Blogify::PostsController, type: :request do
  let!(:published_post) do
    Blogify::Post.create(
      title: "Test Post 1",
      content: "Content 1",
      published_at: Time.current,
      slug: "test-post-1"
    )
  end

  let!(:draft_post) do
    Blogify::Post.create(
      title: "Test Post 2",
      content: "Content 2"
    )
  end

  describe "GET /blog/posts" do
    it "returns a successful response" do
      get "/blog/posts"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /blog/posts/:id" do
    context "with a valid published post" do
      it "returns a successful response when accessed by slug" do
        get "/blog/posts/#{published_post.slug}"
        expect(response).to have_http_status(:success)
      end

      it "redirects to the slug URL when accessed by ID" do
        get "/blog/posts/#{published_post.id}"
        expect(response).to redirect_to("/blog/posts/#{published_post.slug}")
        expect(response).to have_http_status(:moved_permanently)
      end
    end

    context "with a draft post" do
      it "returns not found" do
        get "/blog/posts/#{draft_post.id}"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the post does not exist" do
      it "returns not found" do
        get "/blog/posts/non-existent-slug"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
