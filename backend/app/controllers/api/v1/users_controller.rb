class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_admin, only: [:index]

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def me
    render json: current_user
  end

  def stats
    # ユーザーの解答履歴から統計情報を生成
    @stats = {
      total_answers: current_user.user_answers.count,
      correct_answers: current_user.user_answers.where(correct: true).count,
      topic_stats: topic_statistics
    }

    render json: @stats
  end

  private

  def topic_statistics
    # トピックごとの正答率を計算
    stats = {}

    MathTopic.all.each do |topic|
      answers = current_user.user_answers.joins(question: { question_template: :math_topic })
                           .where(questions: { question_templates: { math_topic_id: topic.id } })

      if answers.any?
        stats[topic.id] = {
          name: topic.name,
          total: answers.count,
          correct: answers.where(correct: true).count,
          percentage: (answers.where(correct: true).count.to_f / answers.count * 100).round(1)
        }
      end
    end

    stats
  end
end
