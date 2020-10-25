procedure TfmScriptEd.InitACLba2Org();
begin
TrackScriptACIt.Text:=
 '\style{+B}\color{clGreen}Control statements:'#13
+'\style{+B}\color{clGreen}END\style{-B} \column{}\color{clGray}Marks end of the script'#13
+'\style{+B}\color{clGreen}LABEL\style{-B} label_id(int) [name(text)]   \color{clGray}Marks palce in the script to jump to with GOTO command'#13
+'\style{+B}\color{clGreen}GOTO\style{-B} label_id(int) \style{+B}or\style{-B} name(text)   \color{clGray}Jumps execution of the script to specified LABEL'#13
+'\style{+B}\color{clBlack}REMP\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlack}STOP\style{-B} \column{}\color{clGray}Stops execution of the TrackScript'#13
+#13
+'\style{+B}\color{clNavy}Commands:'#13
+'\style{+B}\color{clNavy}AFF_TIMER\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}ANGLE\style{-B} value(int)\column{}\color{clGray}Makes the actor turn to specified angle'#13
+'\style{+B}\color{clNavy}ANGLE_RND\style{-B} value(int)\column{}\color{clGray}Makes the actor turn in random direction by about 90 degrees'#13
+'\style{+B}\color{clNavy}ANIM\style{-B} anim_id(int)\column{}\color{clGray}Sets specified animation for the actor'#13
+'\style{+B}\color{clNavy}BACKGROUND\style{-B} set(0 or 1)\column{}\color{clGray}Sets the actor to be a backgroud actor (1) or not (0)'#13
+'\style{+B}\color{clNavy}BETA\style{-B} value(int)\column{}\color{clGray}Makes the actor turn to specified angle without animation'#13
+'\style{+B}\color{clNavy}BODY\style{-B} body_id(int)\column{}\color{clGray}Sets specified body for the actor'#13
+'\style{+B}\color{clNavy}CLOSE\style{-B} \column{}\color{clGray}Closes the door actor'#13
+'\style{+B}\color{clNavy}DECALAGE\style{-B} value(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}DO\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}FACE_HERO\style{-B} \column{}\color{clGray}Makes the actor turn to look at the hero'#13
+'\style{+B}\color{clNavy}FREQUENCY\style{-B} value(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}GOTO_POINT\style{-B} point_id(int)   \color{clGray}Makes the 3D actor go to specified Point'#13
+'\style{+B}\color{clNavy}GOTO_POINT_3D\style{-B} point_id(int)   \color{clGray}Makes the Sprite actor move to specified Point'#13
+'\style{+B}\color{clNavy}GOTO_SYM_POINT\style{-B} point_id(int)   \color{clGray}Makes the actor go backward to specified Point'#13
+'\style{+B}\color{clNavy}NO_BODY\style{-B} \column{}\color{clGray}Makes the actor use no body (invisible)'#13
+'\style{+B}\color{clNavy}OPEN_DOWN\style{-B} distance(int)   \color{clGray}Moves the door actor down by the specified distance'#13
+'\style{+B}\color{clNavy}OPEN_LEFT\style{-B} distance(int)   \color{clGray}Moves the door actor left by the specified distance'#13
+'\style{+B}\color{clNavy}OPEN_RIGHT\style{-B} distance(int)   \color{clGray}Moves the door actor right by the specified distance'#13
+'\style{+B}\color{clNavy}OPEN_UP\style{-B} distance(int)\column{}\color{clGray}Moves the door actor up by the specified distance'#13
+'\style{+B}\color{clNavy}PLAY_ACF\style{-B} smk_name(string)   \color{clGray}Plays spiecified SMK animation'#13
+'\style{+B}\color{clNavy}POS_POINT\style{-B} point_id(int)\column{}\color{clGray}Immediately moves the actor to specified Point'#13
+'\style{+B}\color{clNavy}REPEAT_SAMPLE\style{-B} sample_id(int)   \color{clGray}Sets number of repeats for next SIMPLE_SAMPLE command'#13
+'\style{+B}\color{clNavy}SAMPLE\style{-B} sample_id(int)\column{}\color{clGray}Plays specified sample once'#13
+'\style{+B}\color{clNavy}SAMPLE_ALWAYS\style{-B} sample_id(int)   \color{clGray}Plays specified sample continuously'#13
+'\style{+B}\color{clNavy}SAMPLE_RND\style{-B} sample_id(int)   \color{clGray}Plays specified sample at a random pitch'#13
+'\style{+B}\color{clNavy}SAMPLE_STOP\style{-B} sample_id(int)   \color{clGray}Stops playing sample started with SAMPLE_ALWAYS command'#13
+'\style{+B}\color{clNavy}SET_FRAME\style{-B} frame_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_FRAME_3DS\style{-B} frame_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_START_3DS\style{-B} frame_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_END_3DS\style{-B} frame_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}START_ANIM_3DS\style{-B} frame_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}STOP_ANIM_3DS\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SIMPLE_SAMPLE\style{-B} sample_id(int)   \color{clGray}Plays sample for number of times specified with REPEAT_SAMPLE'#13
+'\style{+B}\color{clNavy}SPEED\style{-B} value(int)\column{}\color{clGray}Sets movement speed of the actor'#13
+'\style{+B}\color{clNavy}SPRITE\style{-B} value(int)\column{}\color{clGray}Sets sprite for the actor'#13
+'\style{+B}\color{clNavy}VOLUME\style{-B} sprite_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}WAIT_ANIM\style{-B} \column{}\color{clGray}Pauses script execution until current animation finishes playing'#13
+'\style{+B}\color{clNavy}WAIT_ANIM_3DS\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}WAIT_FRAME_3DS\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}WAIT_DOOR\style{-B} \column{}\color{clGray}Pauses script execution until door finishes opening or closing'#13
+'\style{+B}\color{clNavy}WAIT_NB_ANIM\style{-B} count(int)   \color{clGray}Pauses execution until animation plays for specified number of times'#13
+'\style{+B}\color{clNavy}WAIT_NB_DIZIEME\style{-B} time(int)   \color{clGray}Pauses script for a number of decaseconds'#13
+'\style{+B}\color{clNavy}WAIT_NB_DIZIEME_RND\style{-B} time(int)   \color{clGray}Pauses script for a random number of decaseconds'#13
+'\style{+B}\color{clNavy}WAIT_NB_SECOND\style{-B} time(int)   \color{clGray}Pauses script for a number of seconds'#13
+'\style{+B}\color{clNavy}WAIT_NB_SECOND_RND\style{-B} time(int)   \color{clGray}Pauses script for a random number of seconds';

