global outputs
set outputs("ps_path") "/tmp/"
set outputs("left") "/tmp/left.ps"
set outputs("top") "/tmp/top.ps"
set outputs("right") "/tmp/right.ps"
set outputs("top_merge") "/tmp/top_merge.ps"
set outputs("left_merge") "/tmp/left_merge.ps"
set outputs("right_merge") "/tmp/right_merge.ps"
set outputs("output") "/tmp/output.ps"
set outputs("bot") "/tmp/bot.ps"
set outputs("bot_merge") "/tmp/bot_merge.ps"
set outputs("left_moves_merge") "/tmp/left_moves_merge.ps"
set outputs("left_moves") "/tmp/left_moves.ps"
set outputs("right_moves_merge") "/tmp/right_moves_merge.ps"
set outputs("right_moves") "/tmp/right_moves.ps"
set outputs("middle_moves_merge") "/tmp/middle_moves_merge.ps"
set outputs("middle_moves") "/tmp/middle_moves.ps"
set outputs("output_merge") "/tmp/output_merge.ps"
set outputs("outputPDF") "pdf/output.pdf"
set outputs("static_oxy") "../bitmaps/static_oxy.ps"
set outputs("static_legend") "../bitmaps/static_legend.ps"
set outputs("static_blank") "../bitmaps/static_blank.ps"
set outputs("gs_str") "exec /usr/bin/gs -q -dNOPAUSE -dBATCH -sDEVICE=pswrite \
	-sOutputFile="
set outputs("left_name") "/tmp/left_name.ps"
set outputs("right_name") "/tmp/right_name.ps"
# if you ever need to find the font_str
# to a search for the following array value
# and replace the occurences with the new path
# need to find a way to pass it to exec w/o the
# substitutions
set outputs("font_str") "(\\/usr\\/share\\/ghostscript\\/fonts\\/Vag Rounded BT.ttf)"
canvas .printing -width 500 -height 500

# do the printing
proc doPrinting {c position winningSide} {
	global outputs gFrameWidth
	# disable caching
	set path [makePath $position false]
	# capture the last position
	capture $c $position false $path
	$c create rectangle 0 [expr $gFrameWidth/2 - 75] $gFrameWidth [expr $gFrameWidth/2 + 75] -fill gray -width 1 -outline black -tag PDF
	$c create text [expr $gFrameWidth/2] [expr $gFrameWidth/2 - 40] -text "Generating PDF" -font {Courier 40} -tags PDF
	$c create text [expr $gFrameWidth/2] [expr $gFrameWidth/2 + 40] -text "Step 1 of 6" -font {Courier 40} -tags PDFStep
	update idletasks
	makeTop $c $position $winningSide
	
	$c itemconfigure PDFStep -text "Step 2 of 6"
	update idletasks
	makeBottom
	
	$c itemconfigure PDFStep -text "Step 3 of 6"
	update idletasks
	combine
	
	$c itemconfigure PDFStep -text "Step 4 of 6"
	update idletasks
	addHeader
	addFooter
	
	$c itemconfigure PDFStep -text "Step 5 of 6"
	update idletasks
	exec /usr/bin/psnup -q -1 -b0.25in -pletter -Pletter $outputs("output") $outputs("output_merge")
	
	$c itemconfigure PDFStep -text "Step 6 of 6"
	update idletasks
	# use gs to generate a pdf...
	# only needed for debugging
	makePDF $outputs("output_merge") $outputs("outputPDF")
	$c delete PDF PDFStep
}

