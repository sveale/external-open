open = null
fs = null
path = null
{Pane} = require 'atom'

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
    atom.workspace.addOpener (uriToOpen) ->
      path = require 'path'
      if (path.extname(uriToOpen) in atom.config.get 'external-open.extensions')
        fs = require 'fs'
        if (fs.existsSync(uriToOpen))
          open = require 'open'
          open(uriToOpen)
          null
