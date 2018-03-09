# nrpe_rkhunter
nrpe plugin for rkhunter
execute rkhunter each night/day

add check_rkhunter.sh in /usr/lib/nagios/plugins/ and use it in an nrpe custom command
command[check_rkhunter]=/usr/lib/nagios/plugins/check_rkhunter.sh -w 1 -c 2 (1 day ago, 2 days ago)
