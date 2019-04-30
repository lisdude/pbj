;"============================================================================="
; "Peanut Butter and Jelly: The Quest to Make A Sandwich"
;"============================================================================="

;"============================================================================="
;" Game Information and Versioning"
<VERSION YZIP>              ;"Version 6"
<FREQUENT-WORDS?>           ;"Save space by generating abbreviations"
<FUNNY-GLOBALS?>            ;"More than 240 global variables"
<USE "TEMPLATE">
<CONSTANT RELEASEID 1>
<CONSTANT GAME-BANNER
"Peanut Butter and Jelly: The Quest to Make a Sandwich|A basic game to play around in ZIL.|Written by lisdude (lisdude@lisdude.com)">

;"============================================================================="
;" Includes"
<INSERT-FILE "parser">

;"============================================================================="
;" Game Initialization and Entrypoint"
<ROUTINE GO ()
    <CRLF> <CRLF>
    <TELL "From deep within the bowels of your body emanates a rumble so powerful that it cannot be ignored. You are..." CR CR " ** HUNGRY **" CR CR>
    <INIT-STATUS-LINE>
    <V-VERSION> <CRLF>
    <SETG HERE ,LIVING-ROOM>
    <MOVE ,PLAYER ,HERE>
    <QUEUE I-CAT-WANDER -1>
    <V-LOOK>
    <MAIN-LOOP>>

;"============================================================================="
;" Templates"
<OBJECT-TEMPLATE
    FOLLOW-ROOM =
        ROOM
            (ACTION FOLLOW-R)
            (IN ROOMS)
>

