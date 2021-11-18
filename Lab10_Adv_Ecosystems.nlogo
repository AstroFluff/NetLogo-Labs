; Author: Taylor Dudden
; Due Date: 11/15/2021
; Title: Lab10: Eating Nemo
; School: Central New Mexico Community College
; Course Number: CSCI 1108, Section 101
; Semester: Fall 2021
; Instructor: Dr. Chu Jong

breed [fishes fish]
breed [sharks shark]
fishes-own [maxEnergy energy hungry? fresh? speed growth moveCost sight bleeding? hp cannibalism lifeSpan]
sharks-own [maxEnergy energy hungry? fresh? speed growth moveCost sight bleeding? hp cannibalism lifeSpan]
patches-own [colour lifeTime]


; The shapeUp function is made to set all of the values of Sharks and Fishes
; This is to ensure that at startup, we have the correct values.
; Using the is-shark? or is-fish? lines, we can ask
; each individual turtle to check it's breed and then give it the
; appropriate values and how they are calculated
to shapeUp
  if is-shark? self
  [
    set shape "fish"
    ifelse cannibalism > 0 [set color sharkColour + cannibalism][set color sharkColour]
    set size random 5 + 1
    set speed random 5 + 1
    set moveCost (speed * size)
    set energy ((random 200) + 200) * size
    set sight 360
    set hungry? True
    set fresh? True
    set maxEnergy (energy * 3)
    set bleeding? False
    set hp 100 * size
    set lifeSpan 0
  ]

  if is-fish? self
  [
    set shape "fish"
    ifelse cannibalism > 0 [set color fishColour + cannibalism][set color fishColour]
    set size random 3 + 1
    set speed random 5 + 1
    set moveCost (speed * size)
    set energy ((random 100) + 100) * size
    set sight 180
    set hungry? True
    set fresh? True
    set maxEnergy (energy * 3)
    set bleeding? False
    set hp 100 * size
    set lifeSpan 0
  ]
end

; All movement functions are the same for the most part
; except that Sharks need to use less energy in order for them
; to last longer
to movement
  fd speed
  lt random 91
  rt random 91
  ifelse is-shark? self [set energy energy - (moveCost * 0.3)][
    set energy energy - moveCost]
end

; Energy levels are calculated by using this equation
; Firsst, we check to make sure that a turtle is accessing
; this function, then we adjust the size and speed of the turtle
; based off of it's age and how much energy it has currently
to energyLevels
  ifelse is-turtle? self [
  set size size + (sqrt lifespan * 0.05)
    set speed (speed + sqrt energy) * 0.2

    ; This feature is enabled by default
    ; But during testing, I found that
    ; it can really lag the program
    ; when we hit over 5k turtles
    if updateCost [set moveCost (speed * size)]
  ]
  []
end

; randomLoc it made specifically for the regualr Fish
; This is what controls where and how each of our Turtles spawn
; For sharks, they get placed randomly
; But for regular Fish, we place them at least
; 3 patches away from another Fish
; This is to ensure that they don't breed too quickly and
; lag out the program
to randomLoc
  let target 0
  ifelse is-fish? self [ask one-of patches [if not any? fishes in-radius 2[set target self]]
    ifelse target != 0 [
      move-to target][randomLoc]
  ]
  [
    if is-shark? self [setxy random-xcor random-ycor]
  ]
end

; Using the Setup function, we "setup" how our program is
; going to work. We clear out any existing entities on patches
; and then we begin spawning in new entities
to setup
  clear-all
  let x 0
  ; This is what ensures that no two Fish can spawn on the
  ; same patch
  while [x < numFish][
    create-fishes 1 [shapeUp randomLoc]
    set x x + 1]

  ; Sharks need some additional energy because
  ; there aren't very many Fish at the start of the
  ; program
  create-sharks numFish * sharkiPlier [shapeUp randomLoc set energy 600]
  ; Cannibalism is still enabled in this, but I never actually enabled this
  ; feature. There are no lines referencing cannibalism apart from this.
  ask turtles [set cannibalism 0]
  ask patches [set pcolor Blue set lifeTime 0]

  ; More on this later, but this spawns in our
  ; Plankton. I forgot they were called Plankton
  ; and it's much too late to change any of this
  ; So just refer to Seaweed as Plankton
  sWeeds

  reset-ticks
end

; This is what runs out program!
; We check for death twice, just incase one of the
; bred Fishes or Sharks doesn't actually have the energy to move.
; We then check it again, after they have moved
; to make sure that they didn't reach 0 from their movements
to go
  ask turtles
  [
    death
    energyLevels
    if lifeSpan >= 4 [set fresh? False]
    ifelse energy >= maxEnergy / 2 [set hungry? False][set hungry? True]
    ifelse hungry? [foodCheck][breedCheck]
    set lifeSpan lifeSpan + 1
    death
  ]
  weedGrowth
  tick

  ; This ensures that after each turtle has moved and just before we start a second tick,
  ; we refill all of the Plankton
  sWeeds

  ; This stops the program if there aren't any Turtles left
  if not any? turtles [stop]
