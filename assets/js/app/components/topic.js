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

const hookPreview = (switcher, textarea) => {
  const preview_box = $(document.createElement('div')).attr('id', 'preview')
  preview_box.addClass('markdown form-control')
  $(textarea).after(preview_box)
  preview_box.hide()
  return $('.preview', switcher).click(function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active')
      $(preview_box).hide()
      $(textarea).show()
    } else {
      $(this).addClass('active')
      $(preview_box).show()
      $(textarea).hide()
      $(preview_box).css('height', $(textarea).height())
      preview($(textarea).val())
    }
    return false
  })
}

const preview = body => {
  $('#preview').text('Loading...')
  $.post(
    '/api/topics/preview',
    {
      body: body
    },
    function(data) {
      return $('#preview').html(data.body)
    },
    'json'
  )
}

const hookReply = () => {
  $('.btn-reply').click(function() {
    const replyId = $(this).data('id')
    setReplyTo(replyId)
    const reply_body = $('#new_reply textarea')
    reply_body.focus()
    return false
  })
}

const setReplyTo = id => {
  $('input[name="reply[parent_id]"]').val(id)
  const replyEl = $(`.reply[data-id=${id}]`)
  const targetAnchor = replyEl.attr('id')
  const replyToPanel = $('.editor-toolbar .reply-to')
  const userNameEl = replyEl.find('a.user-name:first-child')
  const replyToLink = replyToPanel.find('.user')

  replyToLink.attr('href', `#${targetAnchor}`)
  replyToLink.text(userNameEl.text())
  replyToPanel.show()
}

const Topic = {
  selectorNode,
  hookPreview,
  hookReply
}

export default Topic
