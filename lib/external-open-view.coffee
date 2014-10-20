{$, ScrollView} = require 'atom'
path = require 'path'

module.exports =
  class ExternalOpenView extends ScrollView
    @content: ->
      @div class: 'external-open-view pane-item', =>
        @ul class: 'background-message centered', =>
          @li 'Opening in external program...'

    initialize: ({@uri}) ->
      super

      @title = path.basename(@uri)

    getTitle: ->
      @title ? 'external-open'

    getIconName: ->
      'spinner'

    getUri: ->
      @uri
