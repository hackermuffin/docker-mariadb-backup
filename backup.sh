echo "\nRunning backup script at $(date)..."

# if appropriate setup present, run backup
if [ $MYSQL_USER ] && [ $MYSQL_PASSWORD ] && [ $MYSQL_DATABASE ]
then
    mysqldump --single-transaction -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE > /backups/nextcloud-sqlbkp_`date +"%Y%m%d"`.bak
else
    echo "Please set 'MYSQL_USER', 'MYSQL_PASSWORD' and 'MYSQL_DATABASE' variables to allow backups to run."
    exit
fi

# test which backups should be removed
if [ $N_BACKUPS ]
then
    FILES_TO_DELETE=$(ls -Art ~/test/* | head -n-$N_BACKUPS)
else
    echo "'N_BACKUPS not set. Keeping all backups."
fi


# remove appropriate backups
if [ $FILES_TO_DELETE ]
then
    echo "Maximum number of backup files reached. Removing:"
    echo "$FILES_TO_DELETE"
    rm $FILES_TO_DELETE
else
    echo "No backups were removed."
fi
