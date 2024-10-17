# GTMNP
Change ip in pacemaker, corosync and network os ALT linux

# Только для OS ALT linux!!!

Задача: на всех прод нодах изменить ip адресацию в ОС и в службах. 

Перед запуском скрипта create_network.sh откройте его, выберете режим будущей вашей сети, количетсво сетевых карт (1 или 2)

```
bash create_network.sh <net1> <net2> <route1> <route2>
bash create_network.sh 192.168.100.2 192.168.200.2 192.168.100.1 192.168.200.1
```

Перед запуском edit_ip_corosync+pcs+pg_hba.sh вставьте внутрь скрипта старые и новые адреса для замены ( путь pg_hba укажите правильный) 
