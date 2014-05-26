async   = require 'async'
_       = require 'lodash'
git     = require './git'
wercker = require './wercker'

class WerckerStatus
    ctx = null

    init: () ->
        ctx = this
        @set_status('...')
        exec = (err, result) ->
            return console.log(err) if err
            ctx.set_status(result.status)
        async.waterfall [@get_giturl, @get_wercker_status], exec

    get_giturl: (cb) ->
        git.get_local_git_config (err, data) ->
            if err
                return ctx.set_status(null)
            cb(null, data['remote "origin"']?.url)

    get_wercker_status: (url, cb) ->
        wercker.get_applications (err, result) ->
            return cb(err || 'Applications not found') if err or !result
            if result.error?.message == 'Unknown token'
                return atom.config.set('atom-wercker-status.Token', null)
            obj_index = _.findIndex result, {'url': url}
            if obj_index == -1
                return ctx.set_status(null) # When don't match with wercker apps
            cb(null, result[obj_index])

    set_status: (status) ->
        string_wercker = "<span>Wercker:</span>"
        string_instatus = "<span class=\"#{status?.toLowerCase()}\">#{status?.toUpperCase()}</span>"
        string_inner    = "#{string_wercker} #{string_instatus}"
        objwersta = atom.workspaceView.find('#atom-wercker-status')

        if objwersta.length == 0
            atom.workspaceView.statusBar?.prependRight("<div id=\"atom-wercker-status\"></div>")
            objwersta = atom.workspaceView.find('#atom-wercker-status')
        else
            objwersta.find('span').remove()

        if !status
            objwersta.remove()
        else
            objwersta.append(string_inner)

module.exports = new WerckerStatus
