const mouseBox = document.querySelector('#mouse-events');

console.log(mouseBox)

mouseBox.addEventListener('mousedown', log);
mouseBox.addEventListener('click', log);
mouseBox.addEventListener('mousemove', log);

function log(event) {
  console.log(event);
}