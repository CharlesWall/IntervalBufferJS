// Generated by CoffeeScript 1.8.0
(function() {
  var DEFAULT_INTERVAL, IntervalBuffer;

  DEFAULT_INTERVAL = 5000;

  IntervalBuffer = (function() {
    IntervalBuffer.prototype.cache = null;

    IntervalBuffer.prototype.interval = null;

    IntervalBuffer.prototype.timeoutId = null;

    function IntervalBuffer(_arg, callback) {
      this.interval = _arg.interval, this.maxSize = _arg.maxSize;
      this.callback = callback;
      this.cache = [];
      if (this.interval == null) {
        this.interval = DEFAULT_INTERVAL;
      }
      if (this.maxSize == null) {
        this.maxSize = 0;
      }
      if (typeof this.callback !== 'function') {
        throw new Error('callback required to be function');
      }
    }

    IntervalBuffer.prototype.push = function(task) {
      this.cache.push(task);
      if (this.cache.length === this.maxSize) {
        this.burst();
      }
      if (!this.timeoutId) {
        this.timeoutId = setTimeout(((function(_this) {
          return function() {
            return _this.burst();
          };
        })(this)), this.interval);
      }
    };

    IntervalBuffer.prototype.burst = function() {
      this.callback(this.cache);
      return this.cancel();
    };

    IntervalBuffer.prototype.cancel = function() {
      this.cache = [];
      if (this.timeoutId) {
        clearTimeout(this.timeoutId);
        this.timeoutId = null;
      }
    };

    return IntervalBuffer;

  })();

  module.exports = IntervalBuffer;

}).call(this);
