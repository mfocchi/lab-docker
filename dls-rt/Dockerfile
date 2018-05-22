ARG RELEASE
FROM server-dev:5000/dls-env:$RELEASE
ARG RELEASE
WORKDIR /root
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libxenomai-3.0.5 iit-commons-xeno/$RELEASE hyq-commons-xeno/$RELEASE hyqreal-commons-xeno/$RELEASE





