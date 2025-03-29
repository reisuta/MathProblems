<template>
  <div class="question-card">
    <div class="question-header">
      <h3>問題 #{{ question.id }}</h3>
      <span class="difficulty-badge" :class="difficultyClass">
        {{ difficultyLabel }}
      </span>
    </div>
    
    <div class="question-content">
      <MathEquation :equation="question.content" />
    </div>
    
    <div class="answer-section" v-if="!hideAnswer">
      <div class="input-group">
        <label for="answer">解答:</label>
        <input 
          id="answer" 
          v-model="userAnswer" 
          type="text" 
          :disabled="submitted"
          @keyup.enter="submitAnswer"
        />
        <button 
          class="submit-btn" 
          @click="submitAnswer" 
          :disabled="submitted || !userAnswer"
        >
          回答する
        </button>
      </div>
      
      <div class="result" v-if="submitted">
        <div :class="['result-badge', correct ? 'correct' : 'incorrect']">
          {{ correct ? '正解！' : '不正解' }}
        </div>
        
        <div class="correct-answer" v-if="!correct">
          <p>正解: <MathEquation :equation="result.correct_answer" /></p>
        </div>
        
        <div class="explanation">
          <h4>解説:</h4>
          <MathEquation :equation="result.explanation" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useApi } from '~/composables/useApi'

const props = defineProps<{
  question: any;
  hideAnswer?: boolean;
}>()

const userAnswer = ref('')
const submitted = ref(false)
const result = ref<any>({})
const correct = ref(false)

const difficultyClass = computed(() => {
  const difficulty = props.question.question_template?.difficulty || 0
  return {
    'beginner': difficulty === 0,
    'intermediate': difficulty === 1,
    'advanced': difficulty === 2
  }
})

const difficultyLabel = computed(() => {
  const difficulty = props.question.question_template?.difficulty || 0
  switch (difficulty) {
    case 0: return '初級'
    case 1: return '中級'
    case 2: return '上級'
    default: return '不明'
  }
})

const submitAnswer = async () => {
  if (!userAnswer.value || submitted.value) return
  
  try {
    const api = useApi()
    result.value = await api.checkAnswer(props.question.id, userAnswer.value)
    correct.value = result.value.correct
    submitted.value = true
  } catch (error) {
    console.error('回答の送信に失敗しました', error)
  }
}
</script>

<style scoped lang="scss">
.question-card {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  margin-bottom: 20px;
  
  .question-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    
    h3 {
      margin: 0;
      font-size: 1.2rem;
    }
    
    .difficulty-badge {
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 0.8rem;
      
      &.beginner {
        background-color: #e6f7ff;
        color: #0066cc;
      }
      
      &.intermediate {
        background-color: #fff7e6;
        color: #d46b08;
      }
      
      &.advanced {
        background-color: #fff1f0;
        color: #cf1322;
      }
    }
  }
  
  .question-content {
    font-size: 1.1rem;
    line-height: 1.6;
    margin-bottom: 20px;
  }
  
  .answer-section {
    .input-group {
      display: flex;
      gap: 10px;
      align-items: center;
      margin-bottom: 15px;
      
      label {
        font-weight: bold;
        width: 60px;
      }
      
      input {
        flex: 1;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 1rem;
      }
      
      .submit-btn {
        padding: 8px 16px;
        background-color: #1890ff;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        
        &:disabled {
          background-color: #ccc;
          cursor: not-allowed;
        }
      }
    }
    
    .result {
      margin-top: 20px;
      padding-top: 15px;
      border-top: 1px solid #eee;
      
      .result-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 4px;
        font-weight: bold;
        margin-bottom: 15px;
        
        &.correct {
          background-color: #f6ffed;
          color: #52c41a;
        }
        
        &.incorrect {
          background-color: #fff1f0;
          color: #f5222d;
        }
      }
      
      .correct-answer {
        margin-bottom: 15px;
      }
      
      .explanation {
        background-color: #f5f5f5;
        padding: 15px;
        border-radius: 4px;
        
        h4 {
          margin-top: 0;
          margin-bottom: 10px;
        }
      }
    }
  }
}
</style>
