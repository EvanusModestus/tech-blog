document.addEventListener('DOMContentLoaded', function() {
    // Add copy buttons to code blocks
    const codeBlocks = document.querySelectorAll('.listingblock pre, .literalblock pre, pre.rouge, pre.highlight');

    codeBlocks.forEach(function(block) {
        const wrapper = document.createElement('div');
        wrapper.style.position = 'relative';
        block.parentNode.insertBefore(wrapper, block);
        wrapper.appendChild(block);

        const button = document.createElement('button');
        button.innerHTML = '<i class="fa fa-copy"></i> Copy';
        button.className = 'copy-button';
        button.style.position = 'absolute';
        button.style.top = '5px';
        button.style.right = '5px';
        button.style.padding = '5px 10px';
        button.style.background = '#333';
        button.style.color = '#fff';
        button.style.border = 'none';
        button.style.borderRadius = '3px';
        button.style.cursor = 'pointer';
        button.style.fontSize = '12px';
        button.style.zIndex = '10';

        button.onclick = function() {
            const code = block.textContent;
            navigator.clipboard.writeText(code).then(function() {
                button.innerHTML = '<i class="fa fa-check"></i> Copied!';
                setTimeout(function() {
                    button.innerHTML = '<i class="fa fa-copy"></i> Copy';
                }, 2000);
            });
        };

        wrapper.appendChild(button);
    });
});