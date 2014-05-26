git = require '../lib/git'

describe 'Git lib', ->
    describe 'get_local_git_config', ->
        it 'with error', ->
            git.get_local_git_config (err, data) ->
                expect(err).toBe('This package does not have repository')
                expect(data).toBeUndefined()
