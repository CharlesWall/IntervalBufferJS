IntervalBuffer = require '../interval_buffer.coffee'
sinon = require 'sinon'
assert = require 'assert'

describe 'IntervalBuffer', ->
	clock = null
	before -> clock = sinon.useFakeTimers()
	after -> clock.restore()

	describe 'constructor', ->
		it 'should create an empty cache', ->
			intervalBuffer = new IntervalBuffer 
				callback: ->
				interval: 100
			assert (intervalBuffer.cache instanceof Array), 'did not create an array for the cache'
			assert.equal intervalBuffer.cache.length, 0, 'the cache should be empty on initialization'
	describe 'push', ->
		it 'should add the item to the cache', ->
			intervalBuffer = new IntervalBuffer
				callback: ->
				interval: 100
			item = {}
			intervalBuffer.push item
			assert.equal intervalBuffer.cache[0], item, 'the first element in the cache should have been the one pushed'

		it 'should set the time out', ->
			intervalBuffer = new IntervalBuffer
				callback: ->
				interval: 100
			intervalBuffer.push {}
			assert intervalBuffer.timeoutId, 'did not set a timeout on push' 
		it 'should call the callback with the aggregate of all push calls made in the span of the timeout', ->
			callback = sinon.spy()
			intervalBuffer = new IntervalBuffer { callback, interval: 5000 }
			intervalBuffer.push i for i in [0...10]
			clock.tick 5000
			assert callback.calledWith([0...10]), 'the callback was not called with the buffered elements'
			assert.equal intervalBuffer.cache.length, 0, 'the cache should be empty after a callback'
		it 'should call the callback with the aggregate of all push calls made when the max size is reached', ->
			callback = sinon.spy()
			intervalBuffer = new IntervalBuffer { callback, interval: 5000, maxSize: 10 }
			intervalBuffer.push i for i in [0...11]
			assert callback.calledWith([0...10]), 'the callback was not called with the buffered elements'
			assert.equal intervalBuffer.cache.length, 1, 'the cache should have the extra element waiting to be bursted'
