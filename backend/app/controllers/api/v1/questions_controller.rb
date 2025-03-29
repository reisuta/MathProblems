class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]

  def index
    if params[:topic_id]
      @questions = Question.joins(:question_template)
                          .where(question_templates: { math_topic_id: params[:topic_id] })
                          .order(created_at: :desc)
                          .limit(params[:limit] || 10)
    else
      @questions = Question.order(created_at: :desc).limit(params[:limit] || 10)
    end

    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def generate
    template = QuestionTemplate.find(params[:template_id])
    count = params[:count] || 1

    @questions = QuestionGeneratorService.generate_from_template(template, count.to_i)

    render json: @questions
  end

  def check_answer
    @question = Question.find(params[:id])
    user_answer = params[:answer]

    # 数学的に等価かどうかをチェック（単純な文字列比較ではなく）
    correct = MathEquationService.equivalent?(@question.answer, user_answer)

    @user_answer = current_user.user_answers.create!(
      question: @question,
      user_answer: user_answer,
      correct: correct
    )

    render json: {
      correct: correct,
      correct_answer: @question.answer,
      explanation: @question.explanation
    }
  end
end