TrackScriptACIn.Text:=
 ''#13
+'END'#13
+'LABEL'#13
+'GOTO'#13
+'REMP'#13
+'STOP'#13
+''#13
+''#13
+'AFF_TIMER'#13
+'ANGLE'#13
+'ANGLE_RND'#13
+'ANIM'#13
+'BACKGROUND'#13
+'BETA'#13
+'BODY'#13
+'CLOSE'#13
+'DECALAGE'#13
+'DO'#13
+'FACE_HERO'#13
+'FREQUENCY'#13
+'GOTO_POINT'#13
+'GOTO_POINT_3D'#13
+'GOTO_SYM_POINT'#13
+'NO_BODY'#13
+'OPEN_DOWN'#13
+'OPEN_LEFT'#13
+'OPEN_RIGHT'#13
+'OPEN_UP'#13
+'PLAY_ACF'#13
+'POS_POINT'#13
+'REPEAT_SAMPLE'#13
+'SAMPLE'#13
+'SAMPLE_ALWAYS'#13
+'SAMPLE_RND'#13
+'SAMPLE_STOP'#13
+'SET_FRAME'#13
+'SET_FRAME_3DS'#13
+'SET_START_3DS'#13
+'SET_END_3DS'#13
+'START_ANIM_3DS'#13
+'STOP_ANIM_3DS'#13
+'SIMPLE_SAMPLE'#13
+'SPEED'#13
+'SPRITE'#13
+'VOLUME'#13
+'WAIT_ANIM'#13
+'WAIT_ANIM_3DS'#13
+'WAIT_FRAME_3DS'#13
+'WAIT_DOOR'#13
+'WAIT_NB_ANIM'#13
+'WAIT_NB_DIZIEME'#13
+'WAIT_NB_DIZIEME_RND'#13
+'WAIT_NB_SECOND'#13
+'WAIT_NB_SECOND_RND';

LifeScriptACCmdIt.Text:=
 '\style{+B}\color{clGreen}Control statements:'#13
