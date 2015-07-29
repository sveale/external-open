open = null
fs = null
path = null
WaitView = null
url = null


module.exports =
  config:
    extensions:
      title: 'Extensions to always open in external program'
      description: 'Will open files of specified types in system default program'
      type: 'array'
      default: []
      items:
        type: 'string'
    disregardProtocol:
      title: 'Disregard protocol portion of URI to open'
      description: "Related to issue #5"
      type: 'boolean'
      default: false

  activate: ->
    @hashTable = []
    atom.commands.add 'atom-pane', 'external-open:open-in-external-program', externalOpenFromPopup

    atom.commands.add '.tree-view .file .name', 'external-open:open-in-external-program', externalOpenFromTree

    atom.workspace.addOpener (uri) =>
      url ?= require 'url'
      path ?= require 'path'
      parsedUri = url.parse(uri)

      pathname = parsedUri.pathname
      protocol = parsedUri.protocol

      # If protocol is not null and the user hasn't selected to disregard
      # the protocol part of the uri, do not open in external program
      if protocol? and atom.config.get('external-open.disregardProtocol') is false
        return

      # hacky way of resolving issues that arise when extension is set to
      # be opened in external program and that program is Atom
      if @hashTable[pathname] is undefined
        @hashTable[pathname] = 1
      else
        @hashTable[pathname] += 1
      if @hashTable[pathname] > 2
        @hashTable[pathname] = undefined
        return

      # clear the hashtable for specified path after 2 seconds so that we don't
      # break opening of proper external files
      setTimeout((() => @hashTable[pathname] = undefined), 2000)

      if (path.extname(pathname) in atom.config.get('external-open.extensions')) or (path.extname(pathname).substr(1) in atom.config.get('external-open.extensions'))
        WaitView ?= require './wait-view'
        waitView = new WaitView
        externalOpenUri(pathname, waitView)
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
