/**
 * 
 */

document.addEventListener("DOMContentLoaded", function () {
    const filterButton = document.querySelectorAll('.filter_button button');

    filterButton.forEach(button => {
        button.addEventListener('click', function () {
            filterButton.forEach(btn => btn.classList.remove('active'));
            
            this.classList.add('active');
        });
    });
});