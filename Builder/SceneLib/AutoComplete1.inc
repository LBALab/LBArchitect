
procedure TfmScriptEd.InitACLba1Org();
begin
TrackScriptACIt.Text:=
 '\style{+B}\color{clGreen}Control statements:'#13
+'\style{+B}\color{clGreen}END\style{-B} \column{}\color{clGray}Marks end of the script'#13
+'\style{+B}\color{clGreen}LABEL\style{-B} label_id(int) [name(text)]   \color{clGray}Marks palce in the script to jump to with GOTO command'#13
+'\style{+B}\color{clGreen}GOTO\style{-B} label_id(int) \style{+B}or\style{-B} name(text)   \color{clGray}Jumps execution of the script to specified LABEL'#13
+'\style{+B}\color{clBlack}STOP\style{-B} \column{}\color{clGray}Stops execution of the TrackScript'#13
+#13
+'\style{+B}\color{clNavy}Commands:'#13
+'\style{+B}\color{clNavy}ANGLE\style{-B} value(int)\column{}\color{clGray}Makes the actor turn to specified angle'#13
+'\style{+B}\color{clNavy}ANGLE_RND\style{-B} value(int)\column{}\color{clGray}Makes the actor turn in random direction by about 90 degrees'#13
+'\style{+B}\color{clNavy}ANIM\style{-B} anim_id(int)\column{}\color{clGray}Sets specified animation for the actor'#13
+'\style{+B}\color{clNavy}BACKGROUND\style{-B} set(0 or 1)   \color{clGray}Sets the actor to be a backgroud actor (1) or not (0)'#13
+'\style{+B}\color{clNavy}BETA\style{-B} value(int)\column{}\color{clGray}Makes the actor turn to specified angle without animation'#13
+'\style{+B}\color{clNavy}BODY\style{-B} body_id(int)\column{}\color{clGray}Sets specified body for the actor'#13
+'\style{+B}\color{clNavy}CLOSE\style{-B} \column{}\color{clGray}Closes the door actor'#13
+'\style{+B}\color{clNavy}FACE_TWINKEL\style{-B} \column{}\color{clGray}Makes the actor turn to look at the hero'#13
+'\style{+B}\color{clNavy}GOTO_POINT\style{-B} point_id(int)   \color{clGray}Makes the 3D actor go to specified Point'#13
+'\style{+B}\color{clNavy}GOTO_POINT_3D\style{-B} point_id(int)   \color{clGray}Makes the Sprite actor move to specified Point'#13
+'\style{+B}\color{clNavy}GOTO_SYM_POINT\style{-B} point_id(int)   \color{clGray}Makes the actor go backward to specified Point'#13
+'\style{+B}\color{clNavy}NO_BODY\style{-B} \column{}\color{clGray}Makes the actor use no body (invisible)'#13
+'\style{+B}\color{clNavy}OPEN_DOWN\style{-B} distance(int)   \color{clGray}Moves the door actor down by the specified distance'#13
+'\style{+B}\color{clNavy}OPEN_LEFT\style{-B} distance(int)   \color{clGray}Moves the door actor left by the specified distance'#13
+'\style{+B}\color{clNavy}OPEN_RIGHT\style{-B} distance(int)   \color{clGray}Moves the door actor right by the specified distance'#13
+'\style{+B}\color{clNavy}OPEN_UP\style{-B} distance(int)\column{}\color{clGray}Moves the door actor up by the specified distance'#13
+'\style{+B}\color{clNavy}PLAY_FLA\style{-B} name(string)\column{}\color{clGray}Plays spiecified FLA animation'#13
+'\style{+B}\color{clNavy}POS_POINT\style{-B} point_id(int)   \color{clGray}Immediately moves the actor to specified Point'#13
+'\style{+B}\color{clNavy}REPEAT_SAMPLE\style{-B} sample_id(int)   \color{clGray}Sets number of repeats for next SIMPLE_SAMPLE command'#13
+'\style{+B}\color{clNavy}SAMPLE\style{-B} sample_id(int)\column{}\color{clGray}Plays specified sample once'#13
+'\style{+B}\color{clNavy}SAMPLE_ALWAYS\style{-B} sample_id(int)   \color{clGray}Plays specified sample continuously'#13
+'\style{+B}\color{clNavy}SAMPLE_RND\style{-B} sample_id(int)   \color{clGray}Plays specified sample at a random pitch'#13
+'\style{+B}\color{clNavy}SAMPLE_STOP\style{-B} sample_id(int)   \color{clGray}Stops playing sample started with SAMPLE_ALWAYS command'#13
+'\style{+B}\color{clNavy}SIMPLE_SAMPLE\style{-B} sample_id(int)   \color{clGray}Plays sample for number of times specified with REPEAT_SAMPLE'#13
+'\style{+B}\color{clNavy}SPEED\style{-B} value(int)\column{}\color{clGray}Sets movement speed of the actor'#13
+'\style{+B}\color{clNavy}WAIT_ANIM\style{-B} \column{}\color{clGray}Pauses script execution until current animation finishes playing'#13
+'\style{+B}\color{clNavy}WAIT_DOOR\style{-B} \column{}\color{clGray}Pauses script execution until door finishes opening or closing'#13
+'\style{+B}\color{clNavy}WAIT_NB_ANIM\style{-B} count(int)   \color{clGray}Pauses execution until animation plays for specified number of times'#13
+'\style{+B}\color{clNavy}WAIT_NB_SECOND\style{-B} time(int)   \color{clGray}Pauses script execution for specified number of seconds';


