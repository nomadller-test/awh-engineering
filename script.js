document.addEventListener('DOMContentLoaded', () => {
    const observerOptions = {
        root: document.querySelector('.presentation-container'),
        threshold: 0.5
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Reset animation by removing and re-adding class
                const content = entry.target.querySelector('.content-overlay');
                if (content) {
                    content.style.animation = 'none';
                    content.offsetHeight; /* trigger reflow */
                    content.style.animation = 'fadeInUp 1s ease forwards';
                }

                // Specific hook for loading bar on last slide (Slide 9 in old, Slide 16? No, Slide 9 is Day 8 in new?)
                // Actually Slide 9 in new index.html is "Inclusions".
                // Slide 8 is "Food".
                // Slide 16 is "Contact" (Final slide).
                // Let's check where the loading bar is. 
                // In new index.html, there is no loading bar mentioned in my write.
                // Wait, I might have dragged over some old classes? 
                // I re-wrote index.html completely. I did not include a loading bar in the new structure (Slide 16).
                // So I can remove that check too if it doesn't exist.
            }
        });
    }, observerOptions);

    document.querySelectorAll('.slide').forEach(slide => {
        observer.observe(slide);
    });
});

