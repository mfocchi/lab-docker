ARG RELEASE
FROM server-dev:5000/dls-env:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
#RUN wget http://server-dev/debs/latest/libxenomai1_3.0.6.deb
#RUN dpkg --unpack libxenomai1_3.0.6.deb
#RUN rm /var/lib/dpkg/info/libxenomai1.postinst -f
#RUN dpkg --configure libxenomai1
RUN apt-get update && apt-get install -y libxenomai1 libxenomai-dev xenomai-kernel-source xenomai-runtime iit-commons-xeno/$RELEASE hyq-commons-xeno/$RELEASE hyqreal-commons-xeno/$RELEASE





