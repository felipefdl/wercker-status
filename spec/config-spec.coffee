config = require '../lib/config'

describe 'Configuration lib', ->
    it 'get_config', ->
        atom.config.set 'wercker-status.Token', '123'
        atom.config.set 'wercker-status.Username', 'bozo'
        atom.config.set 'wercker-status.Password', 'onetwothree'
        atom.config.set 'wercker-status.Interval_Minutes', 1
        configloaded = config.get_config()
        expect(configloaded.user).toBe('bozo')
        expect(configloaded.pass).toBe('onetwothree')
        expect(configloaded.interval).toBe(60000)
        expect(configloaded.token).toBe('123')

    it 'reset_config', ->
        atom.config.set 'wercker-status.Token', '123'
        atom.config.set 'wercker-status.Username', 'bozo'
        atom.config.set 'wercker-status.Password', 'onetwothree'
        atom.config.set 'wercker-status.Interval_Minutes', 1
        config.reset_config()
        configloaded = config.get_config()
        expect(configloaded.user).toBe('')
        expect(configloaded.pass).toBe('')
        expect(configloaded.interval).toBe(120000)
        expect(configloaded.token).toBe(undefined)
