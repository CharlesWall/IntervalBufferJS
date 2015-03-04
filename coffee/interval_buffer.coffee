DEFAULT_INTERVAL = 5000

class IntervalBuffer
	cache: null
	interval: null
	timeoutId: null

	constructor: ({@interval, @maxSize, @callback})->
		@cache = []
		@interval ?= DEFAULT_INTERVAL
		@maxSize ?= 0
		throw 'callback required to be function' unless typeof @callback is 'function' 

	push: (task)->
		@cache.push task
		@burst() if @cache.length is @maxSize

		unless @timeoutId
			@timeoutId = setTimeout (=> @burst()), @interval
		return

	burst: ->
		@callback @cache
		@cancel()

	cancel: ->
		@cache = []
		if @timeoutId
			clearTimeout @timeoutId
			@timeoutId = null
		return

module.exports = IntervalBuffer