export default class Editor {
  constructor() {
    this.appendCodesFromHint()
    this.initDropzone()
    this.browseUpload()
  }

  initDropzone() {
    const self = this
    const editor = $('textarea.topic-editor')
    editor.wrap('<div class="topic-editor-dropzone"></div>')
    const editor_dropzone = $('.topic-editor-dropzone')
    editor_dropzone.on(
      'paste',
      (function(_this) {
        return function(event) {
          self.handlePaste(event)
        }
      })(this)
    )
    editor_dropzone.dropzone({
      url: '/api/callback/qiniu',
      dictDefaultMessage: '',
      clickable: true,
      paramName: 'file',
      maxFilesize: 20,
      uploadMultiple: false,
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      previewContainer: false,
      processing: function() {
        $('.div-dropzone-alert').alert('close')
        self.showUploading()
      },
      dragover: function() {
        editor.addClass('div-dropzone-focus')
      },
      dragleave: function() {
        editor.removeClass('div-dropzone-focus')
      },
      drop: function() {
        editor.removeClass('div-dropzone-focus')
        editor.focus()
      },
      success: function(header, res) {
        self.appendImageFromUpload([res.qn_url])
      },
      error: function(temp, msg) {},
      totaluploadprogress: function(num) {},
      sending: function() {},
      queuecomplete: function() {
        self.restoreUploaderStatus()
      }
    })
  }

  browseUpload() {
    $('#editor-upload-image').click(function() {
      $('.topic-editor').focus()
      $('.topic-editor-dropzone').click()
    })
  }

  uploadFile(item, filename) {
    const self = this
    const formData = new FormData()
    formData.append('file', item, filename)
    $.ajax({
      url: '/api/callback/qiniu',
      type: 'POST',
      data: formData,
      dataType: 'JSON',
      processData: false,
      contentType: false,
      beforeSend: function() {
        self.showUploading()
      },
      success: function(e, status, res) {
        self.appendImageFromUpload([res.qn_url])
        self.restoreUploaderStatus()
      },
      error: function(res) {
        self.restoreUploaderStatus()
      },
      complete: function() {
        self.restoreUploaderStatus()
      }
    })
  }

  handlePaste(e) {
    const self = this
    const pasteEvent = e.originalEvent
    if (pasteEvent.clipboardData && pasteEvent.clipboardData.items) {
      const image = this.isImage(pasteEvent)
      if (image) {
        e.preventDefault()
        self.uploadFile(image.getAsFile(), 'image.png')
      }
    }
  }

  isImage(data) {
    let i
    while (i < data.clipboardData.items.length) {
      const item = data.clipboardData.items[i]
      if (item.type.indexOf('image') !== -1) {
        return item
      }
      i++
    }
  }

  showUploading() {
    $('#editor-upload-image').hide()
    if (
      $('#editor-upload-image')
        .parent()
        .find('span.loading').length === 0
    ) {
      $('#editor-upload-image').before(
        "<span class='loading'><i class='fa fa-circle-o-notch fa-spin'></i></span>"
      )
    }
  }

  appendImageFromUpload(srcs) {
    let j, len
    let src_merged = ''
    for (j = 0, len = srcs.length; j < len; j++) {
      const src = srcs[j]
      src_merged = '![](' + src + ')\n'
    }
    this.insertString(src_merged)
  }

  restoreUploaderStatus() {
    $('#editor-upload-image')
      .parent()
      .find('span.loading')
      .remove()
    $('#editor-upload-image').show()
  }

  insertString(str) {
    const $target = $('.topic-editor')
    const start = $target[0].selectionStart
    const end = $target[0].selectionEnd
    $target.val(
      $target.val().substring(0, start) + str + $target.val().substring(end)
    )
    $target[0].selectionStart = $target[0].selectionEnd = start + str.length
    $target.focus()
  }

  appendCodesFromHint() {
    $('.insert-codes a').click(function(e) {
      const link = $(e.currentTarget)
      const language = link.data('lang')
      const txtBox = $('.topic-editor')
      const caret_pos = txtBox.caret('pos')
      let prefix_break = ''
      if (txtBox.val().length > 0) {
        prefix_break = '\n'
      }
      const src_merged = prefix_break + '```' + language + '\n\n```\n'
      const source = txtBox.val()
      const before_text = source.slice(0, caret_pos)
      txtBox.val(
        before_text + src_merged + source.slice(caret_pos + 1, source.count)
      )
      txtBox.caret('pos', caret_pos + src_merged.length - 5)
      txtBox.focus()
      txtBox.trigger('click')
    })
  }
}
