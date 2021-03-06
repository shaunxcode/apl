if typeof define isnt 'function' then define = require('amdefine')(module)

define ['./helpers'], (helpers) ->
  {die, assert} = helpers

  C = (re, im) -> if im then new Complex re, im else re

  class Complex

    constructor: (@re = 0, @im = 0) ->
      assert typeof @re is 'number'
      assert typeof @im is 'number'

    toString: ->
      "#{@re}J#{@im}".replace /-/g, '¯'

    # Compare (`=`)
    #
    #     2j3 = 2j3   ⍝ returns 1
    #     2j3 = 3j2   ⍝ returns 0
    #     0j0         ⍝ returns 0
    #     123j0       ⍝ returns «123»
    #     2j¯3 + ¯2j3 ⍝ returns «0»
    '=': (x) ->
      +((x instanceof Complex) and x.re is @re and x.im is @im)

    # Match (`≡`)
    '≡': (x) ->
      @['='] x

    # Add / Conjugate (`+`)
    #
    #     1j¯2 + ¯2j3   ⍝ returns ¯1j1
    #     +1j¯2         ⍝ returns 1j2
    '+': (x) ->
      if x?
        if typeof x is 'number' then C @re + x, @im
        else if x instanceof Complex then C @re + x.re, @im + x.im
        else throw Error 'Unsupported operation'
      else
        C @re, -@im

    # Subtract / Negate (`−`)
    '−': (x) ->
      if x?
        if typeof x is 'number' then C @re - x, @im
        else if x instanceof Complex then C @re - x.re, @im - x.im
        else throw Error 'Unsupported operation'
      else
        C -@re, -@im

    # Multiply / Sign of (`×`)
    #
    #     1j¯2 × ¯2j3   ⍝ returns 4j7
    #     × 1j¯2        ⍝ fails
    '×': (x) ->
      if x?
        if typeof x is 'number' then C x * @re, x * @im
        else if x instanceof Complex then C @re * x.re - @im * x.im, @re * x.im + @im * x.re
        else throw Error 'Unsupported operation'
      else
        throw Error 'Unsupported operation'

    # Divide / Reciprocal (`÷`)
    #
    #     4j7 ÷ 1j¯2   ⍝ returns ¯2j3
    '÷': (x) ->
      if x?
        if typeof x is 'number' then C @re / x, @im / x
        else if x instanceof Complex
          d = @re * @re + @im * @im
          C (@re * x.re + @im * x.im) / d, (@re * x.im - @im * x.re) / d
        else throw Error 'Unsupported operation'
      else
        d = @re * @re + @im * @im
        C @re / d, -@im / d

  {Complex}
