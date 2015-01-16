open = null
fs = null
path = null

module.exports =
  config:
    extensions:
      title: 'Extensions to always open in external program'
      description: 'Will open files of specified types in system default program'
      type: 'array'
      default: []
      items:
        type: 'string'

  activate: ->
    atom.commands.add 'atom-pane', 'external-open:file', externalOpenFromPopup

    atom.commands.add '.tree-view .file .name', 'external-open:file', externalOpenFromTree

    atom.workspace.addOpener (uri) =>
      path = require 'path'
      if (path.extname(uri) in atom.config.get 'external-open.extensions')
        externalOpenUri(uri)
        false

getActivePath = ->
  atom.workspace.getActivePaneItem()?.getPath?()

externalOpenFromPopup = ->
  uri = getActivePath()
  externalOpenUri(uri)

externalOpenFromTree = ({target}) ->
  externalOpenUri(target.dataset.path)

externalOpenUri = (uri) ->
  fs ?= require 'fs'
  fs.exists(uri, ((exists) ->
    if (exists)
      open ?= require 'open'
      open(uri)
    )
  )
