<template>
  <div class="topic-container" v-if="topic">
    <div class="topic-header">
      <h1>{{ topic.name }}</h1>
      <p>{{ topic.description }}</p>
      <div class="topic-meta">
        <span>{{ topic.subject }}</span>
        <span>{{ gradeLabel(topic.grade) }}</span>
      </div>
    </div>
    
    <div class="template-section">
      <h2>問題テンプレート</h2>
      <div class="templates-grid">
        <div 
          v-for="template in templates" 
          :key="template.id"
          class="template-card"
        >
          <div class="template-header">
            <h3>{{ template.title }}</h3>
            <span class="difficulty-badge" :class="difficultyClass(template.difficulty)">
              {{ difficultyLabel(template.difficulty) }}
            </span>
          </div>
          
          <div class="template-actions">
            <button 
              class="generate-btn" 
              @click="generateQuestion(template.id)"
              :disabled="generating"
            >
              問題を生成
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <div class="questions-section">
      <h2>問題一覧</h2>
      
      <div v-if="loading" class="loading">
        読み込み中...
      </div>
      
      <div v-else-if="questions.length === 0" class="no-questions">
        問題がまだありません。上記のテンプレートから問題を生成してみましょう。
      </div>
      
      <template v-else>
        <QuestionCard 
          v-for="question in questions" 
          :key="question.id" 
          :question="question"
        />
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useApi } from '~/composables/useApi'
import { useQuestionsStore } from '~/stores/questions'

const route = useRoute()
const topicId = computed(() => Number(route.params.id))

const topic = ref<any>(null)
const templates = ref([])
const generating = ref(false)
const loading = ref(true)

const questionsStore = useQuestionsStore()
const questions = computed(() => questionsStore.questions)

const gradeLabel = (grade: number) => {
  return `${grade}年生`
}

const difficultyClass = (difficulty: number) => {
  switch (difficulty) {
    case 0: return 'beginner'
    case 1: return 'intermediate'
    case 2: return 'advanced'
    default: return ''
  }
}

const difficultyLabel = (difficulty: number) => {
  switch (difficulty) {
    case 0: return '初級'
    case 1: return '中級'
    case 2: return '上級'
    default: return '不明'
  }
}

const generateQuestion = async (templateId: number) => {
  generating.value = true
  
  try {
    await questionsStore.generateQuestions(templateId, 1)
  } finally {
    generating.value = false
  }
}

onMounted(async () => {
  loading.value = true
  
  try {
    const api = useApi()
    topic.value = await api.getTopic(topicId.value)
    templates.value = topic.value.question_templates || []
    
    await questionsStore.fetchQuestions({ topic_id: topicId.value })
  } catch (error) {
    console.error('データの取得に失敗しました', error)
  } finally {
    loading.value = false
  }
})
</script>
