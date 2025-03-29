import 'katex/dist/katex.min.css';
import katex from 'katex';

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.provide('renderMath', (element) => {
    // 数式要素を探す
    const inlineMathElements = element.querySelectorAll('.math-inline');
    const displayMathElements = element.querySelectorAll('.math-display');
    
    // インライン数式をレンダリング
    inlineMathElements.forEach(el => {
      try {
        const formula = el.textContent || '';
        katex.render(formula, el as HTMLElement, { displayMode: false });
      } catch (e) {
        console.error('KaTeX inline rendering error:', e);
      }
    });
    
    // ディスプレイ数式をレンダリング
    displayMathElements.forEach(el => {
      try {
        const formula = el.textContent || '';
        katex.render(formula, el as HTMLElement, { displayMode: true });
      } catch (e) {
        console.error('KaTeX display rendering error:', e);
      }
    });
  });
});
