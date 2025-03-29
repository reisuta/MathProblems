class Api::V1::MathTopicsController < ApplicationController
  def index
    @topics = MathTopic.all
    render json: @topics
  end

  def show
    @topic = MathTopic.find(params[:id])
    render json: @topic, include: :question_templates
  end
end
