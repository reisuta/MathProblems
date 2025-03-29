import { defineStore } from 'pinia'
import { useApi } from '~/composables/useApi'

interface Question {
  id: number;
  content: string;
  answer: string;
  explanation: string;
  question_template_id: number;
  parameter_set_id: number;
}

interface QuestionsState {
  questions: Question[];
  currentQuestion: Question | null;
  loading: boolean;
  error: string | null;
}

export const useQuestionsStore = defineStore('questions', {
  state: (): QuestionsState => ({
    questions: [],
    currentQuestion: null,
    loading: false,
    error: null
  }),
  
  actions: {
    async fetchQuestions(params: any = {}) {
      this.loading = true
      this.error = null
      
      try {
        const api = useApi()
        this.questions = await api.getQuestions(params)
      } catch (error: any) {
        this.error = error.message
        console.error('問題の取得に失敗しました', error)
      } finally {
        this.loading = false
      }
    },
    
    async fetchQuestion(id: number) {
      this.loading = true
      this.error = null
      
      try {
        const api = useApi()
        this.currentQuestion = await api.getQuestion(id)
      } catch (error: any) {
        this.error = error.message
        console.error('問題の取得に失敗しました', error)
      } finally {
        this.loading = false
      }
    },
    
    async generateQuestions(templateId: number, count: number = 1) {
      this.loading = true
      this.error = null
      
      try {
        const api = useApi()
        const newQuestions = await api.generateQuestions(templateId, count)
        this.questions = [...newQuestions, ...this.questions]
        return newQuestions
      } catch (error: any) {
        this.error = error.message
        console.error('問題の生成に失敗しました', error)
        return []
      } finally {
        this.loading = false
      }
    }
  }
})
