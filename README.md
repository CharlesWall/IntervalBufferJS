# Interval Buffer 

IntervalBuffer is a data structure for group rapidly serial actions into bursts or bulk actions.

## Usage

	var IntervalBuffer = require('interval-buffer');
	var intervalBuffer = new IntervalBuffer({
		maxSize: 5, 
		interval: 100 #ms
	}, function(bufferArray){
		request.post(
			'http://some-url.com/updates', 
			{body: bufferArray},
			function(err, response, callback){
				...handle response
			}
		);
	});

	intervalBuffer.push({firstName: 'john'});
	intervalBuffer.push({lastName: 'wall'});

	...

	intervalBuffer.push({location: 'great wall of china'})

After 100 ms interval the callback defined at instantiation will be called with the following
	[
		{firstName: 'john'},
		{lastName: 'wall'},
		{location: 'great wall of china'}
	]

## Bonus
It may make sense to combine the objects into an array into an object

	function(updatesArray){
		body = {};
		updatesArray.forEach(update){
			for(var key in update) if update.hasOwnProperty(key) {
				body[key] = update[key];
			}
		}

		request.post(
			'http://some-url.com/updates', 
			{body: body},
			function(err, response, callback){
				...handle response
			}
		);
	}

Note while the initial calls may be incremental the final submission is combined and deduplicated.