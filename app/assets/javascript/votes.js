document.addEventListener('turbo:load', () => {
  document.addEventListener('ajax:success', handleVoteSuccess)
  document.addEventListener('ajax:error', handleVoteError)
})

const handleVoteSuccess = (event) => {
  // const [_data, _status, xhr] = event.detail
  // const form = event.target.closest('form')
  // const targetId = form.closest('.vote-block').id
  // const votableElement = document.getElementById(targetId)
  // if (votableElement) votableElement.outerHTML = xhr.responseText
}

const handleVoteError = (event) => {
  // const data = event.detail[0]

  // const alertContainer = document.querySelector('.alert')
  // if (alertContainer) alertContainer.textContent = data.error || 'Ошибка при голосовании'
}