end


; This is how our Fish "eat" plankton. It also defines how much
; energy that Turtle is given after it has eaten the Plankton
to weedEat
  ask patch-here [set pcolor blue]

  ; This is edited out, because it was for testing only
  ;sWeeds

  set energy energy + seaWeedPower
end

; This is what updates our patches to ensure that at each tick
; we have at least 100 patches of Plankton
to sWeeds
  while [count patches with [pcolor = green] < 100]
  [
    ask one-of patches [if pcolor = blue and not any? fishes-here [set pcolor green]]
  ]
end

; I decided that I wanted the Plankton to grow. At the time, it was seaweed
; But the concept applies to Plankton as well. The longer a single Plankton
; survives, it will start to produce their own offspring.
to weedGrowth
  ask patches with [pcolor = green][if lifeTime = 7 or lifeTime = 14 or lifeTime = 21 [ask neighbors4 [if pcolor != green [set pcolor green]]]]
  ask patches with [pcolor = green][set lifeTime lifeTime + 1]
end

; This is what checks for whether a specific Turtle accessing it
; is a Fish or a Shark. It will then direct that Turtle to the correct
; Function for how they will search for food.
to foodCheck
  if is-shark? self [sharkFeed]
  if is-fish? self [fishFeed]
end

; This is how Fish search for food
; They have a sight range of 180 degrees
; So they will search only Forward in the
; direction that they are facing

to fishFeed
  ; This is a little complex, but I can explain it quickly
  ; What this does is check each patch infront of the Turtle
  ; one by one until it eventually finds one patch that it is
  ; looking for. In this case, we are looking for Plankton
  ; So it will stop once it finds the first patch with
  ; Plankton on it.
  let rad 0
  let distances speed
  let memory []
  while [hungry? and rad <= distances]
  [
    ask patches in-cone rad (sight)
    [
      if pcolor = green
      [
        set rad distances
        set memory (list pxcor pycor)
      ]
    ]
    set rad (rad + 1)
  ]
  ifelse not empty? memory
  [
    facexy first memory last memory
    move-to patch first memory last memory
    set energy (energy - moveCost)

    ; This is what defines how a Fish eats Plankton
    weedEat
  ]
  [
    ; If we cannot find Plankton, we just keep moving
    movement
  ]
end

to sharkFeed
  ; sharkFeed is the same except for these key factors
  ; Sharks eat Fish. So rather than Plankton, we search
  ; specifically for Fish
  ; Ontop of that, Fish don't provide a lot of energy
  ; for our Sharks. This is a design choice.
  ; I wanted Sharks to do population control.
  ; So Sharks in my Program, eat as many Fish as they can
  ; at once based entirely on their Size
  let rad 0
  let distances speed
  let memory 0
  while [hungry? and rad <= distances]
  [
    ask fishes in-cone rad sight
    [
      set rad distances
      set memory self
    ]
    set rad (rad + 1)
  ]
  ifelse memory != 0
  [
    face memory
    move-to memory
    set energy (energy + (carnivorePower * count fishes in-radius (size * 0.6)) - moveCost)
    ask fishes in-radius (size * 0.6) [die]
  ]
  [movement]
end

; This checks to see which breed of Turtle is trying to access this
; function
to breedCheck
  if is-shark? self [sharkBreed]
  if is-fish? self [fishBreed]
end

; Fish only Breed with other Fish and they will
; ask the other Fish if they are Hungry or not.
; If they are not Hungry, the Fishes will mate
; and produce 5 offspring
; fishBreed works exactly the same as fishFeed
; except we aren't eating anything. We are just
; checking for the nearest Fish that also happens
; to not be Hungry
to fishBreed
  ifelse not fresh? [
  let rad 0
  let distances speed
  let memory []
  while [energy >= moveCost + breedCost and rad <= distances]
  [
    ask fishes in-cone rad sight
    [
      if not hungry?
      [
        set energy (energy - moveCost - breedCost)
        set rad distances
        set memory (list xcor ycor)
        hatch 5 [shapeUp]
      ]
    ]
    set rad rad + 1
  ]
  ifelse not empty? memory
  [facexy first memory last memory
    move-to patch first memory last memory
    set energy (energy - moveCost - breedCost)]
  [movement]]
  [movement]
end

; sharkBreed is the same as fishBreed except that
; Sharks have a really hard time keeping up with
; large dips in Fish population. So when the population
; is too low, we ignore the check to see if
; another Shark is Hungry or not. This will end up
; killing a lot of Sharks by having them produce offspring
; even without having enough energy.
to sharkBreed
  ifelse not fresh? [
  let rad 0
  let distances (speed + size)
  let memory []
  while [energy >= moveCost + sharkBreedCost and rad <= distances]
  [
    ask sharks in-cone rad sight
    [
        ifelse count sharks <= 35
        [
          set energy (energy - moveCost - sharkBreedCost)
          set rad distances
          set memory (list xcor ycor)
          ; If there aren't enough Sharks, we produce a lot of them
          hatch 15 [shapeUp]
        ]
        [
          if not hungry?
          [
            set energy (energy - moveCost - sharkBreedCost)
            set rad distances
            set memory (list xcor ycor)
            ; If there are more tahn enough Sharks, we produce very little
            ; This is to ensure population control
            hatch 2 [shapeUp]
          ]]
    ]
    set rad rad + 1
    ]
  ifelse not empty? memory
  [facexy first memory last memory
    move-to patch first memory last memory
    set energy (energy - moveCost - sharkBreedCost)]
    [movement]]
    [movement]
