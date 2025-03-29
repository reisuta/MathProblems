# 数学トピックのサンプルデータ
math_topics = [
  { name: "二次関数", description: "二次関数の性質と応用", grade: 2, subject: "数学I" },
  { name: "三角関数", description: "三角関数の基本と応用", grade: 2, subject: "数学II" },
  { name: "微分法", description: "関数の微分と応用", grade: 3, subject: "数学II" },
  { name: "積分法", description: "関数の積分と応用", grade: 3, subject: "数学II" },
  { name: "数列", description: "数列の基本と和", grade: 2, subject: "数学B" },
  { name: "ベクトル", description: "ベクトルの基本と応用", grade: 3, subject: "数学B" }
]

created_topics = math_topics.map do |topic|
  MathTopic.find_or_create_by!(topic)
end

# 二次関数の問題テンプレート
quadratic_templates = [
  {
    title: "二次関数の頂点を求める",
    question_formula: "二次関数 f(x) = %{a}x^2 + %{b}x + %{c} の頂点の座標を求めよ。",
    solution_steps: "頂点のx座標は -b/(2a) = -(%{b})/(2*%{a}) = %{vertex_x}\n頂点のy座標は f(%{vertex_x}) = %{a}*(%{vertex_x})^2 + %{b}*(%{vertex_x}) + %{c} = %{vertex_y}\nよって、頂点の座標は (%{vertex_x}, %{vertex_y})",
    difficulty: 0
  },
  {
    title: "二次関数の軸と対称性",
    question_formula: "二次関数 f(x) = %{a}x^2 + %{b}x + %{c} について、(1) 軸の方程式を求めよ。(2) 点(%{test_x}, f(%{test_x}))に関して点対称な点の座標を求めよ。",
    solution_steps: "(1) 軸の方程式は x = -b/(2a) = -(%{b})/(2*%{a}) = %{vertex_x}\n(2) 点(%{test_x}, %{test_y})に関して点対称な点のx座標は 2*(%{vertex_x}) - %{test_x} = %{symmetric_x}\n点対称な点のy座標は f(%{symmetric_x}) = %{a}*(%{symmetric_x})^2 + %{b}*(%{symmetric_x}) + %{c} = %{symmetric_y}\nよって、点対称な点の座標は (%{symmetric_x}, %{symmetric_y})",
    difficulty: 1
  }
]

# トピックを取得
quadratic_topic = MathTopic.find_by(name: "二次関数")

# テンプレートを作成
quadratic_templates.each do |template_data|
  template = QuestionTemplate.find_or_create_by!(
    math_topic: quadratic_topic,
    title: template_data[:title],
    question_formula: template_data[:question_formula],
    solution_steps: template_data[:solution_steps],
    difficulty: template_data[:difficulty]
  )
  
  # パラメータセットを作成
  if template.title == "二次関数の頂点を求める"
    5.times do
      ParameterSet.create!(
        question_template: template,
        parameters: {
          "a" => { "min" => 1, "max" => 5, "integer" => true, "exclude" => [0] },
          "b" => { "min" => -10, "max" => 10, "integer" => true },
          "c" => { "min" => -5, "max" => 5, "integer" => true },
          "calculated_params" => {
            "vertex_x" => "(-params[:b].to_f / (2 * params[:a])).round(2)",
            "vertex_y" => "(params[:a] * (-params[:b].to_f / (2 * params[:a]))**2 + params[:b] * (-params[:b].to_f / (2 * params[:a])) + params[:c]).round(2)"
          }
        }
      )
    end
  elsif template.title == "二次関数の軸と対称性"
    5.times do
      ParameterSet.create!(
        question_template: template,
        parameters: {
          "a" => { "min" => 1, "max" => 3, "integer" => true, "exclude" => [0] },
          "b" => { "min" => -6, "max" => 6, "integer" => true },
          "c" => { "min" => -5, "max" => 5, "integer" => true },
          "test_x" => { "min" => -5, "max" => 5, "integer" => true },
          "calculated_params" => {
            "vertex_x" => "(-params[:b].to_f / (2 * params[:a])).round(2)",
            "test_y" => "(params[:a] * params[:test_x]**2 + params[:b] * params[:test_x] + params[:c]).round(2)",
            "symmetric_x" => "(2 * (-params[:b].to_f / (2 * params[:a])) - params[:test_x]).round(2)"
          }
        }
      )
    end
  end
end

# 問題を生成
QuestionTemplate.all.each do |template|
  QuestionGeneratorService.generate_from_template(template, 10)
end

puts "Seed data created successfully!"
