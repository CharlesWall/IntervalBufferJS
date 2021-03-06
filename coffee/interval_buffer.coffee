DEFAULT_INTERVAL = 5000

{EventEmitter} = require 'events'

class IntervalBuffer extends EventEmitter
	cache: null
	interval: null
	timeoutId: null

	constructor: ({@interval, @maxSize}, @callback)->
		@cache = []
		@interval ?= DEFAULT_INTERVAL
		@maxSize ?= 0
		throw new Error 'callback required to be function' unless typeof @callback is 'function' 

	push: (task)->
		@cache.push task
		@burst() if @cache.length is @maxSize

		unless @timeoutId
			@timeoutId = setTimeout (=> @burst()), @interval
		return

	burst: ->
		@callback @cache
		@cancel()
		@emit 'burst'

	cancel: ->
		@cache = []
		if @timeoutId
			clearTimeout @timeoutId
			@timeoutId = null
		return

module.exports = IntervalBuffer