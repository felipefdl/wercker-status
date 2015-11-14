async   = require 'async'
_       = require 'lodash'
git     = require './git'
Wercker = require '../wercker_api/'

class WerckerStatus
    ctx = null
    wercker = null

    init: () ->
        ctx = this
        configwer = {"token": atom.config.get('wercker-status.Token')}
        wercker = new Wercker(configwer)
        @set_status('...')

        exec = (err, result) ->
            if err
                ctx.set_status(err)
            else
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
            app = _.find apps, (x) -> return x.url.match(gitparams.repository)
            return cb('App not found') if !app # When don't match with wercker apps

            wercker.get_builds app.id, (err, builds) ->
                return cb(err || 'Builds not found') if err or !builds
                build = _.first(_.where(builds, {"branch": gitparams.branch}))
                return cb('Build not found') if !build # When don't match with wercker build
                cb(null, build)

    handle_string: (buildobj) ->
        return "<span>ERROR</span>" if !buildobj.result and !buildobj.status
        if buildobj.result == 'unknown'
            status = buildobj.status
        else
            status = buildobj.result
        href = @mount_url(buildobj.id)
        return "<a href=\"#{href}\" class=\"#{status.toLowerCase()}\">#{status.toUpperCase()}</a>"

    set_status: (status) ->
        workspace_atom = atom.views.getView(atom.workspace)
        $wercker_status = workspace_atom.querySelector('#wercker-status')
        return $wercker_status?.remove() if !status

        string_status = if typeof status == 'string' then "<span>#{status}</span>" else @handle_string(status)
        string_append = "<span>Wercker:</span> #{string_status}"

        if !$wercker_status
            _statusbar = workspace_atom.querySelector('.status-bar-right')
            _newdiv    = document.createElement("div")
            _newdiv.id = "wercker-status"
            _statusbar.insertBefore(_newdiv, _statusbar.firstChild);
            $wercker_status = workspace_atom.querySelector('#wercker-status')
        else
            $wercker_status.querySelector('a, span')?.remove()

        $wercker_status.innerHTML = string_append

    mount_url: (build_id) ->
        return "#{wercker?.constant.DEFAULT_WERCKER_URL}/#build/#{build_id}"

module.exports = new WerckerStatus
