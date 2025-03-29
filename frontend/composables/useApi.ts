import { useRuntimeConfig } from 'nuxt/app'
import { useAuthStore } from '~/stores/auth'

export const useApi = () => {
  const config = useRuntimeConfig()
  const baseUrl = config.public.apiBaseUrl
  const authStore = useAuthStore()

  const fetchWithAuth = async (endpoint: string, options: any = {}) => {
    const headers = {
      'Content-Type': 'application/json',
      ...options.headers
    }

    if (authStore.isAuthenticated) {
      headers.Authorization = `Bearer ${authStore.token}`
    }

    // const response = await fetch(`${baseUrl}/api/v1${endpoint}`, {
    const response = await fetch(`http://localhost:4000/api/v1${endpoint}`, {
      ...options,
      headers
    })

    // エラーハンドリング
    if (!response.ok) {
      const error = await response.json().catch(() => ({}))
      throw new Error(error.message || 'APIエラーが発生しました')
    }

    return await response.json()
  }

  return {
    // 数学トピック関連
    getTopics: () => fetchWithAuth('/math_topics'),
    getTopic: (id: number) => fetchWithAuth(`/math_topics/${id}`),

    // 問題関連
    getQuestions: (params: any = {}) => {
      const queryString = new URLSearchParams(params).toString()
      return fetchWithAuth(`/questions?${queryString}`)
    },
    getQuestion: (id: number) => fetchWithAuth(`/questions/${id}`),
    generateQuestions: (templateId: number, count: number = 1) => 
      fetchWithAuth('/questions/generate', {
        method: 'POST',
        body: JSON.stringify({ template_id: templateId, count })
      }),
    checkAnswer: (questionId: number, answer: string) => 
      fetchWithAuth(`/questions/${questionId}/check_answer`, {
        method: 'POST',
        body: JSON.stringify({ answer })
      }),

    // ユーザー関連
    getCurrentUser: () => fetchWithAuth('/users/me'),
    getUserStats: () => fetchWithAuth('/users/stats'),

    // 認証関連
    login: (email: string, password: string) => 
      fetchWithAuth('/login', {
        method: 'POST',
        body: JSON.stringify({ email, password })
      }),
    register: (userData: any) => 
      fetchWithAuth('/register', {
        method: 'POST',
        body: JSON.stringify({ user: userData })
      })
  }
}
