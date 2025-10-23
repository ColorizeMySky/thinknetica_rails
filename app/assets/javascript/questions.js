document.addEventListener('DOMContentLoaded', () => {
  const editLink = document.querySelector('.edit-question-link')

  if (editLink) {
    editLink.addEventListener('click', handleEditLinkClick)
  }
})

function handleEditLinkClick(e) {
  e.preventDefault()

  const questionId = e.target.dataset.questionId
  const editForm = document.querySelector(`.edit-question-form[data-question-id="${questionId}"]`)

  if (editForm) {
    e.target.style.display = 'none'
    editForm.classList.remove('d-none')
  }
}
