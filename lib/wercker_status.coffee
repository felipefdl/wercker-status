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
            ctx.set_status(result)
        async.waterfall [@get_gitparams, @get_wercker_status], exec

    get_gitparams: (cb) ->
        git.get_local_git_config (err, data) ->
            if err
                return ctx.set_status(null)
            cb(null, data)

    get_wercker_status: (gitparams, cb) ->
        wercker.get_applications (err, apps) ->
            return cb(err || 'Applications not found') if err or !apps
            if apps.error?.message == 'Unknown token'
                return atom.config.set('wercker-status.Token', null)
            app = _.first(_.where(apps, {'url': gitparams.url}))
            return ctx.set_status(null) if !app # When don't match with wercker apps

            wercker.get_builds app.id, (err, builds) ->
                return cb(err || 'Builds not found') if err or !builds
                build = _.first(_.where(builds, {"branch": gitparams.branch}))
                cb(null, build)

    set_status: (build) ->
        if (typeof build == 'string')
            string_instatus = "<span>#{build}</span>"
        else
            string_instatus = "<a href=\"#{wercker.mount_url(build.id)}\" class=\"#{build.result?.toLowerCase()}\">#{build.result?.toUpperCase()}</a>"
        string_wercker = "<span>Wercker:</span>"
        string_inner   = "#{string_wercker} #{string_instatus}"
        objwersta      = atom.workspaceView.find('#wercker-status')

        if objwersta.length == 0
            atom.workspaceView.statusBar?.prependRight("<div id=\"wercker-status\"></div>")
            objwersta = atom.workspaceView.find('#wercker-status')
        else
            objwersta.find('a, span').remove()

        if !build
            objwersta.remove()
        else
            objwersta.append(string_inner)

module.exports = new WerckerStatus
