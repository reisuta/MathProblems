import { defineStore } from 'pinia'

interface User {
  id: number;
  name: string;
  email: string;
  role: string;
}

interface AuthState {
  token: string | null;
  user: User | null;
}

export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    token: null,
    user: null
  }),
  
  getters: {
    isAuthenticated: (state) => !!state.token,
    isAdmin: (state) => state.user?.role === 'admin'
  },
  
  actions: {
    setAuth(token: string, user: User) {
      this.token = token
      this.user = user
      
      // ローカルストレージに保存
      localStorage.setItem('token', token)
      localStorage.setItem('user', JSON.stringify(user))
    },
    
    logout() {
      this.token = null
      this.user = null
      
      // ローカルストレージから削除
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    },
    
    initAuth() {
      // ページロード時に認証状態を復元
      const token = localStorage.getItem('token')
      const userJson = localStorage.getItem('user')
      
      if (token && userJson) {
        try {
          const user = JSON.parse(userJson)
          this.token = token
          this.user = user
        } catch (e) {
          console.error('認証情報の復元に失敗しました', e)
          this.logout()
        }
      }
    }
  }
})
