<template>
  <div class="app-layout">
    <header class="app-header">
      <div class="container">
        <div class="logo">
          <NuxtLink to="/">数学問題集</NuxtLink>
        </div>
        
        <nav class="main-nav">
          <ul>
            <li><NuxtLink to="/">ホーム</NuxtLink></li>
            <li><NuxtLink to="/questions">問題一覧</NuxtLink></li>
          </ul>
        </nav>
        
        <div class="auth-nav">
          <template v-if="isAuthenticated">
            <div class="user-info" @click="toggleUserMenu">
              <span>{{ user?.name }}</span>
              <div class="user-menu" v-if="showUserMenu">
                <NuxtLink to="/profile">マイページ</NuxtLink>
                <a href="#" @click.prevent="logout">ログアウト</a>
              </div>
            </div>
          </template>
          <template v-else>
            <NuxtLink to="/login" class="login-btn">ログイン</NuxtLink>
            <NuxtLink to="/register" class="register-btn">新規登録</NuxtLink>
          </template>
        </div>
      </div>
    </header>
    
    <main class="app-content">
      <slot />
    </main>
    
    <footer class="app-footer">
      <div class="container">
        <p>&copy; {{ new Date().getFullYear() }} 高校数学問題集. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAuthStore } from '~/stores/auth'

const authStore = useAuthStore()
const isAuthenticated = computed(() => authStore.isAuthenticated)
const user = computed(() => authStore.user)

const showUserMenu = ref(false)

const toggleUserMenu = () => {
  showUserMenu.value = !showUserMenu.value
}

const logout = () => {
  authStore.logout()
  navigateTo('/')
}
</script>

<style lang="scss">
// グローバルスタイル
html, body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  font-size: 16px;
  line-height: 1.5;
  color: #333;
  background-color: #f8f9fa;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

// レイアウトスタイル
.app-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.app-header {
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 15px 0;
  
  .container {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .logo {
    a {
      font-size: 1.5rem;
      font-weight: bold;
      color: #1890ff;
      text-decoration: none;
    }
  }
  
  .main-nav {
    ul {
      display: flex;
      list-style: none;
      padding: 0;
      margin: 0;
      
      li {
        margin-right: 20px;
        
        a {
          color: #666;
          text-decoration: none;
          
          &:hover, &.active {
            color: #1890ff;
          }
        }
      }
    }
  }
  
  .auth-nav {
    display: flex;
    align-items: center;
    
    .login-btn, .register-btn {
      padding: 8px 16px;
      border-radius: 4px;
      text-decoration: none;
    }
    
    .login-btn {
      color: #1890ff;
      margin-right: 10px;
      
      &:hover {
        background-color: #f0f8ff;
      }
    }
    
    .register-btn {
      background-color: #1890ff;
      color: white;
      
      &:hover {
        background-color: #40a9ff;
      }
    }
    
    .user-info {
      position: relative;
      cursor: pointer;
      padding: 8px 16px;
      border-radius: 4px;
      
      &:hover {
        background-color: #f5f5f5;
      }
      
      .user-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background-color: #fff;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        border-radius: 4px;
        min-width: 120px;
        z-index: 100;
        
        a {
          display: block;
          padding: 10px 15px;
          color: #666;
          text-decoration: none;
          
          &:hover {
            background-color: #f5f5f5;
          }
        }
      }
    }
  }
}

.app-content {
  flex: 1;
  padding: 30px 0;
}

.app-footer {
  background-color: #fff;
  border-top: 1px solid #f0f0f0;
  padding: 20px 0;
  margin-top: 40px;
  
  p {
    text-align: center;
    color: #999;
    margin: 0;
  }
}
</style>
