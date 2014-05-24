config = require './config'
wercker = require('./wercker')

class WerckerStatusInit
    activate: () ->
        console.log('Wercker Status Started')
        wercker.get_applications (err, result) ->
            console.log err, result
            atom.workspaceView.statusBar?.prependRight('<span>Wercker: STATUS HERE<span>')

module.exports = new WerckerStatusInit