TrackScriptACIn.Text:=
 ''#13
+'END'#13
+'LABEL'#13
+'GOTO'#13
+'STOP'#13
+''#13
+''#13
+'ANGLE'#13
+'ANGLE_RND'#13
+'ANIM'#13
+'BACKGROUND'#13
+'BETA'#13
+'BODY'#13
+'CLOSE'#13
+'FACE_TWINKEL'#13
+'GOTO_POINT'#13
+'GOTO_POINT_3D'#13
+'GOTO_SYM_POINT'#13
+'NO_BODY'#13
+'OPEN_DOWN'#13
+'OPEN_LEFT'#13
+'OPEN_RIGHT'#13
+'OPEN_UP'#13
+'PLAY_FLA'#13
+'POS_POINT'#13
+'REPEAT_SAMPLE'#13
+'SAMPLE'#13
+'SAMPLE_ALWAYS'#13
+'SAMPLE_RND'#13
+'SAMPLE_STOP'#13
+'SIMPLE_SAMPLE'#13
+'SPEED'#13
+'WAIT_ANIM'#13
+'WAIT_DOOR'#13
+'WAIT_NB_ANIM'#13
+'WAIT_NB_SECOND';

LifeScriptACCmdIt.Text:=
 '\style{+B}\color{clGreen}Control statements:'#13