+'\style{+B}\color{clGreen}COMPORTEMENT\style{-B} name(string)\column{}\color{clGray}Begins comportment block'#13
+'\style{+B}\color{clGreen}END\style{-B} \column{}\color{clGray}Marks the end of the current LifeScript'#13
+'\style{+B}\color{clGreen}END_COMPORTEMENT\style{-B} \column{}\color{clGray}Marks the end of a COMPORTMENT block'#13
+'\style{+B}\color{clGreen}END_LIFE\style{-B} \column{}\color{clGray}Terminates the Actor''s LifeScript execution'#13
+'\style{+B}\color{clGreen}RETURN\style{-B} \column{}\color{clGray}Moves script execution to the beginning of the current COMPORTMENT'#13
+'\style{+B}\color{clGreen}SET_COMPORTEMENT\style{-B} name(string)   \color{clGray}Moves LifeScript execution to specified COMPORTMENT'#13
+'\style{+B}\color{clGreen}SET_COMPORTEMENT_OBJ\style{-B} actor_id(int) name(string)   \color{clGray}Moves LifeScript execution of another actor'#13
+'\style{+B}IF\style{-B} \column{}\color{clGray}Checks a condition and executes block below if true'#13
+'\style{+B}ONEIF\style{-B} \column{}\color{clGray}Works like IF, but is executed only once'#13
+'\style{+B}SWIF\style{-B} \column{}\color{clGray}(undested) Not known'#13
+'\style{+B}OR_IF\style{-B} \column{}\color{clGray}Used to make multiple conditions; must be put before IF'#13
+'\style{+B}AND_IF\style{-B} \column{}\color{clGray}Used to make multiple conditions; must be put before IF'#13
+'\style{+B}ELSE\style{-B} \column{}\color{clGray}Executes block below it if IF condition is false'#13
+'\style{+B}ENDIF\style{-B} \column{}\color{clGray}Marks end of the conditional block'#13
+'\style{+B}SWITCH\style{-B} \column{}\color{clGray}Tests Variable against multiple values'#13
+'\style{+B}CASE\style{-B} \column{}\color{clGray}Marks one test within SWITCH block'#13
+'\style{+B}OR_CASE\style{-B} \column{}\color{clGray}Multiple CASE conditions; must be put before CASE'#13
+'\style{+B}DEFAULT\style{-B} \column{}\color{clGray}Marks default case for SWITCH block'#13
+'\style{+B}BREAK\style{-B} \column{}\color{clGray}Marks end of CASE block'#13
+'\style{+B}END_SWITCH\style{-B} \column{}\color{clGray}Marks end of SWITCH block'#13
+''#13
+'\style{+B}\color{clNavy}Commands:'#13
+'\style{+B}\color{clNavy}ACTION\style{-B}\column{}\color{clGray}Performs the \style{+I}ACTION\style{-I} command'#13
+'\style{+B}\color{clNavy}ADD_CHOICE\style{-B} text_id(int)\column{}\color{clGray}Adds choice to the list'#13
+'\style{+B}\color{clNavy}ADD_FUEL\style{-B} count(int)\column{}\color{clGray}Adds specified amount of fuel to the inventory'#13
+'\style{+B}\color{clNavy}ADD_GOLD_PIECES\style{-B} value(int)   \color{clGray}Adds to hero''s gold pieces'#13
+'\style{+B}\color{clNavy}ADD_LIFE_POINT_OBJ\style{-B} actor_id(int) value(int)   \color{clGray}Adds a number of life points'#13
+'\style{+B}\color{clNavy}ADD_MESSAGE\style{-B} text_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}ADD_MESSAGE_OBJ\style{-B} actor_id(int) text_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}ADD_VAR_CUBE\style{-B} var_id(int) value(int)   \color{clGray}Adds value to a cube var'#13
+'\style{+B}\color{clNavy}ADD_VAR_GAME\style{-B} var_id(int) value(int)   \color{clGray}Adds value to a game var'#13
+'\style{+B}\color{clNavy}ANIM\style{-B} anim_id(int)\column{}\color{clGray}Sets specified animation for the actor'#13
+'\style{+B}\color{clNavy}ANIM_OBJ\style{-B} actor_id(int) anim_id(int)   \color{clGray}Sets animation for another actor'#13
+'\style{+B}\color{clNavy}ANIM_SET\style{-B} anim_id(int)\column{}\color{clGray}Sets specified animation without a transition'#13
+'\style{+B}\color{clNavy}ANIM_TEXTURE\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}ASK_CHOICE\style{-B} text_id(int)\column{}\color{clGray}Displays choice list made of items set by ADD_CHOICE'#13
+'\style{+B}\color{clNavy}ASK_CHOICE_OBJ\style{-B} actor_id(int) text_id(int)   \color{clGray}Displays choice list asked by another actor'#13
+'\style{+B}\color{clNavy}BACKGROUND\style{-B} switch(0 or 1)\column{}\color{clGray}Controls redrawing of the Actor'#13
+'\style{+B}\color{clNavy}BETA\style{-B} angle(int)\column{}\color{clGray}Immediately sets specified angle for the actor'#13
+'\style{+B}\color{clNavy}BODY\style{-B} body_id(int) \column{}\color{clGray}Sets specified body for the actor'#13
+'\style{+B}\color{clNavy}BODY_OBJ\style{-B} actor_id(int) body_id(int)   \color{clGray}Sets body for another actor'#13
+'\style{+B}\color{clNavy}BRICK_COL\style{-B} switch(0 or 1)\column{}\color{clGray}Sets "can collide with bricks" flag for the actor'#13
+'\style{+B}\color{clNavy}BRUTAL_EXIT\style{-B} \column{}\color{clGray}Exits to the main game menu'#13
+'\style{+B}\color{clNavy}BULLE\style{-B} switch(0 or 1) \column{}\color{clGray}Turns dialogue balloons on/off'#13
+'\style{+B}\color{clNavy}CAM_FOLLOW\style{-B} actor_id(int)\column{}\color{clGray}Makes the camera follow specified actor'#13
+'\style{+B}\color{clNavy}CAMERA_CENTER\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}CHANGE_CUBE\style{-B} scene_id(int)\column{}\color{clGray}Changes to another scene'#13
+'\style{+B}\color{clNavy}CINEMA_MODE\style{-B} switch(0 or 1)\column{}\color{clGray}Turns cinema mode (wide screen) on or off'#13
+'\style{+B}\color{clNavy}CLR_HOLO_POS\style{-B} pos_id(int)\column{}\color{clGray}Clears specified holomap position'#13
+'\style{+B}\color{clNavy}COMPORTEMENT_HERO\style{-B} behaviour   \color{clGray}Sets hero behaviour'#13
+'\style{+B}\color{clNavy}DEBUG\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}DEBUG_OBJ\style{-B} obj_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}ECHELLE\style{-B} ???(int) ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}ECLAIR\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}END_MESSAGE\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}END_MESSAGE_OBJ\style{-B} obj_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}ESCALATOR\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}FADE_TO_PAL\style{-B} palette_id(int)\column{}\color{clGray}Fades to a palette'#13
+'\style{+B}\color{clNavy}FALLABLE\style{-B} switch(0 or 1) \column{}\color{clGray}Sets "can fall" flag for the actor'#13
+'\style{+B}\color{clNavy}FLOW_OBJ\style{-B} obj_id(int) ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}FLOW_POINT\style{-B} point_id(int) ???(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}FOUND_OBJECT\style{-B} obj_id(int)\column{}\color{clGray}Displays "found object" message'#13
+'\style{+B}\color{clNavy}FULL_POINT\style{-B} \column{}\color{clGray}Replenishes life and magic points of the actor'#13
+'\style{+B}\color{clNavy}GAME_OVER\style{-B} \column{}\color{clGray}Displays "game over" text and ends the game'#13
+'\style{+B}\color{clNavy}GIVE_BONUS\style{-B} ddis(0 or 1)\column{}\color{clGray}Makes the actor "pop out" the bonus defined in actor settings'#13
+'\style{+B}\color{clNavy}GIVE_GOLD_PIECES\style{-B} amount(int)   \color{clGray}Makes the hero spend specified amount of money'#13
+'\style{+B}\color{clNavy}HIT_OBJ\style{-B} actor_id(int) damage(int)   \color{clGray}Makes the specified Actor take damage'#13
+'\style{+B}\color{clNavy}IMPACT_OBJ\style{-B} obj_id(int) ???(int) ???(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}IMPACT_POINT\style{-B} point_id(int) ???(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}INC_CHAPTER\style{-B} \column{}\color{clGray}Increases the CHAPTER variable by one'#13
+'\style{+B}\color{clNavy}INC_CLOVER_BOX\style{-B} \column{}\color{clGray}Increases the number of hero''s clover boxes'#13
+'\style{+B}\color{clNavy}INIT_BUGGY\style{-B} ???(int)\column{}\color{clGray}Initializes the car'#13
+'\style{+B}\color{clNavy}INVERSE_BETA\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}INVISIBLE\style{-B} switch(0 or 1)\column{}\color{clGray}Makes the actor invisible (1) or visible (0)'#13
+'\style{+B}\color{clNavy}KILL_OBJ\style{-B} actor_id(int) \column{}\color{clGray}Kills specified actor'#13
+'\style{+B}\color{clNavy}MEMO_ARDOISE\style{-B} page_id(int)\column{}\color{clGray}Enables slate image'#13
+'\style{+B}\color{clNavy}MESSAGE\style{-B} text_id(int)\column{}\color{clGray}Displays specified text message'#13
+'\style{+B}\color{clNavy}MESSAGE_OBJ\style{-B} actor_id(int) text_id(int)   \color{clGray}Displays message said by specified actor'#13
+'\style{+B}\color{clNavy}MESSAGE_ZOE\style{-B} text_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}NEW_SAMPLE\style{-B} ???(int) ???(int) ???(int) ???(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}NO_BODY\style{-B}\column{}\color{clGray}Hides the Actor'#13
+'\style{+B}\color{clNavy}NO_CHOC\style{-B} switch(0 or 1)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}OBJ_COL\style{-B} switch(0 or 1)\column{}\color{clGray}Sets "can collide with objects" flag for the actor'#13
+'\style{+B}\color{clNavy}PALETTE\style{-B} palette_id(int)\column{}\color{clGray}Selects another palette'#13
+'\style{+B}\color{clNavy}PARM_SAMPLE\style{-B} ???(int) ???(int) ???(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}PCX\style{-B} pcx_id(int)\column{}\color{clGray}Displays fullscreen image'#13
+'\style{+B}\color{clNavy}PCX_MESS_OBJ\style{-B} obj_id(int) pcx_id(int) text_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}PLAY_MUSIC\style{-B} music_id(int)\column{}\color{clGray}Plays music'#13
+'\style{+B}\color{clNavy}PLAY_ACF\style{-B} smk_name(string)\column{}\color{clGray}Plays specified SMK animation'#13
+'\style{+B}\color{clNavy}PLUIE\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}POPCORN\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}POS_OBJ_AROUND\style{-B} obj_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}POS_POINT\style{-B} point_id(int)\column{}\color{clGray}Immediately moves the actor to specified Point'#13
+'\style{+B}\color{clNavy}REMP\style{-B}\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}REPEAT_SAMPLE\style{-B} sample_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}RESTORE_COMPORTEMENT\style{-B}   \color{clGray}Restores saved COMPORTMENT'#13
+'\style{+B}\color{clNavy}RESTORE_COMPORTEMENT_OBJ\style{-B} obj_id(int)   \color{clGray}Restores saved COMPORTMENT of another Actor'#13
+'\style{+B}\color{clNavy}RESTORE_HERO\style{-B}\column{}\color{clGray}Restores saved hero state'#13
+'\style{+B}\color{clBlack}RESTORE_L_TRACK\style{-B} \column{}\color{clGray}Runs Track Script of the Actor'#13
+'\style{+B}\color{clBlack}RESTORE_L_TRACK_OBJ\style{-B} obj_id(int)   \color{clGray}Runs Track Script of another Actor'#13
+'\style{+B}\color{clNavy}SAMPLE\style{-B} sample_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SAMPLE_RND\style{-B} sample_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SAMPLE_ALWAYS\style{-B} sample_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SAMPLE_STOP\style{-B} sample_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SAVE_COMPORTEMENT\style{-B}\column{}\color{clGray}Saves current COMPORTMENT'#13
+'\style{+B}\color{clNavy}SAVE_COMPORTEMENT_OBJ\style{-B} obj_id(int)   \color{clGray}Saves comportement of another Actor'#13
+'\style{+B}\color{clNavy}SAVE_HERO\style{-B}\column{}\color{clGray}Saves hero state'#13
+'\style{+B}\color{clNavy}SET_ANIM_DIAL\style{-B} anim_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_ARMURE\style{-B} ???(int)\column{}\color{clGray}Sets armour'#13
+'\style{+B}\color{clNavy}SET_ARMURE_OBJ\style{-B} actor_id(int) ???(int)   \color{clGray}Sets armour for another Actor'#13
+'\style{+B}\color{clNavy}SET_CAMERA\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_CHANGE_CUBE\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_DIR\style{-B} dir(int) [actor_id(int)]   \color{clGray}Sets specified Control Mode for the actor'#13
+'\style{+B}\color{clNavy}SET_DIR_OBJ\style{-B} actor_id(int) dir(int) [actor_id(int)]   \color{clGray}Sets Control Mode for another actor'#13
+'\style{+B}\color{clNavy}SET_DOOR_DOWN\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance down'#13
+'\style{+B}\color{clNavy}SET_DOOR_LEFT\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance left'#13
+'\style{+B}\color{clNavy}SET_DOOR_RIGHT\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance right'#13
+'\style{+B}\color{clNavy}SET_DOOR_UP\style{-B} dist(int)\column{}\color{clGray}Moves the door actor by specified distance up'#13
+'\style{+B}\color{clNavy}SET_FRAME\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_FRAME_3DS\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_GRM\style{-B} fragment_id(int) switch(0 or 1) and/or name(text)   \color{clGray}Shows/hides a Fragment'#13
+'\style{+B}\color{clNavy}SET_HIT_ZONE\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_HOLO_POS\style{-B} pos_id(int)\column{}\color{clGray}Sets specified holomap arrow'#13
+'\style{+B}\color{clNavy}SET_LIFE_POINT_OBJ\style{-B} actor_id(int) value(int)   \color{clGray}Sets another actor''s life points to specified value'#13
+'\style{+B}\color{clNavy}SET_MAGIC_LEVEL\style{-B} level(int)\column{}\color{clGray}Sets hero''s magic level to specified value'#13
+'\style{+B}\color{clNavy}SET_RAIL\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}SET_SPRITE\style{-B} sprite_id(int)\column{}\color{clGray}Sets a new sprite'#13
+'\style{+B}\color{clBlack}SET_TRACK\style{-B} [label_id(int) or name(text)]   \color{clGray}Starts execution of the actor''s TrackScript from specified LABEL'#13
+'\style{+B}\color{clBlack}SET_TRACK_OBJ\style{-B} actor_id(int) [label_id(int) or name(text)]   \color{clGray}Starts execution of another actor''s TrackScript'#13
+'\style{+B}\color{clNavy}SET_USED_INVENTORY\style{-B} inv_id(int)   \color{clGray}Enables auto-use of specified item'#13
+'\style{+B}\color{clNavy}SET_VAR_CUBE\style{-B} var_id(int) value(int)   \color{clGray}Sets a cube var to specified value'#13
+'\style{+B}\color{clNavy}SET_VAR_GAME\style{-B} var_id(int) value(int)   \color{clGray}Sets a game var to specified value'#13
+'\style{+B}\color{clNavy}SHADOW_OBJ\style{-B} actor_id(int) switch(0 or 1)   \color{clGray}Turns Actor shadow on or off'#13
+'\style{+B}\color{clNavy}SPY\style{-B} ???(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clNavy}STATE_INVENTORY\style{-B} obj_id(int) ???(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clBlack}STOP_L_TRACK\style{-B} \column{}\color{clGray}Stops execution of the Actor''s Track Script'#13
+'\style{+B}\color{clBlack}STOP_L_TRACK_OBJ\style{-B} obj_id(int)   \color{clGray}Stops another Actor''s Track Script'#13
+'\style{+B}\color{clNavy}SUB_FUEL\style{-B} value(int)\column{}\color{clGray}Decreases amount of hero''s fuel by specified value'#13
+'\style{+B}\color{clNavy}SUB_LIFE_POINT_OBJ\style{-B} actor_id(int) value(int)   \color{clGray}Decreases another actor''s life points'#13
+'\style{+B}\color{clNavy}SUB_MAGIC_POINT\style{-B} value(int)\column{}\color{clGray}Decreases hero''s magic points by specified value'#13
+'\style{+B}\color{clNavy}SUB_VAR_CUBE\style{-B} var_id(int) value(int)   \color{clGray}Subtracts value from a cube var'#13
+'\style{+B}\color{clNavy}SUB_VAR_GAME\style{-B} var_id(int) value(int)   \color{clGray}Subtracts value from a game var'#13
+'\style{+B}\color{clNavy}SUICIDE\style{-B} \column{}\color{clGray}Kills the actor (like KILL_OBJ, but for current actor only)'#13
+'\style{+B}\color{clNavy}THE_END\style{-B} \column{}\color{clGray}Causes end of the game'#13
+'\style{+B}\color{clNavy}TRACK_TO_VAR_GAME\style{-B} var_id(int)   \color{clGray}Saves current track as a game var'#13
+'\style{+B}\color{clNavy}VAR_GAME_TO_TRACK\style{-B} var_id(int)   \color{clGray}Restores track from a game var'#13
+'\style{+B}\color{clNavy}USE_ONE_LITTLE_KEY\style{-B} \column{}\color{clGray}Decreases the hero''s amount of little keys';

