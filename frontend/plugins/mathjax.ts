import { renderMathInElement } from 'mathjax-vue3'

export default defineNuxtPlugin(() => {
  return {
    provide: {
      renderMath: (element: HTMLElement) => {
        // @ts-ignore
        renderMathInElement(element, {
          delimiters: [
            { left: '$$', right: '$$', display: true },
            { left: '$', right: '$', display: false },
            { left: '\\(', right: '\\)', display: false },
            { left: '\\[', right: '\\]', display: true }
          ]
        })
      }
    }
  }
})
