git = require '../lib/git'

only_wercker = () -> if process.env.WERCKER then describe else ->

inject_atom_project = () ->
    atom.project =
        getRepo: -> { branch: "refs/heads/master", path: "/Users/felipe/Projects/felipe/wercker-status/.git" }
        destroy: -> return

describe 'Git lib', ->
    only_wercker() 'get_local_git_config', ->
        it 'Success', ->
            git.get_local_git_config (err, data) ->
                expect(data.repository).toBe('felipefdl/atom-wercker-status.git')

    describe 'get_local_project_git', ->
        it 'Success with values', ->
            inject_atom_project()
            localinfo = git.get_local_project_git()
            expect(localinfo.branch).toBe('master')
            expect(localinfo.path).toBe('/Users/felipe/Projects/felipe/wercker-status/.git')

        it 'Success without values', ->
            atom.project = null
            localinfo    = git.get_local_project_git()
            expect(typeof localinfo).toBe('object')
            expect(localinfo.branch).toBeUndefined()
            expect(localinfo.path).toBeUndefined()

    describe 'get_repo_string', ->
        it 'With GitHub ssh', ->
            result = git.get_repo_string('git@github.com:felipefdl/wercker-status.git')
            expect(result.username).toBe('felipefdl')
            expect(result.repository).toBe('wercker-status.git')

        it 'With GitHub https', ->
            result = git.get_repo_string('https://github.com/felipefdl/wercker-status.git')
            expect(result.username).toBe('felipefdl')
            expect(result.repository).toBe('wercker-status.git')

        it 'With Bitbucket ssh', ->
            result = git.get_repo_string('git@bitbucket.org:felipefdl/wercker-status.git')
            expect(result.username).toBe('felipefdl')
            expect(result.repository).toBe('wercker-status.git')

        it 'With Bitbucket https', ->
            result = git.get_repo_string('https://felipefdl@bitbucket.org/felipefdl/wercker-status.git')
            expect(result.username).toBe('felipefdl')
            expect(result.repository).toBe('wercker-status.git')