LifeScriptACCmdIn.Text:=
 ''#13
+'COMPORTMEMENT'#13
+'END'#13
+'END_COMPORTEMENT'#13
+'END_LIFE'#13
+'RETURN'#13
+'SET_COMPORTEMENT'#13
+'SET_COMPORTEMENT_OBJ'#13
+'IF'#13
+'ONEIF'#13
+'SWIF'#13
+'OR_IF'#13
+'AND_IF'#13
+'ELSE'#13
+'ENDIF'#13
+'SWITCH'#13
+'CASE'#13
+'OR_CASE'#13
+'DEFAULT'#13
+'BREAK'#13
+'END_SWITCH'#13
+''#13
+''#13
+'ACTION'#13
+'ADD_CHOICE'#13
+'ADD_FUEL'#13
+'ADD_GOLD_PIECES'#13
+'ADD_LIFE_POINT_OBJ'#13
+'ADD_MESSAGE'#13
+'ADD_MESSAGE_OBJ'#13
+'ADD_VAR_CUBE'#13
+'ADD_VAR_GAME'#13
+'ANIM'#13
+'ANIM_OBJ'#13
+'ANIM_SET'#13
+'ANIM_TEXTURE'#13
+'ASK_CHOICE'#13
+'ASK_CHOICE_OBJ'#13
+'BACKGROUND'#13
+'BETA'#13
+'BODY'#13
+'BODY_OBJ'#13
+'BRICK_COL'#13
+'BRUTAL_EXIT'#13
+'BULLE'#13
+'CAM_FOLLOW'#13
+'CAMERA_CENTER'#13
+'CHANGE_CUBE'#13
+'CINEMA_MODE'#13
+'CLR_HOLO_POS'#13
+'COMPORTEMENT_HERO'#13
+'DEBUG\style'#13
+'DEBUG_OBJ'#13
+'ECHELLE'#13
+'ECLAIR'#13
+'END_MESSAGE'#13
+'END_MESSAGE_OBJ'#13
+'ESCALATOR'#13
+'FADE_TO_PAL'#13
+'FALLABLE'#13
+'FLOW_OBJ'#13
+'FLOW_POINT'#13
+'FOUND_OBJECT'#13
+'FULL_POINT'#13
+'GAME_OVER'#13
+'GIVE_BONUS'#13
+'GIVE_GOLD_PIECES'#13
+'HIT_OBJ'#13
+'IMPACT_OBJ'#13
+'IMPACT_POINT'#13
+'INC_CHAPTER'#13
+'INC_CLOVER_BOX'#13
+'INIT_BUGGY'#13
+'INVERSE_BETA'#13
+'INVISIBLE'#13
+'KILL_OBJ'#13
+'MEMO_ARDOISE'#13
+'MESSAGE'#13
+'MESSAGE_OBJ'#13
+'MESSAGE_ZOE'#13
+'NEW_SAMPLE'#13
+'NO_BODY'#13
+'NO_CHOC'#13
+'OBJ_COL'#13
+'PALETTE'#13
+'PARM_SAMPLE'#13
+'PCX'#13
+'PCX_MESS_OBJ'#13
+'PLAY_MUSIC'#13
+'PLAY_ACF'#13
+'PLUIE'#13
+'POPCORN'#13
+'POS_OBJ_AROUND'#13
+'POS_POINT'#13
+'REMP'#13
+'REPEAT_SAMPLE'#13
+'RESTORE_COMPORTEMENT'#13
+'RESTORE_COMPORTEMENT_OBJ'#13
+'RESTORE_HERO'#13
+'RESTORE_L_TRACK'#13
+'RESTORE_L_TRACK_OBJ'#13
+'SAMPLE'#13
+'SAMPLE_RND'#13
+'SAMPLE_ALWAYS'#13
+'SAMPLE_STOP'#13
+'SAVE_COMPORTEMENT'#13
+'SAVE_COMPORTEMENT_OBJ'#13
+'SAVE_HERO'#13
+'SET_ANIM_DIAL'#13
+'SET_ARMURE'#13
+'SET_ARMURE_OBJ'#13
+'SET_CAMERA'#13
+'SET_CHANGE_CUBE'#13
+'SET_DIR'#13
+'SET_DIR_OBJ'#13
+'SET_DOOR_DOWN'#13
+'SET_DOOR_LEFT'#13
+'SET_DOOR_RIGHT'#13
+'SET_DOOR_UP'#13
+'SET_FRAME'#13
+'SET_FRAME_3DS'#13
+'SET_GRM'#13
+'SET_HIT_ZONE'#13
+'SET_HOLO_POS'#13
+'SET_LIFE_POINT_OBJ'#13
+'SET_MAGIC_LEVEL'#13
+'SET_RAIL'#13
+'SET_SPRITE'#13
+'SET_TRACK'#13
+'SET_TRACK_OBJ'#13
+'SET_USED_INVENTORY'#13
+'SET_VAR_CUBE'#13
+'SET_VAR_GAME'#13
+'SHADOW_OBJ'#13
+'SPY'#13
+'STATE_INVENTORY'#13
+'STOP_L_TRACK'#13
+'STOP_L_TRACK_OBJ'#13
+'SUB_FUEL'#13
+'SUB_LIFE_POINT_OBJ'#13
+'SUB_MAGIC_POINT'#13
+'SUB_VAR_CUBE'#13
+'SUB_VAR_GAME'#13
+'SUICIDE'#13
+'THE_END'#13
+'TRACK_TO_VAR_GAME'#13
+'VAR_GAME_TO_TRACK'#13
+'USE_ONE_LITTLE_KEY';