+'\style{+B}\color{clGreen}COMPORTEMENT\style{-B} name(string)\column{}\color{clGray}Begins comportment block'#13
+'\style{+B}\color{clGreen}END\style{-B} \column{}\color{clGray}Marks the end of the current LifeScript'#13
+'\style{+B}\color{clGreen}END_COMPORTEMENT\style{-B} \column{}\color{clGray}Marks the end of a COMPORTMENT block'#13
+'\style{+B}\color{clGreen}END_LIFE\style{-B} \column{}\color{clGray}Terminates the Actor''s LifeScript execution'#13
+'\style{+B}\color{clGreen}RETURN\style{-B} \column{}\color{clGray}Moves script execution to the beginning of the current COMPORTMENT'#13
+'\style{+B}\color{clGreen}SET_COMPORTEMENT\style{-B} name(string)   \color{clGray}Moves LifeScript execution to specified COMPORTMENT'#13
+'\style{+B}\color{clGreen}SET_COMPORTEMENT_OBJ\style{-B} actor_id(int) name(string)   \color{clGray}Moves LifeScript execution of another actor'#13
//+'\style{+B}LABEL\style{-B} label_id(text)\column{}\color{clGray}Marks palce in the script to jump to with OFFSET command'#13
//+'\style{+B}OFFSET\style{-B} label_id(text)\column{}\color{clGray}Jumps execution of the LifeScript to the specified LABEL'#13
+'\style{+B}IF\style{-B} \column{}\color{clGray}Checks the given condition and executes block below if true'#13
+'\style{+B}ONEIF\style{-B} \column{}\color{clGray}Works like IF, but is executed only once'#13
+'\style{+B}SWIF\style{-B} \column{}\color{clGray}(undested) Not known'#13
+'\style{+B}OR_IF\style{-B} \column{}\color{clGray}Used to make multiple conditions; must be put before IF'#13
+'\style{+B}ELSE\style{-B} \column{}\color{clGray}Executes block below it if IF condition is false'#13
+'\style{+B}ENDIF\style{-B} \column{}\color{clGray}Marks end of the conditional block'#13
+''#13
+'\style{+B}\color{clNavy}Commands:'#13
+'\style{+B}\color{clNavy}ADD_CHOICE\style{-B} text_id(int)\column{}\color{clGray}Adds choice to the list'#13
+'\style{+B}\color{clNavy}ADD_FUEL\style{-B} count(int)\column{}\color{clGray}Adds specified amount of fuel to the inventory'#13
+'\style{+B}\color{clNavy}ANIM\style{-B} anim_id(int)\column{}\color{clGray}Sets specified animation for the actor'#13
+'\style{+B}\color{clNavy}ANIM_OBJ\style{-B} actor_id(int) anim_id(int)   \color{clGray}Sets animation for another actor'#13
+'\style{+B}\color{clNavy}ANIM_SET\style{-B} anim_id(int)\column{}\color{clGray}Sets specified animation without a transition'#13
+'\style{+B}\color{clNavy}ASK_CHOICE\style{-B} text_id(int)\column{}\color{clGray}Displays choice list made of items set by ADD_CHOICE'#13
+'\style{+B}\color{clNavy}ASK_CHOICE_OBJ\style{-B} actor_id(int) text_id(int)   \color{clGray}Displays choice list asked by another actor'#13
+'\style{+B}\color{clNavy}BETA\style{-B} angle(int)\column{}\color{clGray}Immediately sets specified angle for the actor'#13
+'\style{+B}\color{clNavy}BIG_MESSAGE\style{-B} text_id(int)\column{}\color{clGray}Displays full-screen message'#13
+'\style{+B}\color{clNavy}BODY\style{-B} body_id(int) \column{}\color{clGray}Sets specified body for the actor'#13
+'\style{+B}\color{clNavy}BODY_OBJ\style{-B} actor_id(int) body_id(int)   \color{clGray}Sets body for another actor'#13
+'\style{+B}\color{clNavy}BRICK_COL\style{-B} switch(0 or 1)\column{}\color{clGray}Sets "can collide with bricks" flag for the actor'#13
+'\style{+B}\color{clNavy}BRUTAL_EXIT\style{-B} \column{}\color{clGray}Exits to the main game menu'#13
+'\style{+B}\color{clNavy}BULLE_OFF\style{-B} \column{}\color{clGray}Turns talk balloons off'#13
+'\style{+B}\color{clNavy}BULLE_ON\style{-B} \column{}\color{clGray}Turns talk balloons on'#13
+'\style{+B}\color{clNavy}CAM_FOLLOW\style{-B} actor_id(int)\column{}\color{clGray}Makes the camera follow specified actor'#13
+'\style{+B}\color{clNavy}CHANGE_CUBE\style{-B} scene_id(int)\column{}\color{clGray}Changes to another scene'#13
+'\style{+B}\color{clNavy}CLEAR_TEXT\style{-B} \column{}\color{clGray}Paints upper half of the screen black'#13
+'\style{+B}\color{clNavy}CLR_HOLO_POS\style{-B} pos_id(int)\column{}\color{clGray}Clears specified holomap position'#13
+'\style{+B}\color{clNavy}COMPORTEMENT_HERO\style{-B} behaviour\column{}\color{clGray}Sets hero behaviour (NORMAL, ATHLETIC, AGGRESSIVE, DISCRETE)'#13
+'\style{+B}\color{clNavy}EXPLODE_OBJ\style{-B} actor_id(int)\column{}\color{clGray}Plays explosion animation over the actor'#13
+'\style{+B}\color{clNavy}FALLABLE\style{-B} switch(0 or 1) \column{}\color{clGray}Sets "can fall" flag for the actor'#13
+'\style{+B}\color{clNavy}FADE_ALARM_PAL\style{-B} \column{}\color{clGray}Fades palette from alarm to normal'#13
+'\style{+B}\color{clNavy}FADE_ALARM_RED\style{-B} \column{}\color{clGray}Fades palette from alarm to red'#13
+'\style{+B}\color{clNavy}FADE_PAL_ALARM\style{-B} \column{}\color{clGray}Fades palette from normal to alarm'#13
+'\style{+B}\color{clNavy}FADE_PAL_RED\style{-B} \column{}\color{clGray}Fades palette from normal to red'#13
+'\style{+B}\color{clNavy}FADE_RED_ALARM\style{-B} \column{}\color{clGray}Fades palette from red to alarm'#13
+'\style{+B}\color{clNavy}FADE_RED_PAL\style{-B} \column{}\color{clGray}Fades palette from red to normal'#13
+'\style{+B}\color{clNavy}FOUND_OBJECT\style{-B} obj_id(int)\column{}\color{clGray}Displays "found object" message'#13
+'\style{+B}\color{clNavy}FULL_POINT\style{-B} \column{}\color{clGray}Replenishes life and magic points of the actor'#13
+'\style{+B}\color{clNavy}GAME_OVER\style{-B} \column{}\color{clGray}Displays "game over" text and ends the game'#13
+'\style{+B}\color{clNavy}GIVE_BONUS\style{-B} ddis(0 or 1)\column{}\color{clGray}Makes the actor "pop out" the bonus defined in actor settings'#13
+'\style{+B}\color{clNavy}GIVE_GOLD_PIECES\style{-B} amount(int)   \color{clGray}Makes the hero spend specified amount of money'#13
+'\style{+B}\color{clNavy}GRM_OFF\style{-B}\column{}\color{clGray}Returns the set disappearing grid framgent to normal'#13
+'\style{+B}\color{clNavy}HIT_OBJ\style{-B} actor_id(int) damage(int)   \color{clGray}Makes the specified Actor take damage'#13
+'\style{+B}\color{clNavy}HOLOMAP_TRAJ\style{-B} traj_id(int)\column{}\color{clGray}Displays holomap with specified trajectory animation'#13
+'\style{+B}\color{clNavy}INC_CHAPTER\style{-B} \column{}\color{clGray}Increases the CHAPTER variable by one'#13
+'\style{+B}\color{clNavy}INC_CLOVER_BOX\style{-B} \column{}\color{clGray}Increases the number of hero''s clover boxes'#13
+'\style{+B}\color{clNavy}INIT_PINGOUIN\style{-B} \column{}\color{clGray}Inits mecha-pingouins, they cannot be used in current scene without this'#13
+'\style{+B}\color{clNavy}INVISIBLE\style{-B} switch(0 or 1)\column{}\color{clGray}Makes the actor invisible (1) or visible (0)'#13
+'\style{+B}\color{clNavy}KILL_OBJ\style{-B} actor_id(int) \column{}\color{clGray}Kills specified actor'#13
+'\style{+B}\color{clNavy}MESSAGE\style{-B} text_id(int)\column{}\color{clGray}Displays specified text message'#13
+'\style{+B}\color{clNavy}MESSAGE_OBJ\style{-B} actor_id(int) text_id(int)   \color{clGray}Displays message said by specified actor'#13
+'\style{+B}\color{clNavy}MESSAGE_SENDELL\style{-B} \column{}\color{clGray}Displays message from Sendell (end of game)'#13
+'\style{+B}\color{clNavy}MIDI_OFF\style{-B} \column{}\color{clGray}Turns off current midi music being played'#13
//+'\style{+B}\color{clNavy}NOP\style{-B} \column{}\color{clGray}Does not do anything'#13
+'\style{+B}\color{clNavy}OBJ_COL\style{-B} switch(0 or 1)\column{}\color{clGray}Sets "can collide with objects" flag for the actor'#13
+'\style{+B}\color{clNavy}PLAY_CD_TRACK\style{-B} track_id(int)\column{}\color{clGray}Starts playing specified CD track'#13
+'\style{+B}\color{clNavy}PLAY_FLA\style{-B} fla_name(string)\column{}\color{clGray}Plays specified FLA animation'#13
+'\style{+B}\color{clNavy}PLAY_MIDI\style{-B} midi_id(int)\column{}\color{clGray}Starts playing specified midi music'#13
+'\style{+B}\color{clNavy}POS_POINT\style{-B} point_id(int)\column{}\color{clGray}Immediately moves the actor to specified Point'#13
+'\style{+B}\color{clNavy}PROJ_3D\style{-B} \column{}\color{clGray}Changes projection type to 3D (for ending credits)'#13
+'\style{+B}\color{clNavy}PROJ_ISO\style{-B} \column{}\color{clGray}Changes projection type to isometric'#13
+'\style{+B}\color{clBlack}RESTORE_L_TRACK\style{-B} \column{}\color{clGray}Makes the actor continue last track from track script'#13
+'\style{+B}\color{clNavy}SAY_MESSAGE\style{-B} text_id(int)\column{}\color{clGray}Displays specified message above the actor''s head'#13
+'\style{+B}\color{clNavy}SAY_MESSAGE_OBJ\style{-B} actor_id(int) text_id(int)   \color{clGray}Displays message above another actor''s head'#13
+'\style{+B}\color{clNavy}SET_DARK_PAL\style{-B} \column{}\color{clGray}Changes palette to the gray and dark one'#13
+'\style{+B}\color{clNavy}SET_DIR\style{-B} dir(int) [actor_id(int)]   \color{clGray}Sets specified Control Mode for the actor'#13
+'\style{+B}\color{clNavy}SET_DIR_OBJ\style{-B} actor_id(int) dir(int) [actor_id(int)]   \color{clGray}Sets Control Mode for another actor'#13
+'\style{+B}\color{clNavy}SET_DOOR_DOWN\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance down'#13
+'\style{+B}\color{clNavy}SET_DOOR_LEFT\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance left'#13
+'\style{+B}\color{clNavy}SET_DOOR_RIGHT\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance right'#13
+'\style{+B}\color{clNavy}SET_DOOR_UP\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance up'#13
+'\style{+B}\color{clNavy}SET_FLAG_CUBE\style{-B} flag_id(int) value(int)   \color{clGray}Sets specified cube flag to specified value'#13
+'\style{+B}\color{clNavy}SET_FLAG_GAME\style{-B} flag_id(int) value(int)   \color{clGray}Sets specified game flag to specified value'#13
+'\style{+B}\color{clNavy}SET_GRM\style{-B} fragment_id(int) and/or name(text)   \color{clGray}Turns specified Fragment visibility on'#13
+'\style{+B}\color{clNavy}SET_HOLO_POS\style{-B} pos_id(int)\column{}\color{clGray}Sets specified holomap arrow'#13
//+'\style{+B}\color{clNavy}SET_LIFE\style{-B} comp_name(string)\column{}\color{clGray}(untested) Probably does the same as SET_COMPORTMENT'#13
//+'\style{+B}\color{clNavy}SET_LIFE_OBJ\style{-B} actor_id(int) comp_name(string)   \color{clGray}(untested) Probably does the same as SET_COMPORTMENT_OBJ'#13
+'\style{+B}\color{clNavy}SET_LIFE_POINT_OBJ\style{-B} actor_id(int) value(int)   \color{clGray}Sets another actor''s life points to specified value'#13
+'\style{+B}\color{clNavy}SET_MAGIC_LEVEL\style{-B} level(int)\column{}\color{clGray}Sets hero''s magic level to specified value'#13
+'\style{+B}\color{clNavy}SET_NORMAL_PAL\style{-B} \column{}\color{clGray}Returns normal palette (set by SET_DARK_PAL)'#13
+'\style{+B}\color{clBlack}SET_TRACK\style{-B} [label_id(int) or name(text)]   \color{clGray}Starts execution of the actor''s TrackScript from specified LABEL'#13
+'\style{+B}\color{clBlack}SET_TRACK_OBJ\style{-B} actor_id(int) [label_id(int) or name(text)]   \color{clGray}Starts execution of another actor''s TrackScript'#13
+'\style{+B}\color{clNavy}SET_USED_INVENTORY\style{-B} inv_id(int)   \color{clGray}Enables auto-use of specified item'#13
+'\style{+B}\color{clBlack}STOP_L_TRACK\style{-B} \column{}\color{clGray}Stops execution of the Actor''s Track Script'#13
+'\style{+B}\color{clNavy}SUB_FUEL\style{-B} value(int)\column{}\color{clGray}Decreases amount of hero''s fuel by specified value'#13
+'\style{+B}\color{clNavy}SUB_LIFE_POINT_OBJ\style{-B} actor_id(int) value(int)   \color{clGray}Decreases another actor''s life points'#13
+'\style{+B}\color{clNavy}SUB_MAGIC_POINT\style{-B} value(int)\column{}\color{clGray}Decreases hero''s magic points by specified value'#13
+'\style{+B}\color{clNavy}SUICIDE\style{-B} \column{}\color{clGray}Kills the actor (like KILL_OBJ, but for current actor only)'#13
+'\style{+B}\color{clNavy}TEXT\style{-B} text_id(int)\column{}\color{clGray}Displays specified text at top right corner of the screen (ending credits)'#13
+'\style{+B}\color{clNavy}THE_END\style{-B} \column{}\color{clGray}Causes end of the game'#13
+'\style{+B}\color{clNavy}USE_ONE_LITTLE_KEY\style{-B} \column{}\color{clGray}Decreases the hero''s amount of little keys'#13
+'\style{+B}\color{clNavy}ZOOM\style{-B} set(0 or 1)\column{}\color{clGray}Enables(1) or disables(0) seneric zoom';

