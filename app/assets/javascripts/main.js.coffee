jQuery ->
  $("a[data-click-url]").on 'click', ->
    $.get $(this).attr('data-click-url')
  $("abbr.timeago").timeago()

  $.getJSON '/w/current', (data) ->
    vc = $("#footer #visits_count")
    vc.find('.txt').html(data.visits_count)
    vc.show()