LifeScriptACVarIt.Text:=
 '\style{+B}\color{clBlue}Variables:'#13
+'\style{+B}\color{clBlue}ACTION\style{-B} \column{}\color{clGray}Has value of 1 if player pressed "action" command'#13
+'\style{+B}\color{clBlue}ANGLE\style{-B} ???(int) \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}ANGE_OBJ\style{-B} ???(int) \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}ANIM\style{-B} \column{}\color{clGray}Animation id assigned to the actor'#13
+'\style{+B}\color{clBlue}ANIM_OBJ\style{-B} actor_id(int)\column{}\color{clGray}Animation id for another actor'#13
+'\style{+B}\color{clBlue}BETA\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}BETA_OBJ\style{-B} actor_id(int)\column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}BODY\style{-B} \column{}\color{clGray}Body id assigned to the actor'#13
+'\style{+B}\color{clBlue}BODY_OBJ\style{-B} actor_id(int)\column{}\color{clGray}Body id for another actor'#13
+'\style{+B}\color{clBlue}CARRY_BY\style{-B} \column{}\color{clGray}Object carrying the Actor'#13
+'\style{+B}\color{clBlue}CARRY_OBJ_BY\style{-B} actor_id(int) \column{}\color{clGray}Object carrying another Actor'#13
+'\style{+B}\color{clBlue}CDROM\style{-B} \column{}\color{clGray}(unknown)'#13
+'\style{+B}\color{clBlue}CHAPTER\style{-B} \column{}\color{clGray}Current value of CHAPTER variable'#13
+'\style{+B}\color{clBlue}CHOICE\style{-B} \column{}\color{clGray}Text id selected in the last ASK_CHOICE command'#13
+'\style{+B}\color{clBlue}COL\style{-B} \column{}\color{clGray}Id of an actor that is colliding with the current actor'#13
+'\style{+B}\color{clBlue}COL_OBJ\style{-B} actor_id(int) \column{}\color{clGray}Id of an actor colliding with specified actor'#13
+'\style{+B}\color{clBlue}COL_DECORS\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}COL_DECORS_OBJ\style{-B} actor_id(int)   \color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}COMPORTEMENT_HERO\style{-B} \column{}\color{clGray}Current hero behaviour (0 = normal, 1 = athletic, etc.)'#13
+'\style{+B}\color{clBlue}CONE_VIEW\style{-B} \column{}\color{clGray}(unknown)'#13
+'\style{+B}\color{clBlue}DEMO\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}DISTANCE\style{-B} actor_id(int) \column{}\color{clGray}Distance from specified actor'#13
+'\style{+B}\color{clBlue}DISTANCE_3D\style{-B} actor_id(int) \column{}\color{clGray}Distance in 3D from specified actor'#13
+'\style{+B}\color{clBlue}DISTANCE_MESSAGE\style{-B} ???(int) \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}ECHELLE\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}FUEL\style{-B} \column{}\color{clGray}Hero''s amount of fuel'#13
+'\style{+B}\color{clBlue}HIT_BY\style{-B} \column{}\color{clGray}Object hitting the Actor'#13
+'\style{+B}\color{clBlue}HIT_OBJ_BY\style{-B} actor_id(int) \column{}\color{clGray}Object hitting another Actor'#13
+'\style{+B}\color{clBlue}L_TRACK\style{-B} \column{}\color{clGray}Id of LABEL currently executed by the actor'#13
+'\style{+B}\color{clBlue}L_TRACK_OBJ\style{-B} actor_id(int)   \color{clGray}Id of LABEL executed by another actor'#13
+'\style{+B}\color{clBlue}LIFE_POINT\style{-B} \column{}\color{clGray}Number of life points of the actor'#13
+'\style{+B}\color{clBlue}LIFE_POINT_OBJ\style{-B} \column{}\color{clGray}Number of life points of another actor'#13
+'\style{+B}\color{clBlue}MAGIC_LEVEL\style{-B} \column{}\color{clGray}Hero''s magic level'#13
+'\style{+B}\color{clBlue}MAGOC_POINT\style{-B} \column{}\color{clGray}Hero''s magic points'#13
+'\style{+B}\color{clBlue}NB_GOLD_PIECES\style{-B} \column{}\color{clGray}Hero''s amount of money'#13
+'\style{+B}\color{clBlue}NB_LITTLE_KEYS\style{-B} \column{}\color{clGray}Hero''s number of little keys'#13
+'\style{+B}\color{clBlue}OBJECT_DISPLAYED\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}PROCESSOR\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}RAIL\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}REAL_ANGLE\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clBlue}RND\style{-B} range(int)\column{}\color{clGray}Returns random number up to range-1'#13
+'\style{+B}\color{clBlue}USE_INVENTORY\style{-B} obj_id(int) \column{}\color{clGray}Has value of 1 if player uses specified inventory item'#13
+'\style{+B}\color{clBlue}VAR_CUBE\style{-B} var_id(int)\column{}\color{clGray}Value of specified cube var'#13
+'\style{+B}\color{clBlue}VAR_GAME\style{-B} var_id(int)\column{}\color{clGray}Value of specified game var'#13
+'\style{+B}\color{clBlue}ZONE\style{-B} \column{}\color{clGray}Id of zone the actor is currently in'#13
+'\style{+B}\color{clBlue}ZONE_OBJ\style{-B} actor_id(int) \column{}\color{clGray}Id of zone that another actor is in';

