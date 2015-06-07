open = null
fs = null
path = null
WaitView = null


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
    atom.commands.add 'atom-pane', 'external-open:open-in-external-program', externalOpenFromPopup

    atom.commands.add '.tree-view .file .name', 'external-open:open-in-external-program', externalOpenFromTree

    atom.workspace.addOpener (uri) =>
      path = require 'path'
      if (path.extname(uri) in atom.config.get('external-open.extensions')) or (path.extname(uri).substr(1) in atom.config.get('external-open.extensions'))
        WaitView ?= require './wait-view'
        waitView = new WaitView
        externalOpenUri(uri, waitView)
        return waitView
      else
        return


getActivePath = ->
  atom.workspace.getActivePaneItem()?.getPath?()

externalOpenFromPopup = ->
  uri = getActivePath()
  externalOpenUri(uri) if uri?

externalOpenFromTree = ({target}) ->
  externalOpenUri(target.dataset.path) if target.dataset.path?

externalOpenUri = (uri, waitView) ->
  fs ?= require 'fs'
  fs.exists(uri, ((exists) ->
    if (exists)
      open ?= require 'open'
      open(uri, (=> atom.workspace.paneForItem(waitView)?.destroyItem(waitView) if waitView?))
    )
  )
