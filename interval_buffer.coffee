
DEFAULT_INTERVAL = 5000

class IntervalBuffer
	cache: null
	interval: null
	timeoutId: null

	constructor: (@callback, @interval=DEFAULT_INTERVAL)->
		@cache = []

	push: (task)->
		@cache.push task
		@timeoutId = setTimeout (
			=>
				callback @cache
				@cache = []
				@timeoutId = null
		), @interval

	cancel: ->
		@cache = []
		clearTimeout @timeoutId if @timeoutId