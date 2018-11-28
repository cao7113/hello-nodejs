var count = 0

exports.next = function() { return ++count; }
exports.hello = function(){
  console.log("Hello world");
}
