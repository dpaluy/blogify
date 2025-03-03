# frozen_string_literal: true

require "spec_helper"
require "action_controller"
require "rails"
require "active_record"
# Since this is a mounted engine, require the routes if needed
# require "blogify/engine"

RSpec.describe Blogify::PostsController, type: :controller do
  # Simulate the engine routes. This might vary depending on how your test setup is done.
  routes { Blogify::Engine.routes }

  let!(:post1) do
    Blogify::Post.create(
      title: "Test Post 1",
      content: "Content 1",
      published_at: Time.current
    )
  end
  let!(:post2) do
    Blogify::Post.create(
      title: "Test Post 2",
      content: "Content 2"
    )
  end

  describe "GET #index" do
    it "assigns @posts ordered by published_at desc" do
      get :index
      expect(assigns(:posts)).to eq([post1, post2])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("blogify/articles/index")
    end

    it "uses the configured blog layout" do
      get :index
      expect(response).to render_template(layout: Blogify::Engine.config.blog_layout)
    end
  end

  describe "GET #show" do
    context "with a valid post" do
      it "assigns @post" do
        get :show, params: { id: post1.id }
        expect(assigns(:post)).to eq(post1)
      end

      it "renders the show template" do
        get :show, params: { id: post1.id }
        expect(response).to render_template("blogify/articles/show")
      end

      it "uses the configured post layout" do
        get :show, params: { id: post1.id }
        expect(response).to render_template(layout: Blogify::Engine.config.post_layout)
      end
    end

    context "when the post does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect do
          get :show, params: { id: 9999 }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
