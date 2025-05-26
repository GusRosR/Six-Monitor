
#!/bin/bash

renderRamPage(){
	while true; do
		clear
		#Awk is a text processor that help us split text following a pattern
		# After awk we define a Regex that in this case is: /.../ delimitates a word
		# The ^ states the beginning of the line and then the match we're expecting
		# then the {} tells awk what to do if the pattern matches
		# the print $2 tells awk to print the second column of what was found
		totalRam=$(free -m | awk '/^Mem:/ { printf("%.0f", $2/1000) }')
		#This is done so we get the amount of RAM in Mbs
		totalRamCircle=$(free -m | awk '/^Mem:/ { print $2 }')
		scaledRamGB=$((totalRam/1000))
		ramInUse=$(free -m | awk '/^Mem:/ { printf("%.0f", $3/1000) }')
		echo You have: $totalRam Gbs of RAM and you are using $ramInUse Gbs!
		 
		#ramCircleRadius=$((scaledRamGB*5/100))
		ramCircleRadius=10
		[[ $ramCircleRadius -lt 6 ]] && radius=6  # Enforce a minimum so the circle isn't tiny
		[[ $radius -gt 15 ]] && radius=15  # Optional cap so it doesn’t overflow terminal

		declare -a points 
		totalPoints=0

		for ((y = -ramCircleRadius; y <= ramCircleRadius; y++)); do
			#Here we iterate through the x axis of the plain
			for ((x = -ramCircleRadius; x <= ramCircleRadius; x++)); do
	    			#This is the actual formula for the circle in geometry is used
	    			#we use it to determine the circumference of our circle#
        			dist2=$((x*x + y*y))
				# Here we check if the distance or circumference is less or
				# equal to our squared radius, this check is done because if 
				# it is it means that they're inside the circumference, for 
				# the squared radius is the limit of our circumference#
        			if (( dist2 <= ramCircleRadius*ramCircleRadius )); then
					# If the checked point is inside our circumference, we
					# add it to the indexed array, we add the x and y coordinate
					# so we "map" each point of our circle #
            				points+=("$x,$y")
	    				# We add every point inside our perimeter to the total points
	    				# value #
            				((totalPoints++))
        			fi
    			done
		done

		# Here we use a rule of three, we know that the total points represent the 
		# 100 percent of our circle. We don't know the amount of points corresponding
		# to the used disk, but we do know that we've used the 43% of it, the formula 
		# for the already used disk points is the rule of three shown below #
		usedPoints=$((totalPoints * ramInUse / 100))
		# This variable will be used to count the amount of points corresponding
		# to the used portion of the disk that have already been printed #
		printed=0

		# Here we proceed to print the circle using the same looping principle
		# than on the first part#
		for ((y = -ramCircleRadius; y <= ramCircleRadius; y++)); do
    			for ((x = -ramCircleRadius; x <= ramCircleRadius; x++)); do
        			dist2=$((x*x + y*y))
        				if (( dist2 <= ramCircleRadius*ramCircleRadius )); then
					# Here we check if the amount of printed hashtags is
					# less than the amount of total used points so we only
					# display the exact amount of points that represent 
					# the used disk #	
            				if (( printed < usedPoints )); then
                				printf "#"
            				else
		    			# When all the points for the used disk have been printed
		    			# we print the regular asterisk #
                				printf "*"
            				fi
	    				# We increase the counter of the printed points for the used disk
            					((printed++))
        				else
					# If the points are outside the circumference we print
					# blank spaces to give that circular look#
            					printf " "
        				fi
    				done
    			echo
		done
		


		echo -e "\nPress [Q] to go back"

		read -t 1 -n 1 key
		if [[ $key == "q" || $key == "Q" ]]; then
			echo -e "Press Enter for disk info or Backspace for CPU Info"
			break
		fi
		
	sleep 1
	done
}
