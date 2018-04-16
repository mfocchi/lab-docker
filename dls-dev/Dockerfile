FROM server-dev:5000/dls-env
WORKDIR /root
RUN export INSTALL_DEPS=false
RUN export INSTALL_EXTRAS=true
RUN bash install_dependencies.sh $INSTALL_DEPS $INSTALL_EXTRAS
RUN bash install_dls.sh 
