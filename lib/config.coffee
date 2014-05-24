wercker = require('./wercker')

class WerckerConfig
    context = null

    constructor: () ->
        context = this

        if !this.get_config().user
            this.set_config('', '', '')
        else if !this.get_config().token
            this.get_set_token()

    get_config: () ->
        user =
            user: atom.config.get 'atom-wercker-status.Username'
            pass: atom.config.get 'atom-wercker-status.Password'
            token: atom.config.get 'atom-wercker-status.Token'
        return user

    set_config: (user, pass, token) ->
        token = atom.config.set 'atom-wercker-status.Token', token if token != null
        user = atom.config.set 'atom-wercker-status.Username', user if user != null
        pass = atom.config.set 'atom-wercker-status.Password', pass if pass != null

    set_token: (token) ->
        atom.config.set 'atom-wercker-status.Token', token

    get_set_token: () ->
        user = this.get_config()
        wercker.request_oauth_token user.user, user.pass, (err, result) ->
            console.log err, result
            context.set_config(null, null, result.data.accessToken)

module.exports = new WerckerConfig
