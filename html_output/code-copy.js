// Simple click-to-copy for code blocks
document.addEventListener('DOMContentLoaded', function() {
    const codeBlocks = document.querySelectorAll('.listingblock pre, .literalblock pre, pre.rouge, pre.highlight');

    codeBlocks.forEach(block => {
        block.style.cursor = 'pointer';

        block.addEventListener('click', function() {
            const text = this.textContent || this.innerText;
            navigator.clipboard.writeText(text);
        });
    });
});