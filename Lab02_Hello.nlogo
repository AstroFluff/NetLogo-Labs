; Author: Taylor Dudden
; Due Date: 09/22/2021
; Title: Lab02 Hello
; School: Central New Mexico Community College
; Course Number: CSCI 1108, Section 101
; Semester: Fall 2021
; Instructor: Dr. Chu Jong


; You can ignore this code, it just simplifies having to type up "set color one-of base-colors"
; for every line down below for the extra credit stuff
to change-colour
  set color one-of base-colors
end

; In our setup, we create 14 Turtles and set a heading for them
; The heading is just to clear confusion for the math coming up
; We also make sure to clear everything so we have a clean field
; We create some globals when we ask the user for their input
; On the sliders for ty, tx, and direction
; We also have them set a colour for the turtles
to Setup
  clear-all
  create-turtles 14 [set color Colour
    setxy TX TY
    set heading direction]
  reset-ticks
end

; This next line will call all of our functions at the same time
to Go
  T
  A
  Y
  L
  O
  R
  ask turtles [pen-up]
end

; Taking the Globals that our User has created, we can calculate where to start
; placing each turtle so that they can create their parts of a letter
; Using cosine and sine is excessive and I could've gotten better and faster
; results by setting a heading and using "back"
to T
  ask turtle 0 [setxy (-1.5 * sin direction) + TX
    (-1.5 * cos direction) + TY pen-down fd 3]
  ask turtle 1 [rt -90 pen-down fd 3]
end

; Each letter has a set radius that the turtles use to move away from
; their given starting point
to A
  ask turtle 2 [setxy (-3 * sin direction) + TX
    (-3 * cos direction) + TY rt -71 pen-down fd 3.16]
  ask turtle 3 [setxy (-3 * sin direction) + TX
    (-3 * cos direction) + TY rt -109 pen-down fd 3.16]
  ask turtle 4 [setxy (-3 * sin direction) + TX
    (-3 * cos direction) + TY rt -71 fd 1.58 rt -109 pen-down fd 1.03]
end

to Y
  ask turtle 5 [setxy (-4.5 * sin direction) + TX
    (-4.5 * cos direction) + TY rt -140 pen-down fd 1.7]
  ask turtle 6 [setxy (-5.8 * sin direction) + TX
    (-5.8 * cos direction) + TY rt -90 fd 1.09 pen-down fd 1.91]
  ask turtle 7 [setxy (-7.1 * sin direction) + TX
    (-7.1 * cos direction) + TY rt -40 pen-down fd 1.7]
end

to L
  ask turtle 8 [setxy (-8 * sin direction) + TX
    (-8 * cos direction) + TY rt -90 pen-down fd 3]
  ask turtle 9 [move-to turtle 8 rt 180 pen-down fd 2]
end
; Right now, the furthest point is 9.1, which is what we want the furthest distance from the radius to be
; So when we move the Turtle back to setup for a Circle, we need to take that 9.1 into account

to O
  ask turtle 10 [setxy (-12 * sin direction) + TX
    (-12 * cos direction) + TY pen-down repeat 34[fd 0.29 rt -10.6]]
end

; I got a little lazy creating this one, as the others took a lot of math
; and brainpower out of me, so the R really doesn't look all that great

to R
  ask turtle 11 [setxy (-14.1 * sin direction) + TX
    (-14.1 * cos direction) + TY rt -90 pen-down forward 3]
  ask turtle 12 [setxy (-14.1 * sin direction) + TX
    (-14.1 * cos direction) + TY rt -180 pen-down repeat 20[fd .15 rt 9.8]]
  ask turtle 13 [move-to turtle 12 rt -130 pen-down forward 1.7]
end

; ________________________________________________________________________________
; BELOW THIS IS EXTRA CREDIT WORK
; ________________________________________________________________________________

to extra1
  clear-all
  create-turtles 4 [setxy random-xcor random-ycor set heading direction]
  draw-shapes
end

; I just wanted to experiment a little with spawning different turtles or using one turtle
; to see which would be faster

