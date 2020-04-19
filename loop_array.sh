declare -a BLUEDEVS;
IFS=$'\n'
count=0
for i in $(bluetoothctl devices)
    do
        BLUEDEVS[count]=$i
        count+=1
done

# for ii in ${BLUEDEVS[@]}
#     do  
#         echo ${ii:7:18}
# done
declare -a PROCESSES;
IFS=$' '
PROCESSES=$(pgrep brave)

echo ${PROCESSES[@]}

for (( iii=0;iii<${#PROCESSES[@]};++iii ))
    do 
        echo ${PROCESSES[$iii]}
done


