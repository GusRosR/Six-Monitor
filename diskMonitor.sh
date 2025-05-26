#!/bin/bash

renderDiskPage(){
	#Df is the utility to show disk filesystem space information
	#the -h option is for displaying the results on a readable format
	#showing numbers in powers of 1024, the NR means Number of Records, this tells
	#awk to move to the second line
	totalDisk=$(df -h / | awk 'NR==2 { print $2 }')
	echo You have: $totalDisk of space in your disk and you are using $diskInUse Gbs!
	diskInUse=$(df -h / | awk 'NR==2 { print $3 }')
	#This line is used to calculate once again the amount of used disk, however
	#we need to use other column from the df / command because on the previous
	#method we extracted the data to read it on a human readable way, however
	#on this case we need the percentage as it is. In this case if we run the 
	#command on the terminal we get: 43%, this represents the used disk percentage 
	#the gsub is the global substitution utility, is used to extract 
	#a symbol from the output we are declaring, in this case % is what we want to 
	#replace, the second parameter is what we want to replace it with, in this case
	#"" means we don't want to replace it with nothing, and the last parameter
	#$5 means the fifth column extracted by awk
	diskInUseCircle=$(df / | awk 'NR==2 { gsub("%", "", $5); print $5 }')

	radius=10  # Adjust as needed
	#The declare -a is used to declare an indexed array in bash, in this case this
	#array will be used to store all points that lie or are "inside" the circle
	declare -a points

	#This variable will contain the total amount of points in the circle
	#so we then calculate the percentage of the circle that will be filled
	#with another symbol#
	totalPoints=0

	# On this first part we use the circle area formula from analytical geometry
	# so we can first calculate the total amount of points or "positions that our
	# circle will have #

	# Here we iterate through the y axis of the "cartisan plain" we negate the
	# radius because we start from the contrary position of each axis so when
	# we get to the positive value we have a full circle #
	for ((y = -radius; y <= radius; y++)); do
		#Here we iterate through the x axis of the plain
			for ((x = -radius; x <= radius; x++)); do
	    			#This is the actual formula for the circle in geometry is used
	    			#we use it to determine the circumference of our circle#
        			dist2=$((x*x + y*y))
				# Here we check if the distance or circumference is less or
				# equal to our squared radius, this check is done because if 
				# it is it means that they're inside the circumference, for 
				# the squared radius is the limit of our circumference#
        			if (( dist2 <= radius*radius )); then
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
	usedPoints=$((totalPoints * diskInUseCircle / 100))
	# This variable will be used to count the amount of points corresponding
	# to the used portion of the disk that have already been printed #
	printed=0

	# Here we proceed to print the circle using the same looping principle
	# than on the first part#
	for ((y = -radius; y <= radius; y++)); do
    		for ((x = -radius; x <= radius; x++)); do
        		dist2=$((x*x + y*y))
        			if (( dist2 <= radius*radius )); then
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
}
