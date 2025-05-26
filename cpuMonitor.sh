
#!/bin/bash
renderCpuPage(){
	
	while true; do
	#Nproc shows the number of cores in our CPU
	coreNumbers=$(nproc)

	#Top is the command to see real-time system statistics. The -bn1 deconstructs
	#like this: -b is Batch Mode, meaning that runs without the full screen 
	#interface, n1 are the number of iterations, in this case, it runs a single
	#snapshot and exits. As we can see, we can perform mathematical operations
	#inside the print function, we do this addition because top shows the CPU usage
	#from the system and from the user, so we need to add them so we get the 
	#total CPU usage.

	cpuInUse=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
	cpuInUseInt=$(printf "%.0f" "$cpuInUse")
	cpuCircleRadius=10
	[[ $cpuCircleRadius -lt 6 ]] && cpuCircleRadius=6
	[[ $cpuCircleRadius -gt 15 ]] && cpuCircleRadius=15
	echo You have: $coreNumbers cores in your CPU!
	echo You are using $cpuInUse % of your CPU!
	declare -a cpuPoints
	totalPoints=0

		for ((y = -cpuCircleRadius; y <= cpuCircleRadius; y++)); do
			for ((x = -cpuCircleRadius; x <= cpuCircleRadius; x++)); do
				dist2=$((x*x + y*y))
				if (( dist2 <= cpuCircleRadius*cpuCircleRadius )); then
					cpuPoints+=("$x,$y")
					((totalPoints++))
				fi
			done
		done

		usedPoints=$((totalPoints * cpuInUseInt / 100))
		printed=0

		for ((y = -cpuCircleRadius; y <= cpuCircleRadius; y++)); do
			for ((x = -cpuCircleRadius; x <= cpuCircleRadius; x++)); do
				dist2=$((x*x + y*y))
				if (( dist2 <= cpuCircleRadius*cpuCircleRadius )); then
					if (( printed < usedPoints )); then
						printf "#"
					else
						printf "*"
					fi
					((printed++))
				else
					printf " "
				fi
			done
			echo
		done

		echo -e "\nPress [Q] to stop"

		read -t 1 -n 1 key
		if [[ $key == "q" || $key == "Q" ]]; then
			echo -e "Press Enter for RAM Info or Backspace for CPU Info"
			break
		fi

		sleep 1
	done

}
		
