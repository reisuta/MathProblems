import { useAuthStore } from '~/stores/auth'

export default defineNuxtPlugin(async (nuxtApp) => {
  // ページロード時に認証状態を復元
  const authStore = useAuthStore()
  authStore.initAuth()
  
  // 認証が必要なページに対するミドルウェア
  nuxtApp.hook('app:created', () => {
    const router = nuxtApp.$router
    
    router.beforeEach((to, from, next) => {
      const requiresAuth = to.meta.requiresAuth || false
      
      if (requiresAuth && !authStore.isAuthenticated) {
        next('/login')
      } else {
        next()
      }
    })
  })
})
