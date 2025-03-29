<template>
  <div ref="mathContainer"></div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { renderMathInElement } from 'mathjax-vue3'

const props = defineProps<{
  equation: string;
}>()

const mathContainer = ref<HTMLElement | null>(null)

const renderMath = () => {
  if (mathContainer.value) {
    mathContainer.value.innerHTML = props.equation
    renderMathInElement(mathContainer.value)
  }
}

onMounted(() => {
  renderMath()
})

watch(() => props.equation, renderMath)
</script>