LifeScriptACVarIn.Text:=
 ''#13
+'ACTION'#13
+'ANGLE'#13
+'ANGE_OBJ'#13
+'ANIM'#13
+'ANIM_OBJ'#13
+'BETA'#13
+'BETA_OBJ'#13
+'BODY'#13
+'BODY_OBJ'#13
+'CARRY_BY'#13
+'CARRY_OBJ_BY'#13
+'CDROM'#13
+'CHAPTER'#13
+'CHOICE'#13
+'COL'#13
+'COL_OBJ'#13
+'COL_DECORS'#13
+'COL_DECORS_OBJ'#13
+'COMPORTEMENT_HERO'#13
+'CONE_VIEW'#13
+'DEMO'#13
+'DISTANCE'#13
+'DISTANCE_3D'#13
+'DISTANCE_MESSAGE'#13
+'ECHELLE'#13
+'FUEL'#13
+'HIT_BY'#13
+'HIT_OBJ_BY'#13
+'L_TRACK'#13
+'L_TRACK_OBJ'#13
+'LIFE_POINT'#13
+'LIFE_POINT_OBJ'#13
+'MAGIC_LEVEL'#13
+'MAGOC_POINT'#13
+'NB_GOLD_PIECES'#13
+'NB_LITTLE_KEYS'#13
+'OBJECT_DISPLAYED'#13
+'PROCESSOR'#13
+'RAIL'#13
+'REAL_ANGLE'#13
+'RND'#13
+'USE_INVENTORY'#13
+'VAR_CUBE'#13
+'VAR_GAME'#13
+'ZONE'#13
+'ZONE_OBJ';

