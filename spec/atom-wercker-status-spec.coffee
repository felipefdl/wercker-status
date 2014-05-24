{WorkspaceView} = require 'atom'
AtomWerckerStatus = require '../lib/atom-wercker-status'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomWerckerStatus", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('atom-wercker-status')

  describe "when the atom-wercker-status:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.atom-wercker-status')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'atom-wercker-status:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.atom-wercker-status')).toExist()
        atom.workspaceView.trigger 'atom-wercker-status:toggle'
        expect(atom.workspaceView.find('.atom-wercker-status')).not.toExist()