LifeScriptACCmdIn.Text:=
 ''#13
+'COMPORTEMENT'#13
+'END'#13
+'END_COMPORTEMENT'#13
+'END_LIFE'#13
+'RETURN'#13
+'SET_COMPORTEMENT'#13
+'SET_COMPORTEMENT_OBJ'#13
//+'LABEL'#13
//+'OFFSET'#13
+'IF'#13
+'ONEIF'#13
+'SWIF'#13
+'OR_IF'#13
+'ELSE'#13
+'ENDIF'#13
+''#13
+''#13
+'ADD_CHOICE'#13
+'ADD_FUEL'#13
+'ANIM'#13
+'ANIM_OBJ'#13
+'ANIM_SET'#13
+'ASK_CHOICE'#13
+'ASK_CHOICE_OBJ'#13
+'BETA'#13
+'BIG_MESSAGE'#13
+'BODY'#13
+'BODY_OBJ'#13
+'BRICK_COL'#13
+'BRUTAL_EXIT'#13
+'BULLE_OFF'#13
+'BULLE_ON'#13
+'CAM_FOLLOW'#13
+'CHANGE_CUBE'#13
+'CLEAR_TEXT'#13
+'CLR_HOLO_POS'#13
+'COMPORTEMENT_HERO'#13
+'EXPLODE_OBJ'#13
+'FALLABLE'#13
+'FADE_ALARM_PAL'#13
+'FADE_ALARM_RED'#13
+'FADE_PAL_ALARM'#13
+'FADE_PAL_RED'#13
+'FADE_RED_ALARM'#13
+'FADE_RED_PAL'#13
+'FOUND_OBJECT'#13
+'FULL_POINT'#13
+'GAME_OVER'#13
+'GIVE_BONUS'#13
+'GIVE_GOLD_PIECES'#13
+'GRM_OFF'#13
+'HIT_OBJ'#13
+'HOLOMAP_TRAJ'#13
+'INC_CHAPTER'#13
+'INC_CLOVER_BOX'#13
+'INIT_PINGOUIN'#13
+'INVISIBLE'#13
+'KILL_OBJ'#13
+'MESSAGE'#13
+'MESSAGE_OBJ'#13
+'MESSAGE_SENDELL'#13
+'MIDI_OFF'#13
//+'NOP'#13
+'OBJ_COL'#13
+'PLAY_CD_TRACK'#13
+'PLAY_FLA'#13
+'PLAY_MIDI'#13
+'POS_POINT'#13
+'PROJ_3D'#13
+'PROJ_ISO'#13
+'RESTORE_L_TRACK'#13
+'SAY_MESSAGE'#13
+'SAY_MESSAGE_OBJ'#13
+'SET_DARK_PAL'#13
+'SET_DIR'#13
+'SET_DIR_OBJ'#13
+'SET_DOOR_DOWN'#13
+'SET_DOOR_LEFT'#13
+'SET_DOOR_RIGHT'#13
+'SET_DOOR_UP'#13
+'SET_FLAG_CUBE'#13
+'SET_FLAG_GAME'#13
+'SET_GRM'#13
+'SET_HOLO_POS'#13
//+'SET_LIFE'#13
//+'SET_LIFE_OBJ'#13
+'SET_LIFE_POINT_OBJ'#13
+'SET_MAGIC_LEVEL'#13
+'SET_NORMAL_PAL'#13
+'SET_TRACK'#13
+'SET_TRACK_OBJ'#13
+'SET_USED_INVENTORY'#13
+'STOP_L_TRACK'#13
+'SUB_FUEL'#13
+'SUB_LIFE_POINT_OBJ'#13
+'SUB_MAGIC_POINT'#13
+'SUICIDE'#13
+'TEXT'#13
+'THE_END'#13
+'USE_ONE_LITTLE_KEY'#13
+'ZOOM';

