#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'
{exec} = require '../lib/compiler'
match = require('../lib/vocabulary')['≡']
repr = JSON.stringify

trim = (s) -> s.replace /(^ +| +$)/g, ''

forEachDoctest = (handler, ret) ->
  d = __dirname + '/../src'
  fs.readdir d, (err, files) ->
    if err then throw err
    for f in files when f.match /^\w+.coffee$/
      lines = fs.readFileSync(d + '/' + f, 'utf8').split '\n'
      i = 0
      while i < lines.length
        line = lines[i++]
        while i < lines.length and (m = lines[i].match(/^ *# *\.\.\.(.*)$/))
          line += '\n' + m[1]
          i++
        if m = line.match /^ *# {4,}([^]*)⍝([^]+)$/
          handler code: trim(m[1]), expectation: trim(m[2])
    ret?()

runDoctests = (ret) ->
  nTests = nFailed = 0

  fail = (reason, err) ->
    nFailed++; console.error reason; if err then console.error err.stack

  t0 = Date.now()
  lastTestTimestamp = 0
  forEachDoctest(
    ({code, expectation}) ->
      nTests++
      if m = expectation.match /^returns ([^]*)$/
        expected = exec m[1]
        try
          actual = exec code
          if not match actual, expected
            fail("Test #{repr code} failed: " +
                 "expected #{repr expected} but got #{repr actual}")
        catch e
          fail "Test #{repr code} failed with #{e}", e
      else if m = expectation.match /^fails( [^]*)?$/
        expectedErrorMessage = if m[1] then eval m[1] else ''
        try
          exec code
          fail "Code #{repr code} should have failed, but didn't"
        catch e
          if expectedErrorMessage and
              e.message[...expectedErrorMessage.length] isnt expectedErrorMessage
            fail "Code #{repr code} should have failed with #{
              repr expectedErrorMessage}, but it failed with #{
              repr e.message}", e
      else
        fail "Unrecognised expectation in doctest string #{repr line}"
      if Date.now() - lastTestTimestamp > 100
        process.stdout.write(
          nTests + (if nFailed then " (#{nFailed} failed)" else '') + '\r'
        )
        lastTestTimestamp = Date.now()

    -> # continuation after forEachDoctest
      console.info(
        (if nFailed then "#{nFailed} out of #{nTests} tests failed"
        else "All #{nTests} tests passed") +
        " in #{Date.now() - t0} ms."
      )
      ret?()
  )

if module is require.main then do ->
  runDoctests()
