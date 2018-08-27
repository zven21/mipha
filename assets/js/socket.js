// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import { Socket, Presence } from 'phoenix'

let socket = new Socket('/socket', { params: { token: window.userToken } })

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel('room:lobby', {})
channel
  .join()
  .receive('ok', resp => {
    console.log('Joined successfully', resp)
  })
  .receive('error', resp => {
    console.log('Unable to join', resp)
  })

// Presences
let presences = {}
channel.on('presence_state', state => {
  presences = Presence.syncState(presences, state)
  renderOnlineUsers(presences)
})

channel.on('presence_diff', diff => {
  presences = Presence.syncDiff(presences, diff)
  renderOnlineUsers(presences)
})

const renderOnlineUsers = function(presences) {
  let onlineUsers = `<strong>${
    Object.keys(presences).length
  } Online Users</strong>`
  document.querySelector('#online-users').innerHTML = onlineUsers
}

let channelTopicId = window.channelTopicId

if (channelTopicId) {
  let channel = socket.channel(`topic:${channelTopicId}`, {})
  channel
    .join()
    .receive('ok', resp => {
      console.log('Joined topic successfully', resp)
    })
    .receive('error', resp => {
      console.log('Unable to join', resp)
    })

  channel.on(`topic:${channelTopicId}:new_reply`, message => {
    if (message) {
      $('.notify-updated').show()
    }
  })
}

export default socket
