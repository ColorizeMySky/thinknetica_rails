document.addEventListener('turbo:load', () => {
  document.addEventListener('click', (e) => {
    if (e.target.classList.contains('edit-answer-link')) {
      handleEditAnswerLinkClick(e)
    }
  })
})

function handleEditAnswerLinkClick(e) {
  e.preventDefault()

  const answerElement = e.target.closest('.answer')
  const editForm = answerElement.querySelector('.edit-answer')

  if (editForm) {
    e.target.style.display = 'none'
    editForm.style.display = 'block'
  }
}
