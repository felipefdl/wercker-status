# To run some test is need define environment variables
# WERCKER_USER = user for wercker
# WERCKER_PASS = password for wercker

Wercker = require('../wercker_api/')
assert  = require('assert')
user    = process.env.WERCKER_USER
pass    = process.env.WERCKER_PASS

if !user or !pass
    throw 'WERCKER_USER or WERCKER_PASS is null'

skip_test = (cb) ->
    return cb(test.skip) if !user or !pass
    cb(test)

suite 'Wercker SDK', ->
    this.slow(2000)
    this.timeout(10000)

    suite 'request_oauth_token', ->
        wercker = null
        before ->
            wercker = new Wercker()

        test 'User not found', (done) ->
            wercker.request_oauth_token 'test', '123', (err, result) ->
                assert.equal('User not found', result.errorMessage)
                done()

        skip_test (test) ->
            test 'Success', (done) ->
                wercker.request_oauth_token user, pass, (err, result) ->
                    assert(result)
                    done()

    suite 'get_applications', ->
        wercker = null
        before (done) ->
            wercker = new Wercker()
            wercker.request_oauth_token user, pass, (err, result) ->
                wercker.token = result?.result?.token
                done()

        test 'Error', (done) ->
            erwer = new Wercker()
            erwer.get_applications (err, result) ->
                assert.equal('Unauthorized', result.error)
                done()

        skip_test (test) ->
            test 'Success', (done) ->
                wercker.get_applications (err, result) ->
                    assert(result.length >= 1)
                    done()

    suite 'get_builds', ->
        wercker = null
        before (done) ->
            wercker = new Wercker()
            wercker.request_oauth_token user, pass, (err, result) ->
                wercker.token = result?.result?.token
                done()

        test 'Success', (done) ->
            projectId = '53836f3ef6e46c63010072e4'
            wercker.get_builds projectId, (err, result) ->
                assert(result.length > 1)
                assert.equal(projectId, result[0].projectId)
                done()

        test 'Error', (done) ->
            projectId = 'a'
            wercker.get_builds projectId, (err, result) ->
                assert.equal('Invalid project id', result.errorMessage)
                done()