LifeScriptACVarIt.Text:=
 '\style{+B}\color{clBlue}Variables:'#13
+'\style{+B}\color{clBlue}ACTION\style{-B} \column{}\color{clGray}Has value of 1 if player pressed "action" command'#13
+'\style{+B}\color{clBlue}ANIM\style{-B} \column{}\color{clGray}Animation id assigned to the actor'#13
+'\style{+B}\color{clBlue}ANIM_OBJ\style{-B} actor_id(int)\column{}\color{clGray}Animation id for another actor'#13
+'\style{+B}\color{clBlue}BODY\style{-B} \column{}\color{clGray}Body id assigned to the actor'#13
+'\style{+B}\color{clBlue}BODY_OBJ\style{-B} actor_id(int)\column{}\color{clGray}Body id for another actor'#13
+'\style{+B}\color{clBlue}CARRY_BY\style{-B} \column{}\color{clGray} (unknown parameters) Not tested'#13
+'\style{+B}\color{clBlue}CDROM\style{-B} \column{}\color{clGray} (unknown)'#13
+'\style{+B}\color{clBlue}CHAPTER\style{-B} \column{}\color{clGray}Current value of CHAPTER variable'#13
+'\style{+B}\color{clBlue}CHOICE\style{-B} \column{}\color{clGray}Text id selected in the last ASK_CHOICE command'#13
+'\style{+B}\color{clBlue}COL\style{-B} \column{}\color{clGray}Id of an actor that is colliding with the current actor'#13
+'\style{+B}\color{clBlue}COL_OBJ\style{-B} actor_id(int) \column{}\color{clGray}Id of an actor colliding with specified actor'#13
+'\style{+B}\color{clBlue}COMPORTEMENT_HERO\style{-B} \column{}\color{clGray}Current hero behaviour (0 = normal, 1 = athletic, etc.)'#13
+'\style{+B}\color{clBlue}CONE_VIEW\style{-B} \column{}\color{clGray}(unknown)'#13
+'\style{+B}\color{clBlue}DISTANCE\style{-B} actor_id(int) \column{}\color{clGray}Distance from specified actor'#13
+'\style{+B}\color{clBlue}DISTANCE_3D\style{-B} actor_id(int) \column{}\color{clGray}Distance in 3D from specified actor'#13
+'\style{+B}\color{clBlue}FLAG_CUBE\style{-B} flag_id(int)\column{}\color{clGray}Value of specified cube flag'#13
+'\style{+B}\color{clBlue}FLAG_GAME\style{-B} flag_id(int)\column{}\color{clGray}Value of specified game flag'#13
+'\style{+B}\color{clBlue}FUEL\style{-B} \column{}\color{clGray}Hero''s amount of fuel'#13
+'\style{+B}\color{clBlue}HIT_BY\style{-B} \column{}\color{clGray}Id of actor that hit the current actor'#13
+'\style{+B}\color{clBlue}L_TRACK\style{-B} \column{}\color{clGray}Id of LABEL currently executed by the actor'#13
+'\style{+B}\color{clBlue}L_TRACK_OBJ\style{-B} actor_id(int)   \color{clGray}Id of LABEL executed by another actor'#13
+'\style{+B}\color{clBlue}LIFE_POINT\style{-B} \column{}\color{clGray}Number of life points of the actor'#13
+'\style{+B}\color{clBlue}LIFE_POINT_OBJ\style{-B} \column{}\color{clGray}Number of life points of another actor'#13
+'\style{+B}\color{clBlue}NB_GOLD_PIECES\style{-B} \column{}\color{clGray}Hero''s amount of money'#13
+'\style{+B}\color{clBlue}NB_LITTLE_KEYS\style{-B} \column{}\color{clGray}Hero''s number of little keys'#13
+'\style{+B}\color{clBlue}USE_INVENTORY\style{-B} obj_id(int) \column{}\color{clGray}Has value of 1 if player uses specified inventory item'#13
+'\style{+B}\color{clBlue}ZONE\style{-B} \column{}\color{clGray}Id of zone the actor is currently in'#13
+'\style{+B}\color{clBlue}ZONE_OBJ\style{-B} actor_id(int) \column{}\color{clGray}Id of zone that another actor is in';

