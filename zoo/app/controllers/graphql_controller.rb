# frozen_string_literal: true

class GraphQLController < ApplicationController
  include GraphQL::Controller

  skip_before_action :verify_authenticity_token
end
