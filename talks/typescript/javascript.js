const mouseBox = document.querySelector('#mouse-events');

console.log(mouseBox);

mouseBox.addEventListener('click', log);
mouseBox.addEventListener('dblclick', log);
mouseBox.addEventListener('mousedown', log);
mouseBox.addEventListener('mouseenter', log);
mouseBox.addEventListener('mouseleave', log);
mouseBox.addEventListener('mousemove', log);
mouseBox.addEventListener('mouseout', log);
mouseBox.addEventListener('mouseover', log);
mouseBox.addEventListener('mouseup', log);
mouseBox.addEventListener('scroll', log);
mouseBox.addEventListener('wheel', log);

mouseBox.addEventListener('contextmenu', supressContextMenu);

function log(event) {
  const checkboxes = document.querySelectorAll("input[type='checkbox']");
  const eventsToPrint = [];
  for (let input of checkboxes) {
    if (input.checked) {
      eventsToPrint.push(input.value)
    }
  }

  if (!eventsToPrint.includes(event.type)) {
    return
  }

  event.preventDefault();
  event.stopPropagation();
  const p = document.createElement('p');
  const text = document.createTextNode(`→ ${event.type}: ${event.button}`);
  p.appendChild(text);
  document.querySelector('#log').appendChild(p);
  p.scrollIntoView(false);
  console.log(event);
}

function supressContextMenu(event) {
  event.preventDefault();
}
