document.addEventListener('turbo:load', () => {
  document.addEventListener('click', (e) => {
    if (e.target.matches('[data-action="click->nested-rondo#addField"]')) {
      e.preventDefault()
      addLinkField(e.target)
    }
    if (e.target.matches('[data-action="click->nested-rondo#removeField"]')) {
      e.preventDefault()
      removeLinkField(e.target)
    }
  })
})

const addLinkField = (button) => {
  const template = document.querySelector('[data-nested-rondo-template]')
  const container = document.querySelector('#links')
  const newId = new Date().getTime()
  const newContent = template.innerHTML.replace(/NEW_RECORD/g, newId)

  container.insertAdjacentHTML('beforeend', newContent)
}

const removeLinkField = (button) => {
  const field = button.closest('.nested-fields')
  field.remove()
}
