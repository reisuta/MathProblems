<template>
  <div ref="mathContainer"></div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import katex from 'katex'

const props = defineProps<{
  equation: string;
  displayMode?: boolean;
}>()

const mathContainer = ref<HTMLElement | null>(null)

const renderMath = () => {
  if (mathContainer.value) {
    try {
      katex.render(props.equation, mathContainer.value, {
        displayMode: props.displayMode ?? false,
        throwOnError: false,
        trust: true
      })
    } catch (error) {
      console.error('KaTeX rendering error:', error)
      // エラー時はプレーンテキストとして表示
      mathContainer.value.textContent = props.equation
    }
  }
}

onMounted(() => {
  renderMath()
})

watch(() => props.equation, renderMath)
</script>
