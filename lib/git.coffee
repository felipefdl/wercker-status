iniparser = require 'iniparser'

class WerckerGit
    get_local_git_config: (cb) ->
        git_project = atom.project.getRepo()
        if git_project
            iniparser.parse "#{git_project.path}/config", (err, data) ->
                return console.log(err) if err
                cb(null, data)
        else
            cb('This package does not have repository')

module.exports = new WerckerGit
