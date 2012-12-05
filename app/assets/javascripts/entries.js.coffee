class jqapi.Entries
  constructor: ->
    self       = @                                        # keep a reference to this
    @el        = $ '#sidebar-content'                     # parent element of category and search result lists
    @currentEl = $ {}                                     # keep track of the current entry

    @el.on 'click', '.entry', ->                          # on clicking a single entry
      self.loadEntry $(@)                                 # load the clicked entry

  loadEntry: (el) ->
    activeClass = 'active'

    unless el.is(@currentEl)                              # dont load the same entry twice
      @currentEl.removeClass activeClass                  # remove active class from recent el
      el.addClass activeClass                             # add it to the clicked entry

      @currentEl = el                                     # cache current entry

      jqapi.events.trigger 'content:load', el.data('slug') # let jqapi.Content know to load some content, pass slug
      jqapi.events.trigger 'search:focus'                 # set the lost focus on the search field