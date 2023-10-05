path=$(echo $0 | rev | cut -b 17- | rev)
modifsave=''$path/modifsave''
if [ ! -e $modifsave ]; then
    touch $modifsave
fi
lastmodif=$(stat -c=%y $path/Shell_Userlist.csv | awk '{print $1, $2}')
lastmodif="${lastmodif%.*}"
echo ''Date et heure de la dernière modification : $lastmodif''
if [[ "$modifsave" != "$lastmodif" ]]; then
        while IFS="," read -r id prenom nom mdp role
        do
                username=$(echo "$prenom.$nom" | tr '[:upper:]' '[:lower:]')
                if [ $(echo $username | wc -m) -lt 3 ]; then
                break
		fi
                nrole=$(echo $role | tr -d '\r' | cat -t)
                sudo useradd $username
                echo "$username:$mdp" | sudo chpasswd
                if [ $nrole = "Admin" ]; then
                        sudo usermod -aG sudo $username
                        echo "$username Admin"
                else
                        sudo usermod -aG users $username
                        echo "$username User"
                fi
        done < <(tail -n +2 Shell_Userlist.csv | tr -d " " && echo "")
        echo $lastmodif > modifsave
fi
