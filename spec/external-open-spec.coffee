{WorkspaceView} = require 'atom'
PdfOpener = require '../lib/pdf-opener'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "PdfOpener", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('pdf-opener')

  describe "when the pdf-opener:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.pdf-opener')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'pdf-opener:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.pdf-opener')).toExist()
        atom.workspaceView.trigger 'pdf-opener:toggle'
        expect(atom.workspaceView.find('.pdf-opener')).not.toExist()
