jQuery ->
  $("a[data-click-url]").on 'click', ->
    $.get $(this).attr('data-click-url')
  $("abbr.timeago").timeago()
