class QuestionGeneratorService
  def self.generate_from_template(template, count = 1)
    questions = []
    
    count.times do
      # パラメータをランダム生成
      params = generate_parameters(template.parameter_sets.sample.parameters)
      
      # 問題文を生成
      question_text = format(template.question_formula, params)
      
      # 解答と解説を生成
      begin
        answer, explanation = generate_solution(template.solution_steps, params)
        
        # 問題オブジェクトを作成
        questions << Question.new(
          question_template: template,
          parameter_set_id: template.parameter_sets.sample.id,
          content: question_text,
          answer: answer,
          explanation: explanation
        )
      rescue KeyError => e
        Rails.logger.error("テンプレート #{template.id} のパラメータエラー: #{e.message}")
        # エラーが発生した場合はその問題をスキップ
        next
      end
    end
    
    # 一度のトランザクションでまとめて保存
    Question.transaction do
      questions.each(&:save!)
    end
    
    questions
  end
  
  private
  def self.generate_parameters(parameter_ranges)
    params = {}
    
    parameter_ranges.each do |key, range|
      # 除外値を考慮したランダム値の生成
      exclude = range["exclude"] || []
      value = nil
      
      # 範囲のバリデーションを追加
      min = range["min"].to_f
      max = range["max"].to_f
      
      # 最小値が最大値より大きい場合は入れ替える
      if min > max
        min, max = max, min
      end
      
      loop do
        if range["integer"]
          value = rand(min.to_i..max.to_i)
        else
          value = min + rand * (max - min)
          value = value.round(2)
        end
        
        break unless exclude.include?(value)
      end
      
      params[key.to_sym] = value
    end
    
    # 計算された追加パラメータがあれば生成
    if parameter_ranges["calculated_params"]
      parameter_ranges["calculated_params"].each do |param, formula|
        begin
          params[param.to_sym] = eval(formula % params)
        rescue => e
          Rails.logger.error("Error calculating parameter #{param}: #{e.message}")
          params[param.to_sym] = 0 # デフォルト値を設定
        end
      end
    end
    
    params
  end
  
  def self.generate_solution(solution_template, params)
    # 解答に必要な計算を実行
    calculated_params = calculate_solution_params(params)
    
    # 計算結果をパラメータに追加
    all_params = params.merge(calculated_params)
    
    # formatを呼び出す前にテンプレートに必要な全てのキーが存在するか確認
    missing_keys = extract_format_keys(solution_template) - all_params.keys
    if missing_keys.any?
      missing_keys.each do |key|
        all_params[key] = 0 # 不足しているキーにデフォルト値を設定
      end
    end
    
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
        
        # symmetric_xがあるかチェックし、対応するsymmetric_yを計算
        if params[:symmetric_x] || calculated[:symmetric_x]
          symmetric_x = params[:symmetric_x] || calculated[:symmetric_x]
          symmetric_y = params[:a] * symmetric_x**2 + params[:b] * symmetric_x + params[:c]
          calculated[:symmetric_y] = symmetric_y.round(2)
        end
        
        # test_xがあるかチェックし、対応するtest_yを計算
        if params[:test_x]
          test_y = params[:a] * params[:test_x]**2 + params[:b] * params[:test_x] + params[:c]
          calculated[:test_y] = test_y.round(2)
          
          # 対称点の計算
          if calculated[:vertex_x]
            symmetric_x = 2 * vertex_x - params[:test_x]
            calculated[:symmetric_x] = symmetric_x.round(2)
            
            symmetric_y = params[:a] * symmetric_x**2 + params[:b] * symmetric_x + params[:c]
            calculated[:symmetric_y] = symmetric_y.round(2)
          end
        end
      end
    end
    
    calculated
  end
  
  # フォーマット文字列からキーを抽出するヘルパーメソッド
  def self.extract_format_keys(format_string)
    format_string.scan(/%{([^}]+)}/).flatten.map(&:to_sym)
  end
end
