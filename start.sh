#!/bin/bash
echo ======begin======
supervisord -c /etc/supervisord.conf 
service cron restart &&
echo "start success!"
echo ======end========
