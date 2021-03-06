// Generated by CoffeeScript 1.4.0
var define;

if (typeof define !== 'function') {
  define = require('amdefine')(module);
}

define(['./builtins', './helpers'], function(builtinsModule, helpers) {
  var browserBuiltins, builtins, ctx, inherit;
  builtins = builtinsModule.builtins;
  inherit = helpers.inherit;
  browserBuiltins = ctx = inherit(builtins);
  ctx['⍵'] = ('' + location).split('');
  ctx['get_⎕'] = function() {
    return (prompt('⎕:') || '').split('');
  };
  ctx['set_⎕'] = function(x) {
    return alert(x);
  };
  ctx['get_⍞'] = function() {
    return (prompt() || '').split('');
  };
  ctx['set_⍞'] = function(x) {
    return alert(x);
  };
  return {
    browserBuiltins: browserBuiltins
  };
});