proc addFooter { } {
	global outputs
	# omg... at this command
	# add titles for the bottom columns
	# also add the gamescrafters website location
	# the 2 or 3 in the third part is a seega hack...
	# need to find a better way to detect where to input
	exec /usr/bin/sed -i -r -e '/gsave mark/N' \
		-e '/gsave mark\[\[:space:]]+Q q/N' \
		-e 's/gsave mark\[\[:space:]]+Q q\[\[:space:]]+57\[23]/\
		%Added postscript\\n \
		\\/dispCenter \{dup stringwidth pop 2 div neg 0 rmoveto show\} bind def\\n \
		600 150 moveto\\n \
		-100 0 rlineto\\n \
		0 7620 rlineto\\n \
		100 0 rlineto\\n \
		2600 150 moveto\\n \
		3050 0 rlineto\\n \
		0 7620 rlineto\\n \
		-2550 0 rlineto\\n \
		500 3960 moveto\\n \
		100 0 rlineto\\n \
		5650 3960 moveto\\n \
		-1050 0 rlineto\\n \
		stroke\\n \
		139.0000 0.0000 0.0000 setrgbcolor\\n \
		4580 3710 moveto\\n \
		0 500 rlineto\\n \
		300 0 rlineto\\n \
		0 -500 rlineto\\n \
		fill\\n \
		255.0000 255.0000 0.0000 setrgbcolor\\n \
		4930 3710 moveto\\n \
		0 500 rlineto\\n \
		300 0 rlineto\\n \
		0 -500 rlineto\\n \
		fill\\n \
		0.0000 255.0000 0.0000 setrgbcolor\\n \
		5280 3710 moveto\\n \
		0 500 rlineto\\n \
		300 0 rlineto\\n \
		0 -500 rlineto\\n \
		fill\\n \
		0.0000 0.0000 0.0000 setrgbcolor\\n \
		90 rotate\\n \
		(\\/usr\\/share\\/ghostscript\\/fonts\\/Vag Rounded BT.ttf) findfont\\n \
		200 scalefont\\n \
		setfont\\n \
		3960 -4800 moveto\\n \
		(Lose) dispCenter\\n \
		3960 -5150 moveto\\n \
		(Tie) dispCenter\\n \
		3960 -5500 moveto\\n \
		(Win) dispCenter\\n \
		700 -400 moveto\\n \
		(Before) show\\n \
		2750 -400 moveto\\n \
		(After) show\\n \
		4650 -400 moveto\\n \
		(Before) show\\n \
		6700 -400 moveto\\n \
		(After) show\\n \
		1980 -5850 moveto\\n \
		(GamesCrafters) dispCenter\\n \
		5940 -5850 moveto\\n \
		(http:\\/\\/gamescrafters.berkeley.edu\\/) dispCenter\\n \
		(\\/usr\\/share\\/ghostscript\\/fonts\\/Vag Rounded BT.ttf) findfont\\n \
		500 scalefont\\n \
		setfont\\n \
		3960 -1000 moveto\\n \
		(M) dispCenter\\n \
		3960 -1500 moveto\\n \
		(I) dispCenter\\n \
		3960 -2000 moveto\\n \
		(S) dispCenter\\n \
		3960 -2500 moveto\\n \
		(T) dispCenter\\n \
		3960 -3000 moveto\\n \
		(A) dispCenter\\n \
		3960 -3500 moveto\\n \
		(K) dispCenter\\n \
		3960 -4000 moveto\\n \
		(E) dispCenter\\n \
		3960 -4500 moveto\\n \
		(S) dispCenter\\n \
		150 -1000 moveto\\n \
		(L) dispCenter\\n \
		150 -1500 moveto\\n \
		(E) dispCenter\\n \
		150 -2000 moveto\\n \
		(F) dispCenter\\n \
		150 -2500 moveto\\n \
		(T) dispCenter\\n \
		7750 -1000 moveto\\n \
		(R) dispCenter\\n \
		7750 -1500 moveto\\n \
		(I) dispCenter\\n \
		7750 -2000 moveto\\n \
		(G) dispCenter\\n \
		7750 -2500 moveto\\n \
		(H) dispCenter\\n \
		7750 -3000 moveto\\n \
		(T) dispCenter\\n \
		-90 rotate\\n&/' $outputs("output")	
}