to draw-shapes
  ask turtles [change-colour]
  ask turtle 0 [pen-down fd 3
    ask patch-at random-xcor random-ycor [sprout 3 [change-colour]]
  ask turtle 1 [move-to turtle 0 rt 90 pen-down fd 3]
  ask turtle 2 [move-to turtle 1 rt 180 pen-down fd 3]
  ask turtle 3 [move-to turtle 2 rt -90 pen-down fd 3]]
  ask turtle 4 [pen-down repeat 5 [fd 5 rt 72 change-colour]]
  ask turtle 5 [move-to patch random-xcor random-ycor pen-down repeat 36 [change-colour fd 1 rt 10]]
  ask turtle 6 [move-to patch random-xcor random-ycor pen-down repeat 2 [change-colour fd 7 rt 30 fd 6 rt 150]]
end

; Calling extra2, will create enough turtles and set them to a default brown
; colour so we can begin drawing a house

to extra2
  clear-all
  create-turtles 4 [setxy 0 0 set heading 0 set color 34]
  house
end

; When we call house, it'll call each of these functions in order and
; it'll begin drawing each part of our house

to house
  ask turtle 0 [setxy -3 -3 rt 90 pen-down repeat 4 [fd 6 rt -90]]
  ask turtle 1 [setxy -3 3 rt 45 set color 32 pen-down fd 4.24 rt 90 fd 4.24]
  ask turtle 2 [setxy -1 -3 pen-down fd 2 rt 90 fd 1 rt 90 fd 2]
  ask turtle 3 [set color 95 setxy 1.5 1.5 window setxy 1.5 0.5 window setxy 0.5 1.5 window setxy 0.5 0.5 window]
end

; This next line is just to simplify making each part of the window

to window
  pen-down
  repeat 4 [fd 1 rt 90]
  pen-up
end

; ____________________________________________________________________
; THIS NEXT AREA IS JUST FOR THE EXTENSION WORK
; ____________________________________________________________________

to extra3
  ask turtle 1 [ask patch-at -3 -3 [sprout 1 [set color 15 set heading direction + 180]]]
  ask turtle 14 [pen-down fd 4 rt -82 fd 2 rt 162 fd 4 rt -162 fd 2 rt 82 fd 4 rt -82 fd 10 rt 162 fd 16 rt -162 fd 6 rt 82 fd 6]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
0
170
64
203
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
0
203
63
236
NIL
Go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

INPUTBOX
0
10
155
70
Colour
66.0
1
0
Color

SLIDER
0
72
172
105
tx
tx
-16
16
0.0
1
1
NIL
HORIZONTAL

SLIDER
0
104
172
137
ty
ty
-16
16
0.0
1
1
NIL
HORIZONTAL

SLIDER
0
137
172
170
direction
direction
0
360
205.0
1
1
NIL
HORIZONTAL

BUTTON
63
170
172
203
Extra Credit 1
extra1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
63
203
172
236
Extra Credit 2
extra2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
0
236
172
269
extension
extra3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

@#$#@#$#@
## WHAT IS IT?

This is made for Lab 02 Hello and the initial objective is to write my name.

## HOW IT WORKS

It's a little over engineered because I wanted to play around. But basically,
it takes two locations that our User sets by using the sliders "TX" and "TY"
(which stand for Target X and Target Y coords) and will begin writing from
that location.

## HOW TO USE IT

To use this, simply set your Target X and Y values where you'd like to
start writing my name at. You can find these sliders are labeled "tx" and "ty".

Then you may choose to set a direction using the direction slider, 
this will tell our program at what angle we're going to be writing my name at.

Once you've selected those two, go ahead and press the "Setup" button to start
moving our turtles.

Then, go ahead and press "Go" to begin sending our turtles out.

## THINGS TO NOTICE

There isn't anything too special to watch here other than the name can be
written at any angle.

## THINGS TO TRY

Once the turtles have finished, you may select the final addition to it
which is labeled "extension". It's nothing too amazing, but it does change
a simple name into a simple logo.

You may also  select the options for Extra Credit 1 or Extra Credit 2.
Both of these just show some simple techniques that you can use.

Extra Credit 1 just spawns in Five Simple shapes at any random location
on the field. Each of these turtles will also change their colours as they move.

Extra Credit 2 is just a simple house displaying how to nest commands into
other functions.

## EXTENDING THE MODEL

Some of the things I could've done to improve this model would be to do a little bit
more math and create an elipse around my name as a sort of background.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
