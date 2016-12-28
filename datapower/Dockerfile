FROM ibmcom/datapower:latest
ENV  DATAPOWER_WORKER_THREADS=2 \
     DATAPOWER_INTERACTIVE=true
COPY src/ /
RUN  chmod +x /start.sh /start/vbox-inotify-workaround.sh
EXPOSE 443 9090
CMD ["/start.sh"]
