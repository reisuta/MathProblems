<template>
  <div class="home-container">
    <h1>高校数学問題集</h1>
    
    <div class="topics-container">
      <h2>単元一覧</h2>
      <div class="topics-grid">
        <NuxtLink 
          v-for="topic in topics" 
          :key="topic.id" 
          :to="`/topics/${topic.id}`"
          class="topic-card"
        >
          <h3>{{ topic.name }}</h3>
          <p>{{ topic.description }}</p>
          <div class="topic-info">
            <span>{{ topic.subject }}</span>
            <span>{{ gradeLabel(topic.grade) }}</span>
          </div>
        </NuxtLink>
      </div>
    </div>
    
    <div class="recent-questions">
      <h2>最近の問題</h2>
      <QuestionCard 
        v-for="question in recentQuestions" 
        :key="question.id" 
        :question="question"
        :hideAnswer="true"
      />
      <NuxtLink to="/questions" class="view-all-btn">すべての問題を見る</NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useApi } from '~/composables/useApi'

const topics = ref([])
const recentQuestions = ref([])

const gradeLabel = (grade: number) => {
  return `${grade}年生`
}

onMounted(async () => {
  const api = useApi()
  
  try {
    // トピック一覧を取得
    topics.value = await api.getTopics()
    
    // 最近の問題を取得
    recentQuestions.value = await api.getQuestions({ limit: 3 })
  } catch (error) {
    console.error('データの取得に失敗しました', error)
  }
})
</script>

<style scoped lang="scss">
.home-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  
  h1 {
    text-align: center;
    margin-bottom: 40px;
  }
  
  h2 {
    border-bottom: 2px solid #f0f0f0;
    padding-bottom: 10px;
    margin-bottom: 20px;
  }
  
  .topics-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
    margin-bottom: 40px;
    
    .topic-card {
      display: block;
      text-decoration: none;
      color: inherit;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      padding: 20px;
      transition: transform 0.2s, box-shadow 0.2s;
      
      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
      }
      
      h3 {
        margin-top: 0;
        margin-bottom: 10px;
        color: #1890ff;
      }
      
      p {
        margin-bottom: 15px;
        color: #666;
      }
      
      .topic-info {
        display: flex;
        justify-content: space-between;
        color: #999;
        font-size: 0.9rem;
      }
    }
  }
  
  .view-all-btn {
    display: block;
    text-align: center;
    margin-top: 20px;
    padding: 10px;
    background-color: #f5f5f5;
    color: #666;
    text-decoration: none;
    border-radius: 4px;
    
    &:hover {
      background-color: #e8e8e8;
    }
  }
}
</style>
