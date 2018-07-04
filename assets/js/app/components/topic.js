const selectorNode = () => {
  $('#node-selector .nodes .name a').click(function(e) {
    const el = $(e.currentTarget)
    $('#node-selector').modal('hide')
    $('form input[name="topic[title]"]').focus()
    if ($('form input[name="topic[node_id]"]').length > 0) {
      e.preventDefault()
      const nodeId = el.data('id')
      $('form input[name="topic[node_id]"]').val(nodeId)
      $('#node-selector-button').html(el.text())
      return false
    } else {
      return true
    }
  })
}

const Topic = {
  selectorNode
}

export default Topic