proc addHeader { } {
	global outputs kGameName
	# add the gamescrafters logo
	# center on 396 -75
	# add the time and the date
	# we need to escape the / in date
	# otherwise sed complains
	# get the hostname too
	# and escape incase it has /
	set name $kGameName
	set t [clock format [clock seconds] -format %T]
	set date [clock format [clock seconds] -format "%Y-%m-%d"]
	set host [exec /usr/bin/hostname]
	regsub -all {\/} $host "\\\/" host
	# remove mobile if it starts with mobile
	regsub -all {^mobile} $host "" host
	# replace the spaces in name... with -
	# otherwise gs dies
	# replace the ' also
	regsub -all { } $name "-" name
	regsub -all {\'} $name "`" name
	# this gets duplicated for some reason...
	# need to fix some time
	exec /usr/bin/sed -i -r -e 's/cleartomark end end pagesave restore showpage/&\\n \
		%Added postscript\\n \
		90 rotate\\n \
		\\/dispCenter \{dup stringwidth pop 2 div neg 0 rmoveto show\} bind def\\n \
		(\\/usr\\/share\\/ghostscript\\/fonts\\/Vag Rounded BT.ttf) findfont\\n \
		40 scalefont\\n \
		setfont\\n \
		newpath\\n \
		396 -35 moveto\\n \
		(Post-Game Analysis) dispCenter\\n \
		396 -75 moveto\\n \
		($name) dispCenter\\n \
		265 -350 moveto\\n \
		(M) dispCenter\\n \
		265 -390 moveto\\n \
		(O) dispCenter\\n \
		265 -430 moveto\\n \
		(V) dispCenter\\n \
		265 -470 moveto\\n \
		(E) dispCenter\\n \
		530 -350 moveto\\n \
		(H) dispCenter\\n \
		530 -390 moveto\\n \
		(I) dispCenter\\n \
		530 -430 moveto\\n \
		(S) dispCenter\\n \
		530 -470 moveto\\n \
		(T) dispCenter\\n \
		530 -510 moveto\\n \
		(O) dispCenter\\n \
		530 -550 moveto\\n \
		(R) dispCenter\\n \
		530 -590 moveto\\n \
		(Y) dispCenter\\n \
		(\\/usr\\/share\\/ghostscript\\/fonts\\/Vag Rounded BT.ttf) findfont\\n \
		20 scalefont\\n \
		setfont\\n \
		newpath\\n \
		60 -45 moveto\\n \
		($date) dispCenter\\n \
		60 -75 moveto\\n \
		($t) dispCenter\\n \
		750 -60 moveto\\n \
		($host) dispCenter\\n \
		-90 rotate/' $outputs("output")
}

# replace references to /Courier with
# the vag rounded bt font...
proc replaceFont { } {
	global outputs
	# right name
	exec /usr/bin/sed -i -r -e 's/\\/Courier/(\\/usr\\/share\\/ghostscript\\/fonts\\/Vag Rounded BT.ttf)/' $outputs("right_name")
	# left name
	exec /usr/bin/sed -i -r -e 's/\\/Courier/(\\/usr\\/share\\/ghostscript\\/fonts\\/Vag Rounded BT.ttf)/' $outputs("left_name") 
}

# setup the top part
proc makeTop { c position winningSide} {
	global outputs kGameName
	# make the name tags
	makeTags $winningSide
	set maxMoves 6
	# disable caching
	set winPath [makePath $position false]
	set moves [makeMoveList [expr 3 * $maxMoves]]
	set emptyStr "$outputs(\"static_blank\") $outputs(\"static_blank\")"
	set leftMoves ""
	set middleMoves ""
	set rightMoves ""
	# we need to partition the moves to different parts now
	set i 0
	set j 0
	foreach move $moves {
		if {$i == 0 } {
			set leftMoves "$leftMoves \"$move\""
		} elseif {$i == 1} {
			set middleMoves "$middleMoves \"$move\""
		} else {
			set rightMoves "$rightMoves \"$move\""
		}
		# we want 2 across on each part
		incr j
		if {$j == 2} {
			incr i
			# reset i if we need to
			if {$i == 3} {
				set i 0
			}
			set j 0
		}
	}
	if {$leftMoves == "" } {
		set leftMoves $emptyStr
	}
	eval "$outputs(\"gs_str\")$outputs(\"left_moves_merge\") $leftMoves"
	exec /usr/bin/psnup -q -m0.65in -$maxMoves -H8.5in -W8.6in -pletter $outputs("left_moves_merge") $outputs("left_moves")
	
	if {$middleMoves == "" } {
		set middleMoves $emptyStr
	}
	eval "$outputs(\"gs_str\")$outputs(\"middle_moves_merge\") $middleMoves"
	exec /usr/bin/psnup -q -m0.65in -$maxMoves -H8.5in -W8.6in -pletter $outputs("middle_moves_merge") $outputs("middle_moves")	

	if {$rightMoves == "" } {
		set rightMoves $emptyStr
	}
	eval "$outputs(\"gs_str\")$outputs(\"right_moves_merge\") $rightMoves"
	exec /usr/bin/psnup -q -m0.65in -$maxMoves -H8.5in -W8.6in -pletter $outputs("right_moves_merge") $outputs("right_moves")		
		

	# make top
	
	set topStr "$outputs(\"left_name\") \"$winPath\" $outputs(\"right_name\") "
	set topStr "$topStr $outputs(\"left_moves\") $outputs(\"middle_moves\") $outputs(\"right_moves\")"
	eval "$outputs(\"gs_str\")$outputs(\"top_merge\") $topStr"
	exec /usr/bin/psnup -q -6 -Pletter -pletter $outputs("top_merge") $outputs("top") 
}

# make the pages for the names
proc makeTags { winningSide } {
	global gLeftName gRightName outputs gFrameWidth gLeftPiece gRightPiece
	set colors [GS_ColorOfPlayers]
	set maxLen [max [max [string length $gLeftName] \
	 					[string length $gRightName]] 1]
	# don't want to divide by zero...
	# leave a buffer
	set yOffset 250
	set maxPixels [expr [tk scaling] * 8.5 * 72 - 10]
	# make sure fontsize is an int
	# also don't make font too big
	set fontSize [min 128 [expr {int($maxPixels / $maxLen)}]]
	# pack the printing canvas
	# do some creation and capturing
	# courier is just used as a placeholder... we will replace it
	# with the desired font
	pack .printing
	.printing create text [expr $gFrameWidth / 2] [expr $yOffset + 210] \
		-justify center -text "WINNER" -font {Courier 128} \
		-tag __winner -state hidden
	.printing create text [expr $gFrameWidth / 2] $yOffset -justify center \
		-text "LEFT\n$gLeftName" -font "Courier $fontSize" -tag __printing -fill [lindex $colors 0]
	if { $winningSide == $gLeftPiece } {
		.printing itemconfigure __winner -state normal
	}
	update idletasks
	
	# reconfigure the text and capture again
	.printing postscript -file $outputs("left_name") -pagewidth 8.5i
	if { $winningSide == $gRightPiece } {
		.printing itemconfigure __winner -state normal
	} else {
		.printing itemconfigure __winner -state hidden
	}
	.printing itemconfigure __printing -text "RIGHT\n$gRightName" -fill [lindex $colors 1]
	update idletasks
	# again
	.printing postscript -file $outputs("right_name") -pagewidth 8.5i
	pack forget .printing
	.printing delete __printing __winner
	update
	# replace the Courier font with
	# the vag rounded bt
	replaceFont
}

proc makeMoveList { maxMoves } {
	global gGameSoFar
	set moves []
	set moveList ""
	# need to reverse the list...
	# tcl 8.5 has a built in reverse
	# we start at len - 2 because len is > last index
	# and the last index is pos 0 which we don't want
	for {set i [expr [llength $gGameSoFar] - 2]} { $i >= 0} {incr i -1} {
		lappend moves [lindex $gGameSoFar $i]
	}
	
	# truncate the list to how many we need
	# end index > len - 1 => len - 1
	set moves [lrange $moves 0 [expr $maxMoves - 1]]
	
	foreach move $moves {
		set path [makePath $move false]
		set moveList "$moveList \"$path\""
	}
	
	return $moveList
}

# generate mistake lists for the bottom
# then make the bottom
proc makeBottom {} {
	setMistakesLists
	generateBottom
}

# combine bottom and top outputs
proc combine {} {
	global outputs
	eval "$outputs(\"gs_str\")$outputs(\"output_merge\") $outputs(\"top\") \
		$outputs(\"bot\")"
	exec /usr/bin/psnup -q -2 -pletter -W8.25in $outputs("output_merge") $outputs("output")	
}

# go through all the mistakes
# and separate into left and right mistakes
proc setMistakesLists { } {
	global gMistakeList leftMistakes rightMistakes
	set leftMistakes []
	set rightMistakes []
	foreach mistake $gMistakeList {
		if {[lindex $mistake 0] == "Left" } {
			lappend leftMistakes [lrange $mistake 1 [llength $mistake]]
		} elseif {[lindex $mistake 0] == "Right" } {
			lappend rightMistakes [lrange $mistake 1 [llength $mistake]]
		}
	}
}

# generate the mistake pages to display
proc generateBottom { } {
	global leftMistakes rightMistakes outputs

	set maxErrors 4
	set leftExec [makeExec $leftMistakes $maxErrors]
	set rightExec [makeExec $rightMistakes $maxErrors]
	set mergeStr ""

	# if we added something then merge and psnup
	# then combine the pages, else we point to a blank page
	# need to point to blank page to preserve ordering
	if { $leftExec == "" } {
		set leftExec "$outputs(\"static_blank\") $outputs(\"static_blank\")"
	}
	eval "$outputs(\"gs_str\")$outputs(\"left\") $leftExec"
	exec /usr/bin/psnup -q -[expr 2 * $maxErrors] -H8.5in -W8.5in -pletter \
		$outputs("left") $outputs("left_merge")
	set mergeStr "$mergeStr $outputs(\"left_merge\")"
	
	if { $rightExec == "" } {
		set rightExec "$outputs(\"static_blank\") $outputs(\"static_blank\")"
	}
	eval "$outputs(\"gs_str\")$outputs(\"right\") $rightExec"
	exec /usr/bin/psnup -q -[expr 2 * $maxErrors] -H8.5in -W8.5in -pletter \
			$outputs("right") $outputs("right_merge")
	set mergeStr "$mergeStr $outputs(\"right_merge\")"
	
	# combine the left and right outputs to form the bottom
	eval "$outputs(\"gs_str\")$outputs(\"bot_merge\") $mergeStr"
	exec /usr/bin/psnup -q -2 -pletter $outputs("bot_merge") $outputs("bot")
}

# go through the mistake lists
# and add stuff to the psnup execute command
proc makeExec { mistakeList maxErrors} {
	global outputs
	set size [llength $mistakeList]
	set ret ""
	# trim mistakes to the worst ones
	if { $size > $maxErrors } {
		# get list of the worst mistakes
		set mistakeList [findWorst $mistakeList]
		# truncate to 4 mistakes
		set mistakeList [lrange $mistakeList 0 [expr $maxErrors - 1]]
	}

	# iterate over the mistake lists
	# taking the old positions value moves
	# and the actual in game result
	foreach mistake $mistakeList {
		set oldPos [lindex $mistake 6]
		set badMove [lindex $mistake 1]
		set badPos [C_DoMove $oldPos $badMove]
		set old [makePath $oldPos true]
		set new [makePath $badPos false]
		set ret "$ret \"$old\" \"$new\""
	}
	
	return $ret
}

# find the worst mistakes defined from worst to "best"
# 1 possible lose -> win
# 2 possible lose -> tie
# 3 possible tie -> win
# state change mistakes are bad
proc findWorst { mistakeList } {
	set worst [list]
	# sort by increasing significance of key
	# what did we end up at?
	# giving them a win is the worst
	foreach mistake $mistakeList {
		set type [lindex $mistake 0]
		if { $type  == "Lose"} {
			set val 3
		} elseif { $type == "Tie" } {
			set val 2
		} elseif { $type == "Win" } {
			set val 1
		}
		lappend worst [list $val $mistake]
	}
	
	set worst [stripKey [lsort -integer -index 0 $worst]]

	set mistakeList [list]
	# what did we give up?
	# giving up a losing position is the worst
	foreach mistake $worst {
		set type [lindex $mistake 3]
		if { $type  == "Lose"} {
			set val 1
		} elseif { $type == "Tie" } {
			set val 2
		} elseif { $type == "Win" } {
			set val 3
		}
		lappend mistakeList [list $val $mistake]
	}
	
	set worst [stripKey [lsort -integer -index 0 $mistakeList]]
	
	return $worst
}

proc stripKey { lst } {
	set ret [list]
	for {set i 0} {$i < [llength $lst] } {incr i } {
		lappend ret [lindex [lindex $lst $i] 1]
	}
	
	return $ret
}

# do the setup required for a screenshot
# only change Move type if we need to ie
# the position we need to capture hasn't
# been capture yet
proc doCapture { c moveType position theMoves value} {
	# disable caching
	set path [makePath $position $value]
	if { $path != "" } {
		set type "all"
		if {$value == true} {
			set type "value"
		}
		# hide old and display new
		GS_HideMoves $c $moveType $position $theMoves
		if {$value == true} {
			GS_ShowMoves $c $type $position $theMoves		
		}
		update idletasks
			
		# capture screen shot
		capture $c $position $value $path
			
		# hide new and display old
		if {$value == true} {
			GS_HideMoves $c $type $position $theMoves
		}
		GS_ShowMoves $c $moveType $position $theMoves
		update idletasks
	}
}

# capture a screen shot
# give it the correct name depending on options
proc capture { c pos value path} {
	# capture to game directory
	if { $path != "" } {
		# hide background to reduce drawing time
		$c itemconfigure background -state hidden
		$c postscript -file "$path" -pagewidth 8.0i -pagey 0.0i -pageanchor s
		# show it again
		$c itemconfigure background -state normal
	}
}

# will generate the path for the given arguments
# but will only return if the path doesn't already
# exist, if it does, then return ""
proc makePathOnce { pos value} {
	set path [makePath $pos $value]
	
	if { [file exists $path] } {
		return ""
	}
	
	return $path
}

# make path with given arguments
# do the folder checking in here, since other
# functions should call this function to make the
# path
proc makePath { pos value } {
	global kGameName outputs
	checkFolders $kGameName
	
	set path "$outputs(\"ps_path\")/$kGameName/$kGameName\_$pos"
	if { $value == true} {
		set path "$path\_v"
	}
	
	return "$path.ps"
}

# make string to use for pdf generation
# then call it
proc makePDF { input output} {
	global outputs
	if { ![file exists "pdf/"] } {
		file mkdir "pdf/"
	}
	eval "exec /usr/bin/gs -q -dNOPAUSE -dBATCH -sOutputFile=$output \
			-sDEVICE=pdfwrite -c .setpdfwrite -f $input"
}

# check for folders we need
proc checkFolders { game } {
	# check for directories
	global outputs
	if { ![file exists "$outputs(\"ps_path\")/"] } {
		file mkdir "$outputs(\"ps_path\")"
	}
	
	if { ![file exists "$outputs(\"ps_path\")/$game"] } {
		file mkdir "$outputs(\"ps_path\")/$game"
	}
}

proc max { a b } {
	if { $a > $b } {
		return $a
	}
	return $b
}

proc min { a b } {
	if { $a < $b } {
		return $a
	}
	return $b
}