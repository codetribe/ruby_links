# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#links').on 'click','.jewel-it', ->
    id=$(@).data('id')
    #alert id
    $.getScript('/links/jewel_it/'+id)
    return null

  $('#links').on 'click','.un-jewel', ->
    id=$(@).data('id')
    #alert id
    $.getScript('/links/un_jewel/'+id)
    return null

  $('#url').on 'blur', ->
    url=$(@).val()
    images_div=$('#images')
    images_div.html("")
    $.get '/links/get_images/?url='+url , (images) ->
      for img in images
        do (img) ->
          images_div.append('<li class="span2"><div class="thumbnail"><a href="#" class="img-select" val="'+img+'" ><img src="'+img+'" /></a></div></li>')
      $('[id^="thumb-carousel"]').carousel();

  $('.thumbnails').on 'click','.img-select',->
    src=$(@).attr('val')
    #alert src
    $("#image-field").val(src)
    return false

  $('#tagsearch-field').keyup ->
    query=$(@).val()
    $.get '/links/search_tags?q='+query, (results) ->
      $('#tag-search').html("")
      for tag in results.results
        do (tag) ->
          url="/links/tag/"+tag
          $('#tag-search').append('<li class="tagsearch-result"><a href="'+url+'">'+tag+'</a></li>')
      $('.tagsearch-result').highlight(results.query)


  goToByScroll= (id) ->
    $('html,body').animate({
      scrollTop: $("#"+id).offset().top},
    'slow')

  $('#show-comment-field').on 'click',->
    $('#comment-field').removeClass('hidden')
    goToByScroll('comment-field')
    return null

  #Later ill do the div referesh method.. I wanna have fun passing around json ;)
  $('#comment-form').on 'submit', ->
    $.post this.action, $(this).serialize(), (comment)->
      comment_text="<div class='comment' id='comment_"+comment.id+"'><span class='comment-content'>"+comment.comment+"</span><strong class='comment-user'> - "
      comment_text+="<br/>-&nbsp;"+comment.user_email+' - '+comment.time
      comment_text+="</strong> &nbsp;<a class='edit-comment hidden' data-id='"+comment.id+"' href='#comment_"+comment.id+"'><i class='icon-pencil red'></i></a>&nbsp;<a class='delete-comment hidden' data-id='"+comment.id+"' href='#'><i class='icon-remove red'></i></a></div>"
      $('#comments').append(comment_text).show('slow')
      $('#comment-field').addClass('hidden').show('slow')
      $('#comment_content').val('')
    , 'json'
    return false

  $('#comments').on 'mouseover','.comment',->
    $(@).children('.delete-comment').removeClass('hidden')
    $(@).children('.edit-comment').removeClass('hidden')
  $('#comments').on 'mouseout','.comment',->
    $(@).children('.delete-comment').addClass('hidden')
    $(@).children('.edit-comment').addClass('hidden')

  $('#comments').on 'click','.delete-comment',->
    el=$(@)
    id=el.data('id')
    conf=window.confirm("Are you sure you want to delete your comment?")
    if conf
      $.ajax({
        url: "/comments/"+id,
        type: 'DELETE',
        dataType: 'json'
        }).done ->
          el.parent().addClass("hidden")
    return false

  $('#comments').on 'click','.edit-comment',->
    el=$(@)
    id=el.data('id')
    el.parent().load("/comments/edit_form/"+id)

  $('#comments').on 'click','.cancel-comment-update',->
    alert("boo")

