# frozen_string_literal: true

module Blogify
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
