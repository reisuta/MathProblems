export default defineNuxtConfig({
  ssr: false,
  devtools: { enabled: true },
  css: [
    '@mdi/font/css/materialdesignicons.min.css',
    //'~/assets/styles/main.scss'
  ],
  modules: [
    '@nuxt/eslint',
    '@nuxt/fonts',
    '@nuxt/test-utils',
    '@pinia/nuxt'
  ],
  runtimeConfig: {
    public: {
      apiBaseUrl: process.env.API_URL || 'http://localhost:4000'
    }
  },
  app: {
    head: {
      title: '高校数学問題集',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  }
})
