#!/bin/bash
help="\ncheck_rkhunter.sh
Usage: check_rkhunter.sh -w integer -c integer\n"

STATE_OK=0		# define the exit code if status is OK
STATE_WARNING=1		# define the exit code if status is Warning (not really used)
STATE_CRITICAL=2	# define the exit code if status is Critical
STATE_UNKNOWN=3		# define the exit code if status is Unknown
crit_delay="";
warn_delay="";
while getopts "w:c:h" Input;
do
	case ${Input} in
	w)      warn_delay=${OPTARG};;
	c)      crit_delay=${OPTARG};;
	h)      echo -e "${help}"; exit 1;;
	\?)	echo "Wrong option given. Please use options -w for warning, -c for crititcal"
		exit 1
		;;
	esac
done
if [ "$warn_delay" = "" ];then
    echo $help
    exit 2;
fi
if [ "$crit_delay" = "" ];then
    echo $help
    exit 2;
fi

filemtime=$(stat -c %Y "/var/log/rkhunter.log")
currtime=`date +%s`
diff=$(( (currtime - filemtime) / 86400 ))
#echo $diff
if [[ ${diff} -ge ${crit_delay} ]]
  then echo "CRITICAL: cron has been run $diff days ago"; exit ${STATE_CRITICAL}
  elif [[ ${diff} -ge ${warn_delay} ]]
  then echo "WARNING: cron has been run $diff days ago"; exit ${STATE_WARNING}
  else echo "OK: $diff"; exit ${STATE_OK};
fi
