#!/bin/bash
##version 0.1 by oditynet


##[!!!] Edit param IP^ (old:new)
ip="
10.177.45.4:1.1.1.1
10.171.92.198:2.2.2.2
10.167.132.11:3.3.3.3
"
file="/etc/corosync/corosync.conf"
#file="exaple.corosync.conf"
pcs="/tmp/conf_exp"
#psql -U postgres
#show hba_file;
pg="/var/lib/postgresql/9.6/*/pg_hba.conf"


t=$(date '+%T')

function replacecorosync {
old=$1
new=$2
echo "Old Addres: $old, New Address: $new"

cp $file /tmp/$(basename $file)_$t 2>/dev/null
if [[ $? == 0 ]]; then
      echo "Edit: $file"
      sed -r -i 's/ring(.)_addr:\ '$old'/ring\1_addr:\ '$new'/g' $file
      #sed -ir "s/$old/$new/g"   $i
else
    echo "[!] Problem copy $file"

fi
diff $file /tmp/$(basename $file)_$t
}

pcs cluster  cib $pcs
if [[ $? == 0 ]]; then echo "[+] Config pcs exported.";fi
cp $pcs $pcs.orig
for i in $ip; do
o=$(echo $i | cut -d ":" -f 1)
n=$(echo $i | cut -d ":" -f 2)

echo "[1]"
replacecorosync $o $n
echo "[2]"
sed -i -r "s/$o/$n/g"   $pcs
echo "[3]"
sed -i -r "s/$o/$n/g"   $pg

done

#cat $file
cat $pcs
pcs cluster cib-push $pcs diff-against=$pcs.orig
systemctl restart pcsd