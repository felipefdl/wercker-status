status = require '../lib/wercker_status'

describe 'Wercker status lib', ->
    describe 'handle_string', ->
        it 'with result', ->
            buildobj =
                result : 'passed'
                id     : '123'
            result = status.handle_string(buildobj)
            expect(result).toBe('<a href="https://app.wercker.com/#build/123" class="passed">PASSED</a>')

        it 'with status', ->
            buildobj =
                result : 'unknown'
                status : 'running'
                id     : '123'
            result = status.handle_string(buildobj)
            expect(result).toBe('<a href="https://app.wercker.com/#build/123" class="running">RUNNING</a>')

        it 'with error', ->
            buildobj =
                id : '123'
            result = status.handle_string(buildobj)
            expect(result).toBe('<span>ERROR</span>')
