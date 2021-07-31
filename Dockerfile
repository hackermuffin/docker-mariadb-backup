# Pull from base mariadb image
FROM mariadb:latest

# Install required software
RUN apt-get update && apt-get install -y cron
RUN apt-get update && apt-get install -y rclone

# Copy crontab files into container
COPY crontab /etc/cron.d/crontab
COPY backup.sh /backup.sh
COPY entrypoint.sh /entrypoint.sh

# Set up crontab
RUN chmod 0644 /etc/cron.d/crontab && \
    crontab /etc/cron.d/crontab

# Configure container
VOLUME /backups

# Run cron as foreground task
ENTRYPOINT ["/entrypoint.sh"]
CMD ["cron", "-f"]
