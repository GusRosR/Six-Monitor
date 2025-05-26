
#!/bin/bash

source "$1"

currentPage=0
totalPageNumbers=$(getPageCount)

while true; do
	clear
	renderPage $currentPage

	read -rsn1 key
	case "$key" in
	  "") # Enter key
		  ((currentPage < totalPageNumbers - 1)) && ((currentPage++))
		  ;;
	$'\x7f') # Backspace
		((currentPage > 0)) && ((currentPage--))
		;;
	q) # Quit
		break
		;;
      esac
done
