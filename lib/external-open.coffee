ExternalOpenView = null
open = null
fs = null
path = null

module.exports =
  config:
    extensions:
      title: 'Extensions to open in external program'
      description: 'Will open files of specified types in system default program'
      type: 'array'
      default: ['.pdf']
      items:
        type: 'string'

  activate: ->
    atom.workspace.addOpener (uri) ->
      path = require 'path'
      if (path.extname(uri) in atom.config.get 'external-open.extensions')
        fs = require 'fs'
        if (fs.existsSync(uri))
          open = require 'open'
          ExternalOpenView ?= require './external-open-view'
          view = new ExternalOpenView({uri})
          open(uri, (=>
            if atom.workspace.getActivePaneItem() is view
              atom.workspaceView.trigger 'core:close'
          ))
          view