end

; This is how we check for death. Sharks have a lifespan much shorter than
; Fish. So in our code here, we give them a lifespan. I took out the lifespan
; for regular Fish to display that smaller creatures live much longer
; than larger ones
to death
  ifelse is-fish? self [if energy <= 0 [die]][if lifeSpan >= 50 + random 6 or energy <= 0 [die]]
end

; These are just fun buttons, by clicking on either of these
; we spawn in a random amount of Sharks or Fishes up to 100
to additionalSharks
  create-sharks (random 100) + 1 [shapeUp]
end

to additionalFishies
  create-fishes (random 100) + 1 [shapeUp]
end

to defaults
  set sharkBreedCost 300
  set breedCost 113
  set updateCost True
  set numFish 100
  set sharkiPlier 0.15
  set seaWeedPower 150
  set carnivorePower 16
  set fishColour 34
  set sharkColour 113
end
@#$#@#$#@
GRAPHICS-WINDOW
249
10
860
622
-1
-1
3.0
1
10
1
1
1
0
1
1
1
-100
100
-100
100
0
0
1
ticks
30.0

SLIDER
0
287
172
320
numFish
numFish
0
100
100.0
1
1
NIL
HORIZONTAL

BUTTON
184
88
248
121
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
321
172
354
sharkiPlier
sharkiPlier
0
1
0.15
0.01
1
NIL
HORIZONTAL

INPUTBOX
0
542
155
602
fishColour
34.0
1
0
Color

INPUTBOX
0
601
155
661
sharkColour
113.0
1
0
Color

BUTTON
120
10
241
43
NIL
additionalFishies
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
10
121
43
NIL
additionalSharks
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
0
369
200
519
Fish Population
Ticks
Population
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "set-plot-pen-color fishColour" "plot count fishes"
"pen-1" 1.0 0 -7500403 true "set-plot-pen-color sharkColour" "plot count sharks"

BUTTON
176
54
248
87
Default
defaults
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
185
122
248
155
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
211
285
244
435
seaWeedPower
seaWeedPower
50
300
150.0
1
1
NIL
VERTICAL

SLIDER
211
435
244
585
carnivorePower
carnivorePower
0
100
16.0
1
1
NIL
VERTICAL

SLIDER
0
87
172
120
breedCost
breedCost
0
300
113.0
1
1
NIL
HORIZONTAL

SLIDER
0
53
172
86
sharkBreedCost
sharkBreedCost
0
300
300.0
1
1
NIL
HORIZONTAL

SWITCH
11
241
131
274
updateCost
updateCost
0
1
-1000

@#$#@#$#@
## Welcome to my updated Ecosystem!

This time, we added Sharks!
Also some Plankton features!

## How does it work?

It works similarly to the previous Ecosystem Model. Except that inn this case, we now have Sharks that roam around and try to eat up our Fish! The Plankton can now also produce their own Offspring! They will slowly creep into existence and our Fish will gobble them up.

## How do I use it?

There are just so many buttons and sliders everywhere! But let's go ahead and ignore these for now.

Let's just go ahead and click on that "Default" button. This will ensure that the first time we run our little Ecosystem, that it'll run properly and as our Programmer intended to use it.

## What's next?

Well, now that we have all of the Default values setup for us: We can finally hit the "Setup" button. Just like the previous models, this will clear out our field and begin adding in Fish, Sharks, and even Plankton!

## Well now what?

Let's go ahead and click on that "Go" button! We can watch our little guys roam around and try to survive in the aquatic ecosystem.

You can feel free to click the "Go" button again at any moment to pause or even stop the program. Otherwise, the program will continue to run so long as there are Fish or Sharks still around.

## Where'd all the sharks go?

Unfortunately, our little programmer hasn't quite found that "Sweet Spot" to allow the Sharks to continue on past more than 300 ticks. The way she's built it is quite unusual and some would say Experimental. The small Fishies will live long past 10k ticks though!

## Things you can try!

Feel free to mess around with the sliders! Each one has it's own function. For example: the carnivorePower slider controls how much energy a single Fish gives a Shark when eaten. Just remember that Sharks love to eat a bunch of Fish all at once!

## How could I improve this model?

Honestly, I could make the Plankton spawn more reasonably. I just chose to keep it dirty because it was the first thing I came up with and I didn't want to rebuild that whole Function from the ground up and potentially break something else.

The Sharks also do not last very long. I need to come up with a way to balance them out so that they can last longer than 300 ticks. The issue with the Sharks was that they either Decimated the Fish population and then died out quickly due to lack of food, or they couldn't find another to reproduce with quickly enough and eventually all died out.
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
