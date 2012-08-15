# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # This works even for newly generated elements. Bind to the outter
  # entries list and then bubble the events to the entry-container.
  $('#entries').on('mouseenter', '.entry-container', entries.select)
  $('#entries').on('mouseleave', '.entry-container', entries.deselect)
  
  # Bind the keys to control the entries page.
  Mousetrap.bind('j', entries.selectNextEntry)
  Mousetrap.bind('k', entries.selectPreviousEntry)
  Mousetrap.bind('n', entries.new)
  Mousetrap.bind('e', entries.edit)
  Mousetrap.bind('d', entries.delete)
  
entries =
  new: ->
    $('#entry_content').focus()
    return false

  edit: ->
    id = entries.getCurrentEntryId()
    if id
      $.ajax({
        url: "/entries/#{id}/edit"
        dataType: 'script'
      })
  
  delete: ->
    id = entries.getCurrentEntryId()
    if id
      $.ajax({
        url: "/entries/#{id}"
        type: "delete"
        dataType: "script"
      })

  selectNextEntry: ->
    id = entries.getCurrentEntryId()
    if !id
      id = entries.getFirstEntryId()
      $('div#entry_'+id).addClass('selected')
      return
    $('div#entry_'+id).removeClass('selected')
    $('div#entry_'+entries.getNextEntryId(id)).addClass('selected')
    
  selectPreviousEntry: ->
    id = entries.getCurrentEntryId()
    if !id
      id = entries.getFirstEntryId()
      $('div#entry_'+id).addClass('selected')
      return
    $('div#entry_'+id).removeClass('selected')
    $('div#entry_'+entries.getPreviousEntryId(id)).addClass('selected')

  select: ->
    $('.entry-container').removeClass('selected')
    $(this).addClass('selected')
  
  deselect: ->
    $('.entry-container').removeClass('selected')

  getCurrentEntryId: ->
    return parseInt $('.entry-container.selected').attr('data-id')

  getNextEntryId: (current) ->
    ids = entries.getIds()
    index = jQuery.inArray(current, ids)
    if index > -1
      return ids[index + 1]
  
  getPreviousEntryId: (current) ->
    ids = entries.getIds()
    index = jQuery.inArray(current, ids)
    if index > -1
      return ids[index - 1]
    
  getFirstEntryId: ->
    return parseInt $('.entry-container').first().attr('data-id')
  
  getIds: ->
    ids = []
    $('.entry-container').each ->
      ids.push(parseInt(this.getAttribute('data-id')))
    return ids