import 'phoenix_html'
import 'bootstrap'
import 'jquery.caret'
import 'dropzone/dist/dropzone-amd-module'

import socket from './socket'

// JS components
import Times from './app/components/times'
import Utils from './common/components/utils'
import Topic from './app/components/topic'
import Editor from './app/components/editor'
import Session from './app/components/session'

// Decorate
Times.humanize()
Utils.navActive()
// Topic
Topic.selectorNode()
Topic.hookPreview($('.editor-toolbar'), $('.topic-editor'))
Topic.hookReply()
Topic.hookMention()
// Editor
window._editor = new Editor()
// Refresh Captcha
Session.refreshExcaptcha()
