nmb=$(last | grep -c "vututu") 
date=$(date +%d-%m-%Y-%H-%M)
name=number_connection-$date
echo $nmb > $name
save='/home/vututu/shell-exe/Job08/Backup'
tar -cf $save/$name.tar $name
rm $name
