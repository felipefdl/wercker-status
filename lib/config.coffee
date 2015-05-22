Wercker        = require '../wercker_api/'
wercker_status = require './wercker_status'

class WerckerConfig
    ctx = null
    wercker = new Wercker()

    init: (cb) ->
        ctx = this
        if @get_config().token
            cb(true)
        else if @get_config().user and @get_config().pass
            @get_set_token(cb)
        else
            @reset_config()
            cb(false)

    get_config: () ->
        interval = Number(atom.config.get('wercker-status.Interval_Minutes')) || 2
        return user =
            user     : atom.config.get 'wercker-status.Username'
            pass     : atom.config.get 'wercker-status.Password'
            token    : atom.config.get 'wercker-status.Token'
            interval : ((1000 * (60 * interval)) || 10000)

    reset_config: () ->
        atom.config.set 'wercker-status.Token', null
        atom.config.set 'wercker-status.Username', ''
        atom.config.set 'wercker-status.Password', ''
        atom.config.set 'wercker-status.Interval_Minutes', 2

    get_set_token: (cb) ->
        user = @get_config()
        wercker.request_oauth_token user.user, user.pass, (err, result) ->
            return console.log(err) if err
            if result.data?.accessToken
                atom.config.set 'wercker-status.Token', result.data.accessToken
                atom.config.set 'wercker-status.Username', undefined
                atom.config.set 'wercker-status.Password', undefined
                cb(true)
            else if result.errorMessage
                wercker_status.set_status(result.errorMessage)
            else
                cb(false)

module.exports = new WerckerConfig
