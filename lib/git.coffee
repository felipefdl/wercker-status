iniparser = require 'iniparser'

class WerckerGit
    get_local_git_config: (cb) ->
        ctx       = this
        localinfo = @get_local_project_git()
        return cb('This package does not have repository') if !localinfo.path

        iniparser.parse "#{localinfo.path}/config", (err, data) ->
            url = data['remote "origin"']?.url
            return cb('Git params invalid') if !url
            repo = ctx.get_repo_string(url)
            cb null,
                repository : "#{repo.username}/#{repo.repository}"
                branch     : localinfo.branch

    get_local_project_git: () ->
        atom_project = atom.project?.getRepositories()[0]
        branch       = atom_project?.branch?.split('/')?[2]
        path         = atom_project?.path
        return { branch, path }

    get_repo_string: (url) ->
        if url.indexOf("git@") == 0
            username   = url.split(':')[1].split('/')[0]
            repository = url.split(':')[1].split('/')[1]
        else if url.indexOf('https://') == 0 or url.indexOf('ssh://') == 0
            username   = url.split('/')[3]
            repository = url.split('/')[4]
        return { username, repository }

module.exports = new WerckerGit
