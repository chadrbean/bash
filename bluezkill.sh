#Required blutoothctl
#Predeclare arrays
declare -a BLUEDEVS;
declare -a PROCESSES;
declare -a PLIST;
#Processes To Monitor
PLIST=("brave" "vlc" "firefox" "chrome") 
#Start Time 
SECONDS=0
#Process Bool - Did process have a active blutooth connection, 0 is false, 1=true
PBOOL=0
#TIME duration to monitor
MAXTIME=1

function kill_bluetooth() {
    echo KILLING ALL BLUTOOTH 
    sleep 60
    read word
}

function get_bluetooth_ids() {
    IFS=$'\n'
    count=0
    for i in $(bluetoothctl devices)
        do
            BLUEDEVS[count]=$i
            count+=1
    done
}

function mon_processes() {
    IFS=$'\n'
    PROCESSES=($(pgrep $1))
    for (( iii=0;iii<${#PROCESSES[*]};++iii ))
        do 
            # Check if there are any process ids
            if [[ ${PROCESSES[iii]} > 0 ]]; then
                CPU=$(top -b -n 1  -p ${PROCESSES[$iii]} | tail -1 | awk '{print $9}')
                if [[ $CPU > 10 ]]; then
                    echo $1 $CPU
                    PBOOL=1
                fi
            fi
    done
    echo Total Processes Is: ${#PROCESSES[*]} for $1
}

function main() {
    for (( i=0;i<60;i++ )) {
        
        IFS=$' '
        get_bluetooth_ids
        
        for ((i=0;i<${#PLIST[@]};i++)) 
            do
                
                mon_processes ${PLIST[i]}
                
            done

        duration=$SECONDS
        echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
        echo $PBOOL
        sleep 1
        if [[ $(($duration / 60)) == $MAXTIME && $(($duration / 60)) -ge 1 ]]; then
            if [[ $PBOOL == 0 ]]; then
                echo GOT kil
                sleep 20
                kill_bluetooth
            fi
        fi
        if [ $(($duration / 60)) -ge $MAXTIME ]; then
           #Reset Bool and Time
           PBOOL=0
           SECONDS=0 
           
        fi
    }
}
# Also add if there is no processes for any of the list kill bluetooth

main
