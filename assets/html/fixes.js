document.addEventListener('DOMContentLoaded', () => {
    // The class name of the element to be copied
    const targetClass = 'si-fixtures';

    // Find the element with the specified class
    const elementToCopy = document.querySelector(`.${targetClass}`);

    if (elementToCopy) {
        // Clone the element
        const clonedElement = elementToCopy.cloneNode(true);

        // Clear the current document body
        document.body.innerHTML = '';

        // Append the cloned element to the body
        document.body.appendChild(clonedElement);
    } else {
        console.error(`Element with class '${targetClass}' not found.`);
    }
});