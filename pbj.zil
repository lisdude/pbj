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
    (ACTION CAT-R)
>

<ROUTINE CAT-R ()
    <COND (<VERB? EXAMINE>
            <TELL "This small critter has a thick, fluffy coat of dark lines, dots, stripes, and swirling patterns atop a smattering of light brown. There is a distinctive 'M' on her forehead." CR>)
          (<VERB? ATTACK>
            <TELL "Perish the thought! While small, the cat has razor sharp claws and dagger-like teeth. She is also adept in the art of stealing hearts with preciousness." CR>)>
>

<GLOBAL CAT-FED <>>

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

<ROUTINE V-PET ()
    <COND (<==? ,PRSO ,CAT>
            <TELL "You pet the cat gently on the head and are rewarded with a deep purr. Oh, and a point." CR>
            <INCREMENT-SCORE 1>)
          (ELSE <TELL "You gently pet " D ,PRSI ". You definitely don't feel foolish." CR>)
    >
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

; "When provided a room object, return either a random exit property or FALSE if no useful exits are found."
; "RM: Room Object. EXT: Exit being checked. COUNT: Loop iterations. PT: Pointer to exit property. RND-EXIT: The random chosen exit."
<ROUTINE RANDOM-EXIT (RM "AUX" EXT COUNT PT RND-EXIT)
<SET COUNT 0>
<MAP-DIRECTIONS (EXT PT .RM)                    ; "Iterate through all exits in the room."
    <COND (<ACCEPTABLE-EXIT .PT>
            <SET COUNT <+ .COUNT 1>>)>>         ; "Increment the number of acceptable exits."
<SET RND-EXIT <RANDOM .COUNT>>                  ; "Pick a random number out of the number of valid exits."
<SET COUNT 0>
<MAP-DIRECTIONS (EXT PT .RM)                    ; "Start over with the second loop to find the random exit."
    <COND (<ACCEPTABLE-EXIT .PT>
            <SET COUNT <+ .COUNT 1>>
            <COND (<==? .COUNT .RND-EXIT>       ; "If the exit is acceptable and equal to our random exit, done."
                    <RETURN .EXT>)>)>>
>

; "Determine if an exit is acceptable for wandering.
   TODO: Include doors and other special exits."
<ROUTINE ACCEPTABLE-EXIT (PT)
  <COND (<0? .PT>                       ; "If the property value's size is 0, the exit is invalid. Pick another."
            <RFALSE>)
          (<==? <PTSIZE .PT> ,UEXIT>    ; "If the property size matches the size of an exit, we're done."
            <RTRUE>)>
>

;"============================================================================="
;" Syntax"
<SYNTAX FEED OBJECT TO OBJECT = V-FEED>
<SYNTAX PET OBJECT = V-PET>