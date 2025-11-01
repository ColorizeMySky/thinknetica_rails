document.addEventListener('turbo:load', () => {
  document.addEventListener('click', handleClick);
})

const handleClick = (e) => {
  if (e.target.matches('[data-action="click->nested-rondo#addField"]')) {
    e.preventDefault()
    addLinkField(e.target)
  }
  if (e.target.matches('[data-action="click->nested-rondo#removeField"]')) {
    e.preventDefault()
    removeLinkField(e.target)
  }
}

const addLinkField = (button) => {
  const form = button.closest('form');
  const container = form.querySelector('#answer-links') || form.querySelector('#links');
  const linksDiv = container.querySelector('.links');
  const template = linksDiv.querySelector('template');
  const newId = new Date().getTime();
  const newContent = template.innerHTML.replace(/NEW_RECORD/g, newId);

  container.insertAdjacentHTML('beforeend', newContent);
}

const removeLinkField = (button) => {
  const field = button.closest('.nested-fields')
  field.remove()
}
