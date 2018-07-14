export default class Utils {
  static navActive() {
    const url =
      window.location.protocol +
      '//' +
      window.location.host +
      window.location.pathname

    $('.mi-nav li a')
      .filter(function() {
        return this.href == url
      })
      .closest('a')
      .addClass('active')
  }
}