LifeScriptACVarIn.Text:=
 ''#13
+'ACTION'#13
+'ANIM'#13
+'ANIM_OBJ'#13
+'BODY'#13
+'BODY_OBJ'#13
+'CARRY_BY'#13
+'CDROM'#13
+'CHAPTER'#13
+'CHOICE'#13
+'COL'#13
+'COL_OBJ'#13
+'CONE_VIEW'#13
+'COMPORTEMENT_HERO'#13
+'DISTANCE'#13
+'DISTANCE_3D'#13
+'FLAG_CUBE'#13
+'FLAG_GAME'#13
+'FUEL'#13
+'HIT_BY'#13
+'L_TRACK'#13
+'L_TRACK_OBJ'#13
+'LIFE_POINT'#13
+'LIFE_POINT_OBJ'#13
+'NB_GOLD_PIECES'#13
+'NB_LITTLE_KEYS'#13
+'USE_INVENTORY'#13
+'ZONE'#13
+'ZONE_OBJ';

LifeScriptACBehIt.Text:=
 '\style{+B}\color{clOlive}Behaviours:'#13
+'\style{+B}\color{clOlive}NORMAL'#13
+'\style{+B}\color{clOlive}ATHLETIC'#13
+'\style{+B}\color{clOlive}AGGRESSIVE'#13
+'\style{+B}\color{clOlive}DISCRETE';

