class QuestionGeneratorService
  def self.generate_from_template(template, count = 1)
    questions = []
    
    count.times do
      # パラメータをランダム生成
      params = generate_parameters(template.parameter_sets.sample.parameters)
      
      # 問題文を生成
      question_text = format(template.question_formula, params)
      
      # 解答と解説を生成
      answer, explanation = generate_solution(template.solution_steps, params)
      
      # 問題オブジェクトを作成
      questions << Question.new(
        question_template: template,
        parameter_set_id: template.parameter_sets.sample.id,
        content: question_text,
        answer: answer,
        explanation: explanation
      )
    end
    
    Question.import questions
    questions
  end
  
  private
  
  def self.generate_parameters(parameter_ranges)
    params = {}
    
    parameter_ranges.each do |key, range|
      # 除外値を考慮したランダム値の生成
      exclude = range["exclude"] || []
      value = nil
      
      loop do
        if range["integer"]
          value = rand(range["min"]..range["max"])
        else
          value = rand(range["min"]..range["max"]) + rand
          value = value.round(2)
        end
        
        break unless exclude.include?(value)
      end
      
      params[key.to_sym] = value
    end
    
    # 計算された追加パラメータがあれば生成
    if parameter_ranges["calculated_params"]
      parameter_ranges["calculated_params"].each do |param, formula|
        params[param.to_sym] = eval(formula % params)
      end
    end
    
    params
  end
  
  def self.generate_solution(solution_template, params)
    # 解答に必要な計算を実行
    calculated_params = calculate_solution_params(params)
    
    # 計算結果をパラメータに追加
    all_params = params.merge(calculated_params)
    
    # 解答と解説を生成
    solution = format(solution_template, all_params)
    
    # 最終的な答えと詳細な解説を分離
    answer_lines = solution.split("\n")
    answer = answer_lines.last
    explanation = solution
    
    [answer, explanation]
  end
  
  def self.calculate_solution_params(params)
    calculated = {}
    
    # 例: 二次関数の頂点座標を計算
    if params[:a] && params[:b]
      vertex_x = -params[:b] / (2.0 * params[:a])
      vertex_x = vertex_x.round(2)
      calculated[:vertex_x] = vertex_x
      
      if params[:c]
        vertex_y = params[:a] * vertex_x**2 + params[:b] * vertex_x + params[:c]
        vertex_y = vertex_y.round(2)
        calculated[:vertex_y] = vertex_y
      end
    end
    
    calculated
  end
end
