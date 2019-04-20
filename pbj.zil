;"============================================================================="
; "Peanut Butter and Jelly: The Quest to Make A Sandwich"
;"============================================================================="

;"============================================================================="
;" Game Information and Versioning"
<VERSION XZIP>              ;"Version 5"
<FREQUENT-WORDS?>           ;"Save space by generating abbreviations"
<FUNNY-GLOBALS?>            ;"More than 240 global variables"
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
    <V-LOOK>
    <MAIN-LOOP>>

;"============================================================================="
;" Rooms and Objects"
<ROOM LIVING-ROOM (DESC "Living Room") (IN ROOMS)
    (LDESC "You're standing in the small, but certainly cozy, living room of your home. Being a stark minimalist, there is not much in the way of decoration.
A simple blue recliner faces a modest television. The front door lies to the north and a small hallway to the east.")
    (EAST TO HALLWAY)
    (NORTH SORRY "The front door is securely bolted. You wouldn't want to risk inviting bugs inside by opening it, would you?")
    (FLAGS LIGHTBIT)
>

<ROOM HALLWAY (DESC "Small Hallway") (IN ROOMS)
    (LDESC "The hallway is extraordinarily narrow. You almost have to sidle sideways to avoid bumping into the small table against the wall.
The opening to the west leads back into the living room. An opening east leads to the kitchen. A door to the north leads to the bedroom.")
    (WEST TO LIVING-ROOM)
    (FLAGS LIGHTBIT)
>

<OBJECT HALLWAY-TABLE (DESC "small plywood table")
    (SYNONYM TABLE)
    (ADJECTIVE SMALL PLYWOOD)
    (IN HALLWAY)
    (FLAGS CONTBIT SURFACEBIT OPENBIT NDESCBIT)
    (ACTION HALLWAY-TABLE-R)
>

<ROUTINE HALLWAY-TABLE-R ( )
    <COND (<VERB? EXAMINE>
           <TELL "The small table is a cheap plywood table that you found on the side of the road one day. The surface is marred and stained, but the utility is unscathed." CR>
           <COND (<AND <FIRST? ,PRSO>> <DESCRIBE-CONTENTS ,PRSO>)>)>
>

;"============================================================================="
;" Verbs and Syntax"