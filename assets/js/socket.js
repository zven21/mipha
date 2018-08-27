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
  let onlineUsers = Presence.list(
    presences,
    (_id, { metas: [user, ...rest] }) => {
      return onlineUserTemplate(user)
    }
  ).join('')

  document.querySelector('#online-users').innerHTML = onlineUsers
}

const onlineUserTemplate = function(user) {
  return `
    <div id="online-user-${user.user_id}">
      <strong class="text-secondary">${user.username}</strong>
    </div>
  `
}

export default socket
