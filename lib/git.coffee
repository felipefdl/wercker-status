iniparser = require 'iniparser'

class WerckerGit
    get_local_git_config: (cb) ->
        branch = atom.project.getRepo()?.branch?.split('/')?[2]
        git_project = atom.project.getRepo()
        if git_project
            iniparser.parse "#{git_project.path}/config", (err, data) ->
                url = data['remote "origin"']?.url
                return cb('Git params invalid') if !url

                if url.indexOf("git@") == 0
                    username = url.split(':')[1].split('/')[0]
                    repository = url.split(':')[1].split('/')[1]
                else if url.indexOf('https://') == 0
                    username   = url.split('/')[3]
                    repository = url.split('/')[4]

                returnobj =
                    repository : "#{username}/#{repository}"
                    branch     : branch
                cb(null, returnobj)
        else
            cb('This package does not have repository')

module.exports = new WerckerGit
