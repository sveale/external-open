{Disposable} = require 'atom'
{$, ScrollView} = require 'atom-space-pen-views'

module.exports =
  class WaitView extends ScrollView
    initialize: () ->
      super

    @content: ->
      @div class: 'external-open pane-item', =>
        @ul class: 'background-message centered', =>
          @li 'Opening in external program...'

    @deserialize: (options = {}) ->
      new WaitView(option)

    serialize: ->
      deserializer: @constructor.name
      uri: @getURI()

    getURI: ->
      @uri

    getTitle: ->
      "Please wait"

    getIconName: ->
      'spinner'

    onDidChangeTitle: -> new Disposable ->

    onDidChangeModified: -> new Disposable ->

    isEqual: (other) ->
      other instanceof WaitView

    destroy: ->
      @disposables?.dispose()

    cancelled: ->
      @hide()

    cancel: ->
      @cancelled()
      @destroy()
