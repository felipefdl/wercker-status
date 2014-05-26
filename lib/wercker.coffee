qs       = require 'querystring'
request  = require 'request'
constant = require './constant'

class Wercker
    do_post: (path, data, cb) ->
        url = "#{constant.DEFAULT_WERCKER_URL}/api/#{constant.API_VERSION}/#{path}"
        request.post {url: url, form: data}, (e, r, b) ->
            try
              result = JSON.parse(b)
            catch error
              cb(e || error)

             cb(null, result)

    do_get: (path, params, cb) ->
        url = "#{constant.DEFAULT_WERCKER_URL}/api/#{path}?#{qs.stringify(params)}"

        request.get {url: url}, (e, r, b) ->
            try
              result = JSON.parse(b)
            catch error
              cb(e || error)

             cb(null, result)

    request_oauth_token: (user, pass, cb) ->
        postobj =
            username: user
            password: pass
            oauthscope: 'cli'

        @do_post constant.PATH_BASIC_ACCESS_TOKEN, postobj, cb

    get_applications: (cb) ->
        getobj =
            token: atom.config.get 'wercker-status.Token'

        @do_get constant.PATH_GET_APPLICATIONS, getobj, cb

    get_builds: (project_id, cb) ->
        getobj =
            token: atom.config.get 'wercker-status.Token'
        url = constant.PATH_GET_BUILDS.replace('{projectId}', project_id)

        @do_get url, getobj, cb

    mount_url: (build_id) ->
        return "#{constant.DEFAULT_WERCKER_URL}/#build/#{build_id}"

module.exports = new Wercker
