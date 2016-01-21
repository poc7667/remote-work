class Api::V1::RecommendationsController < ApplicationController
  def index
    @recommendations = Recommender.get_recommendations(params["user_id"].to_i, params["strategy"])
    respond_to do |format|
      format.json
    end
  end
end
