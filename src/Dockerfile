FROM debian:stable-slim

WORKDIR /usr/src/app

# cron設定
RUN apt update && apt-get install -y cron ntp wget gettext-base

COPY ntp.conf /etc/ntp.conf

COPY entry_point.sh /usr/src/app/entry_point.sh
RUN chmod 755 /usr/src/app/entry_point.sh

COPY update_ddns.sh /usr/src/app/update_ddns.sh
RUN chmod 755 /usr/src/app/update_ddns.sh

COPY crontab /usr/src/app/crontab

# ログを標準出力へ出力できるようにシンボリックリンクを作成する
RUN ln -sf /proc/1/fd/1 /var/log/cron.log

CMD TZ=${TZ} /usr/src/app/entry_point.sh