LifeScriptACBehIn.Text:=
 ''#13
+'NORMAL'#13
+'ATHLETIC'#13
+'AGGRESSIVE'#13
+'DISCRETE';

LifeScriptACDirIt.Text:=
 '\style{+B}\color{clOlive}Control Modes:'#13
+'\style{+B}\color{clOlive}NO_MOVE\style{-B}'#13
+'\style{+B}\color{clOlive}MANUAL\style{-B} \column{}\color{clGray}Player will take control over the Actor'#13
+'\style{+B}\color{clOlive}FOLLOW\style{-B} actor_id(int) \column{}\color{clGray}The Actor will follow another specified Actor'#13
+'\style{+B}\color{clOlive}TRACK\style{-B} \column{}\color{clGray}The Actor will follow a Track path'#13
//+'\style{+B}\color{clOlive}FOLLOW_2\style{-B} actor_id(int) \column{}\color{clGray}Unknown'#13
//+'\style{+B}\color{clOlive}TRACK_ATTACK\style{-B} \column{}\color{clGray}The Actor will attack along a Track path'#13
+'\style{+B}\color{clOlive}SAME_XZ\style{-B} \column{}\color{clGray}The Actor will move vertically only (won''t fall)'#13
+'\style{+B}\color{clOlive}RANDOM\style{-B} \column{}\color{clGray}The Actor will move in random ways';

