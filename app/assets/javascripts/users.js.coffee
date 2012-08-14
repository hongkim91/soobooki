$ ->
  new ImageCropper()
  $('.privacy-settings .btn-group .init-select').button('toggle')

  $(".navbar li").has("a").each ->
    hrefpath = $("a",this).attr("href").split("?")[0]
    if (hrefpath.toLowerCase()==location.pathname.toLowerCase())
    	$(this).addClass("active")

class ImageCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0,0,400,400]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#user_crop_x').val(coords.x)
    $('#user_crop_y').val(coords.y)
    $('#user_crop_w').val(coords.w)
    $('#user_crop_h').val(coords.h)
