[org 0x0100]
;-------------------------------------------------------------------------------------------------------------
inst1:  db 'Choose Your Difficulty Level (From 1 to 3, 1 is Easiest): $'
inst2:  db 'Entered Wrong Input, Enter Again$'
inst3:  db '-> You have     Seconds to Complete      $'
inst4:  db '-> You have to Pick Atleast    Diamonds  $'
inst5:  db 'Your Game Starts in $'
inst6:  db 'Welcome to Rockford Challenges$'
inst7:  db 'Instructions:$'
inst8:  db 'LOADING...$'
inst9:  db 'RockFord:   Wall:   Boulder:   Target:   Dirt:   Diamond:   $'
inst10: db '-> RockFord Controlled by Arrow Keys    $'
inst11: db '-> Avoid Walking Under Boulder          $' 
inst12: db '-> RockFord has 2 lives for each level  $'
inst13: db '-> Collect Required Number of Diamonds  $'
inst14: db '-> Move through Dirt                    $'
inst15: db '-> You have   Levels, - Current Level:  $'
dash:   db '> > > Boulder Dash Game ////COAL COURSE PROJECT/////////// < < <$'
time:   db 'Time Left:$'   
line2:  db 'Move -> Arrow Keys   New Level -> LShift      Restart -> Space       Exit -> Esc$'                    
line3:  db 'Score:          Diamond Remaining:                 Lives:                Level:$'
error1: db 'Wrong Name Input Run File Again$'
error2: db 'Insufficient Or Extra Data in file (Wrong File)$'
error3: db 'File Not Opening (Wrong File Name or Not Exists)$'
crush:  db 35,'Boulder Crash!!!!!! Game Over!!! :('
win:    db 42,'You have made it to the Target! You Won :)'
timeupline: db 40,'You Failed :( Time is Up Restart or Exit'
faulty: db 77,'Your Cave File Contains Unwanted Character or More than one Targets or Starts$'
faulty2: db 42,'You Cannot Proceed!! Press Any key to Exit$'
notgo: db 45,'You Cannot Go Further as it is the last level'
opennings:  db 'Enter filename: Or Press Enter To Load Cave1.txt$'
comparable: db '.txt' 
constant:   db 'cave1.txt',0 
buffer: 
 times 1602 db 0
handle:     dw 0
uplevel: db 0
diff: dw 0 
otherfile: db 0
difficulty1: dw 40
difficulty2: dw 35
difficulty3: dw 30
storedifficulty1: dw 40
storedifficulty2: dw 35
storedifficulty3: dw 30
bytesread:  dw 0 
level:      dw 1
levels:     dw 3
score:      dw 0
remain:     dw 0
lives:      dw 2
tickcount:  dw 0
second:     dw 0
file:	    db 40 								                
	    db 0 									
   times 40 db 0 									        
ter:         db 0
ter2:        db 0
restart:     db 0
stopper:     db 0
won:         db 0
lost:        db 0
position:    dw 0
target:      dw 0
oldposition: dw 0
oldisr:      dd 0
oldtimer:    dd 0
oneplayer:   db 0
onetarget:   db 0
diamonds:    dw 0
giventime:   dw 0
Diamonds:    dw 0
diamondremain: dw 0
timeup:      db 0