LifeScriptACDirIn.Text:=
 ''#13
+'NO_MOVE'#13
+'MANUAL'#13
+'FOLLOW'#13
+'TRACK'#13
//+'FOLLOW_2'#13
//+'TRACK_ATTACK'#13
+'SAME_XZ'#13
+'RANDOM';
end;

procedure TfmScriptEd.ModACLba1Comp();
var a: Integer;
    sf: String;
begin
  for a:= 0 to High(Life1ModsComp) do begin
    sf:= Life1DecompList[Life1ModsComp[a].id];
    LifeScriptACCmdIt.Text:=
      StringReplace(LifeScriptACCmdIt.Text, sf, Life1ModsComp[a].name, []); //rfReplaceAll, rfIgnoreCase
    LifeScriptACCmdIn.Text:=
      StringReplace(LifeScriptACCmdIn.Text, sf, Life1ModsComp[a].name, []);
  end;

  for a:= 0 to High(Var1ModsComp) do begin
    sf:= Var1DecompList[Var1ModsComp[a].id];
    LifeScriptACVarIt.Text:=
      StringReplace(LifeScriptACVarIt.Text, sf, Var1ModsComp[a].name, []);
    LifeScriptACVarIn.Text:=
      StringReplace(LifeScriptACVarIn.Text, sf, Var1ModsComp[a].name, []);
  end;
end;

procedure TfmScriptEd.ModACLba1Eng(CompModded: Boolean);
var a, b, id: Integer;
    sf: String;
begin
  for a:= 0 to High(Track1ModsEng) do begin
    sf:= Track1DecompList[Track1ModsEng[a].id];
    TrackScriptACIt.Text:=
      StringReplace(TrackScriptACIt.Text, sf, Track1ModsEng[a].name, []); //rfReplaceAll, rfIgnoreCase
    TrackScriptACIn.Text:=
      StringReplace(TrackScriptACIn.Text, sf, Track1ModsEng[a].name, []);
  end;

  if not CompModded then begin
    for a:= 0 to High(Life1ModsEng) do begin
      sf:= Life1DecompList[Life1ModsEng[a].id];
      LifeScriptACCmdIt.Text:=
        StringReplace(LifeScriptACCmdIt.Text, sf, Life1ModsEng[a].name, []); //rfReplaceAll, rfIgnoreCase
      LifeScriptACCmdIn.Text:=
        StringReplace(LifeScriptACCmdIn.Text, sf, Life1ModsEng[a].name, []);
    end;
  end else begin
    //If the COMPORT(E)MENT is modded, some macro names are different
    for a:= 0 to High(Life1ModsEng) do begin
      id:= Life1ModsEng[a].id;
      sf:= Life1DecompList[id];
      for b:= 0 to High(Life1ModsComp) do
        if Life1ModsComp[b].id = id then begin
          sf:= Life1ModsComp[b].name;
          break;
        end;
      LifeScriptACCmdIt.Text:=
        StringReplace(LifeScriptACCmdIt.Text, sf, Life1ModsEng[a].name, []);
      LifeScriptACCmdIn.Text:=
        StringReplace(LifeScriptACCmdIn.Text, sf, Life1ModsEng[a].name, []);
    end;
  end;

  if not CompModded then begin
    for a:= 0 to High(Var1ModsEng) do begin
      sf:= Var1DecompList[Var1ModsEng[a].id];
      LifeScriptACVarIt.Text:=
        StringReplace(LifeScriptACVarIt.Text, sf, Var1ModsEng[a].name, []);
      LifeScriptACVarIn.Text:=
        StringReplace(LifeScriptACVarIn.Text, sf, Var1ModsEng[a].name, []);
    end;
  end else begin
    for a:= 0 to High(Var1ModsEng) do begin
      id:= Var1ModsEng[a].id;
      sf:= Var1DecompList[id];
      for b:= 0 to High(Var1ModsComp) do
        if Var1ModsComp[b].id = id then begin
          sf:= Var1ModsComp[b].name;
          break;
        end;
      LifeScriptACVarIt.Text:=
        StringReplace(LifeScriptACVarIt.Text, sf, Var1ModsEng[a].name, []);
      LifeScriptACVarIn.Text:=
        StringReplace(LifeScriptACVarIn.Text, sf, Var1ModsEng[a].name, []);
    end;
  end;
end;