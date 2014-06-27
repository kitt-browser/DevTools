$ = require('jquery')

css = (a) ->
  sheets = document.styleSheets
  o = {}
  for sheet in sheets
    rules = sheet.rules || sheet.cssRules
    continue unless rules?
    for r in rules
      # We need to wrap this in a try/catch because we're getting weird
      # formatted CSS on some sites (`e.g. [ng:cloak]`) which makes the parser
      # explode.
      try
        _is = a.is(r.selectorText)
      catch e
        _is = false
      if _is
        o[r.selectorText] or= {}
        o['style attribute'] or = {}
        o[r.selectorText] = $.extend(o[r.selectorText], css2json(r.style))
        o['style attribute'] = $.extend(o['style attribute'], css2json(a.attr('style')))
  return o

css2json = (css) ->
  s = {}
  return s unless css
  if css instanceof CSSStyleDeclaration
    for rule in css
      if ((rule).toLowerCase)
        s[(rule).toLowerCase()] = (css[rule])
  else if typeof css == "string"
    css = css.split("; ")
    for rule in css
      l = rule.split(": ")
      s[l[0].toLowerCase()] = (l[1])
  return s

getCSSForElement = ($elem) -> css2json css $elem

module.exports = {
  css: css
  css2json: css2json
  getCSSForElement: getCSSForElement
}
