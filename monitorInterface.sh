
#!/bin/bash

source ./diskMonitor.sh
source ./ramMonitor.sh
source ./cpuMonitor.sh

getPageCount(){
	echo 3
}

renderPage(){

	case $1 in

		0) echo "CPU Info"
			echo -e
			renderCpuPage
		;;

		1) echo "RAM Info"
			echo -e 
			renderRamPage
		;;

		2) echo "Disk Info" 

			echo -e
			renderDiskPage
				;;
  esac
}

echo Hola Mundo

