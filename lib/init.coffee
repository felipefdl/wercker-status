config         = require './config'
wercker_status = require './wercker_status'

class WerckerStatusInit
    activate: () ->
        atom.commands.add 'atom-workspace', "wercker-status:checknow", => @exec()
        setTimeout @exec, 400
        setInterval @exec, config.get_config().interval

    exec: () ->
        config.init (start) ->
            wercker_status.init() if start

module.exports = new WerckerStatusInit
