exports.sendMessage = (msg, callback) ->
  chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
    console.log('sending message to', tabs[0], msg)
    chrome.tabs.sendMessage tabs[0].id, msg, callback


__i = 0
orig = console.log
exports.log  = ->
  args = Array::slice.call(arguments, 0)
  args.unshift(__i++)
  orig.apply(console, args)


exports.guid = ->
  s4 = ->
    return Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1)
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
    s4() + '-' + s4() + s4() + s4()