LifeScriptACBehIt.Text:=
 '\style{+B}\color{clOlive}Behaviours:'#13
+'\style{+B}\color{clOlive}NORMAL'#13
+'\style{+B}\color{clOlive}SPORTY'#13
+'\style{+B}\color{clOlive}AGGRESSIVE'#13
+'\style{+B}\color{clOlive}DISCREET'#13
+'\style{+B}\color{clOlive}JETPACK'#13
+'\style{+B}\color{clOlive}BEHAV5'#13
+'\style{+B}\color{clOlive}BEHAV6'#13
+'\style{+B}\color{clOlive}BEHAV7'#13
+'\style{+B}\color{clOlive}BEHAV8'#13
+'\style{+B}\color{clOlive}BEHAV9'#13
+'\style{+B}\color{clOlive}BEHAV10'#13
+'\style{+B}\color{clOlive}BEHAV11'#13
+'\style{+B}\color{clOlive}BEHAV12'#13
+'\style{+B}\color{clOlive}BEHAV13';

LifeScriptACBehIn.Text:=
 ''#13
+'NORMAL'#13
+'SPORTY'#13
+'AGGRESSIVE'#13
+'DISCREET'#13
+'JETPACK'#13
+'BEHAV5'#13
+'BEHAV6'#13
+'BEHAV7'#13
+'BEHAV8'#13
+'BEHAV9'#13
+'BEHAV10'#13
+'BEHAV11'#13
+'BEHAV12'#13
+'BEHAV13';

