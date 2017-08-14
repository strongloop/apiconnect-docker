FROM ibmcom/datapower:7.5.2
ENV  DATAPOWER_WORKER_THREADS=2 \
     DATAPOWER_INTERACTIVE=true
COPY src/ /
RUN  chmod +x /start.sh /start/vbox-inotify-workaround.sh
EXPOSE 443
CMD ["/start.sh"]
