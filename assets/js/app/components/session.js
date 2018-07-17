export default class Session {
  static refreshRucaptcha() {
    $('a.rucaptcha-image-box').click(function(e) {
      const img = $(e.currentTarget).find('img:first')
      const currentSrc = img.attr('src')
      img.attr('src', currentSrc.split('?')[0] + '?' + new Date().getTime())
    })
  }
}