LifeScriptACDirIt.Text:=
 '\style{+B}\color{clOlive}Control Modes:'#13
+'\style{+B}\color{clOlive}NO_MOVE\style{-B}'#13
+'\style{+B}\color{clOlive}MANUAL\style{-B} \column{}\color{clGray}Player will take control over the Actor'#13
+'\style{+B}\color{clOlive}FOLLOW\style{-B} actor_id(int) \column{}\color{clGray}The Actor will follow another Actor'#13
+'\style{+B}\color{clOlive}SAME_XZ\style{-B} \column{}\color{clGray}The Actor will move vertically only (won''t fall)'#13
+'\style{+B}\color{clOlive}RAIL\style{-B} \column{}\color{clGray}The Actor will follow the rails'#13
+'\style{+B}\color{clOlive}DIRMODE9\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clOlive}DIRMODE10\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clOlive}DIRMODE11\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clOlive}DIRMODE12\style{-B} \column{}\color{clGray}Unknown'#13
+'\style{+B}\color{clOlive}DIRMODE13\style{-B} \column{}\color{clGray}Unknown';

LifeScriptACDirIn.Text:=
 ''#13
+'NO_MOVE'#13
+'MANUAL'#13
+'FOLLOW'#13
+'SAME_XZ'#13
+'RAIL'#13
+'DIRMODE9'#13
+'DIRMODE10'#13
+'DIRMODE11'#13
+'DIRMODE12'#13
+'DIRMODE13';
end;

procedure TfmScriptEd.ModACLba2Comp();
var a: Integer;
    sf: String;
begin
  for a:= 0 to High(Life2ModsComp) do begin
    sf:= Life2DecompList[Life2ModsComp[a].id];
    LifeScriptACCmdIt.Text:=
      StringReplace(LifeScriptACCmdIt.Text, sf, Life2ModsComp[a].name, []); //rfReplaceAll, rfIgnoreCase
    LifeScriptACCmdIn.Text:=
      StringReplace(LifeScriptACCmdIn.Text, sf, Life2ModsComp[a].name, []);
  end;

  for a:= 0 to High(Var2ModsComp) do begin
    sf:= Var2DecompList[Var2ModsComp[a].id];
    LifeScriptACVarIt.Text:=
      StringReplace(LifeScriptACVarIt.Text, sf, Var2ModsComp[a].name, []);
    LifeScriptACVarIn.Text:=
      StringReplace(LifeScriptACVarIn.Text, sf, Var2ModsComp[a].name, []);
  end;
end;

procedure TfmScriptEd.ModACLba2Eng(CompModded: Boolean);
var a, b, id: Integer;
    sf: String;
begin
  for a:= 0 to High(Track2ModsEng) do begin
    sf:= Track2DecompList[Track2ModsEng[a].id];
    TrackScriptACIt.Text:=
      StringReplace(TrackScriptACIt.Text, sf, Track2ModsEng[a].name, []); //rfReplaceAll, rfIgnoreCase
    TrackScriptACIn.Text:=
      StringReplace(TrackScriptACIn.Text, sf, Track2ModsEng[a].name, []);
  end;

  if not CompModded then begin
    for a:= 0 to High(Life2ModsEng) do begin
      sf:= Life2DecompList[Life2ModsEng[a].id];
      LifeScriptACCmdIt.Text:=
        StringReplace(LifeScriptACCmdIt.Text, sf, Life2ModsEng[a].name, []); //rfReplaceAll, rfIgnoreCase
      LifeScriptACCmdIn.Text:=
        StringReplace(LifeScriptACCmdIn.Text, sf, Life2ModsEng[a].name, []);
    end;
  end else begin
    //If the COMPORT(E)MENT is modded, some macro names are different
    for a:= 0 to High(Life2ModsEng) do begin
      id:= Life2ModsEng[a].id;
      sf:= Life2DecompList[id];
      for b:= 0 to High(Life2ModsComp) do
        if Life2ModsComp[b].id = id then begin
          sf:= Life2ModsComp[b].name;
          break;
        end;
      LifeScriptACCmdIt.Text:=
        StringReplace(LifeScriptACCmdIt.Text, sf, Life2ModsEng[a].name, []);
      LifeScriptACCmdIn.Text:=
        StringReplace(LifeScriptACCmdIn.Text, sf, Life2ModsEng[a].name, []);
    end;
  end;

  if not CompModded then begin
    for a:= 0 to High(Var2ModsEng) do begin
      sf:= Var2DecompList[Var2ModsEng[a].id];
      LifeScriptACVarIt.Text:=
        StringReplace(LifeScriptACVarIt.Text, sf, Var2ModsEng[a].name, []);
      LifeScriptACVarIn.Text:=
        StringReplace(LifeScriptACVarIn.Text, sf, Var2ModsEng[a].name, []);
    end;
  end else begin
    for a:= 0 to High(Var2ModsEng) do begin
      id:= Var2ModsEng[a].id;
      sf:= Var2DecompList[id];
      for b:= 0 to High(Var2ModsComp) do
        if Var2ModsComp[b].id = id then begin
          sf:= Var2ModsComp[b].name;
          break;
        end;
      LifeScriptACVarIt.Text:=
        StringReplace(LifeScriptACVarIt.Text, sf, Var2ModsEng[a].name, []);
      LifeScriptACVarIn.Text:=
        StringReplace(LifeScriptACVarIn.Text, sf, Var2ModsEng[a].name, []);
    end;
  end;
end;