;"============================================================================="
;" Rooms and Objects"
<FOLLOW-ROOM LIVING-ROOM (DESC "Living Room")
    (LDESC "You're standing in the small, but certainly cozy, living room of your home. Being a stark minimalist, there is not much in the way of decoration.
A simple blue recliner faces a modest television. The front door lies to the north and a small hallway to the east.")
    (EAST TO HALLWAY)
    (WEST TO TEST-ROOM)
    (NORTH SORRY "The front door is securely bolted. You wouldn't want to risk inviting bugs inside by opening it, would you?")
    (FLAGS LIGHTBIT)
>

<OBJECT TV (DESC "modest television")
    (SYNONYM TV TELEVISION)
    (ADJECTIVE MODEST)
    (IN LIVING-ROOM)
    (FLAGS NDESCBIT)
    (ACTION C-TV-R)
>

<ROUTINE C-TV-R ()
<COND (<VERB? EXAMINE>
       <TELL "The television is playing " <PICK-ONE ,TV-SHOWS> CR CR "You feel like that was a valuable use of a turn and gain 1 point.">
       <INCREMENT-SCORE 1>)>
>

<GLOBAL TV-SHOWS <LTABLE
2
"an advertisement for toothpaste."
"an advertisement for deodorant."
"an advertisement for double cheeseburgers."
"a rousing jingle about feminine hygiene."
"a promotion for an upcoming program about renovating houses."
"a distorted image of... something."
"a chubby baby rolling around in a wet, but incredibly externally dry, diaper."
>>

<FOLLOW-ROOM TEST-ROOM (DESC "Test Room") (EAST TO LIVING-ROOM) (FLAGS LIGHTBIT)>

<FOLLOW-ROOM HALLWAY (DESC "Small Hallway")
    (LDESC "The hallway is extraordinarily narrow. You almost have to sidle sideways to avoid bumping into the small table against the wall.
The opening to the west leads back into the living room. An opening east leads to the kitchen. A door to the north leads to the bedroom.")
    (WEST TO LIVING-ROOM)
    (FLAGS LIGHTBIT)
>

<OBJECT HALLWAY-TABLE (DESC "small plywood table")
    (SYNONYM TABLE)
    (ADJECTIVE SMALL PLYWOOD)
    (IN HALLWAY)
    (FLAGS CONTBIT SURFACEBIT OPENBIT NDESCBIT SEARCHBIT)
    (ACTION HALLWAY-TABLE-R)
>

<ROUTINE HALLWAY-TABLE-R ( )
    <COND (<VERB? EXAMINE>
           <TELL "The small table is a cheap plywood table that you found on the side of the road one day. The surface is marred and stained, but the utility is unscathed." CR>
           <COND (<FIRST? ,PRSO> 
           <CRLF><DESCRIBE-CONTENTS ,PRSO>)>
           <RTRUE>)>
>

<OBJECT CAT-FOOD (DESC "bag of Fresh Kill Cat Chow")
    (SYNONYM FRESH KILL CHOW)
    (IN HALLWAY-TABLE)
    (VALUE 5)
    (FLAGS TAKEBIT)
>

<OBJECT CAT (DESC "tabby cat")
    (SYNONYM CAT)
    (ADJECTIVE TABBY)
    (IN LIVING-ROOM)
    (FLAGS FEMALEBIT)
    (ACTION CAT-TEST-R)
>

; " Test exit shenanigans with the cat for eventual random movement."
<ROUTINE CAT-TEST-R ()
<COND (<EXIT-EXISTS <META-LOC ,CAT> ,P?EAST>
<TELL "WOW THE EXIT EXISTS" CR>)
(ELSE
<TELL "OH NO THE EXIT DOES NOT EXIST" CR>)>
<TELL "CAT DEBUG: " D <GETP LIVING-ROOM ,P?EAST> CR>
<TELL "RANDOM EXIT: " D <GETP LIVING-ROOM <RANDOM-EXIT <META-LOC ,CAT>>> CR>
>

<GLOBAL CAT-FED <>>
<SYNTAX FEED OBJECT TO OBJECT = V-FEED>

<ROUTINE V-FEED ()
    <COND (<EQUAL? ,PRSI ,CAT>
           <COND (<EQUAL? ,PRSO ,CAT-FOOD>
                  <TELL "The tabby cat gratefully shoves her head into " A ,PRSO ". The bag shakes, rattles, and crunches as the food is crushed by the feline's sharp teeth. When she's had her fill, the cat lifts her head from the bag and rubs her head against your leg." CR>
                  <REMOVE ,CAT-FOOD>
                  <SETG ,CAT-FED T>
                  <DEQUEUE I-CAT-WANDER>
                  <INCREMENT-SCORE 5>)
                 (ELSE <TELL "The cat sniffs tentatively at " A ,PRSO " before deciding that it's not at all worth her time." CR>)>)
          (ELSE <TELL D ,PRSI " doesn't seem interested in eating " A ,PRSO "." CR>)>
>

;"============================================================================="
;" Miscellaneous Routines"
 <ROUTINE INCREMENT-SCORE (NUM)
    <SETG SCORE <+ ,SCORE .NUM>>
>

;" The default action for the FOLLOW-ROOM, this will cause the cat to follow you."
<ROUTINE FOLLOW-R (RARG)
    <COND (<AND <EQUAL? .RARG ,M-ENTER> ,CAT-FED>
    <MOVE ,CAT ,HERE>
    <TELL <PICK-ONE-R ,CAT-MSG> CR CR>)>
>

<GLOBAL CAT-MSG <LTABLE
"You inadvertently kick the tabby cat several times as it tries to brush against your leg while you walk."
"The tabby cat follows you into the room."
"The tabby cat precedes you into the room."
"The tabby cat rushes into the room before you."
>>

; "Allow the cat to wander around each turn until we feed it."
; "TODO: Random arrival / departure messages"
; "      Randomize it so the cat might not move EVERY turn."
<ROUTINE I-CAT-WANDER ("AUX" EXT CAT-LOC NEW-ROOM)
<SET CAT-LOC <META-LOC ,CAT>>                                       ; "Find the cat."
<COND (<SET EXT <RANDOM-EXIT .CAT-LOC>>                             ; "Did we find an exit to wander into?"
        <SET NEW-ROOM <GETP .CAT-LOC .EXT>>                         ; "Store the new room object for readability."
        <COND (<==? ,HERE .CAT-LOC>                                 ; "If the cat is in our location, tell us it left."
                <TELL CR "The cat leaves the room." CR>)
              (<==? ,HERE .NEW-ROOM>                                ; "If the cat just arrived, tell us."
                <TELL CR "The cat wanders into the room." CR>)>
        <MOVE ,CAT .NEW-ROOM>)>                                     ; "Move the cat into the new room."
>

; "Return true if there is an exit (EXT) defined in room (RM)"
<ROUTINE EXIT-EXISTS (RM EXT)
<COND (<EQUAL? <GETP .RM .EXT> <>>
        <RFALSE>)
(ELSE 
        <RTRUE>)>
>

; "When provided a room object, return either a random exit property or FALSE if no useful exits are found."
; "RM: Room Object. EXT: Randomly picked exit. COUNT: Loop iterations. PT: The size of the property."
<ROUTINE RANDOM-EXIT (RM "AUX" EXT COUNT PT)
<SET COUNT 0>
<REPEAT ()
    <SET EXT <PICK-ONE-R ,EXIT-REFERENCES>>     ; "Pick an exit property from the table."
    <SET COUNT <+ .COUNT 1>>
    <COND (<0? <SET PT <GETPT .RM .EXT>>>       ; "If the property value's size is 0, the exit is invalid. Pick another."
            <AGAIN>)
          (<==? <PTSIZE .PT> ,UEXIT>            ; "If the property size matches the size of an exit, we're done."
            <RETURN .EXT>)
          (<G=? .COUNT 12>                      ; "Too many iterations. (Though in 2019 it's probably fine to go way higher.)"
            <RFALSE>)>>
>

<CONSTANT EXIT-REFERENCES <LTABLE
P?NORTH P?SOUTH P?EAST P?WEST
P?NE P?SE P?NW P?SW
P?UP P?DOWN P?IN P?OUT
>>