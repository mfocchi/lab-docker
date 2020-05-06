ARG RELEASE
FROM server-gitlab-runner:5000/dls2-plugin-dev:$RELEASE
ARG RELEASE
RUN apt-get update \
  && apt-get install -y dls2_rcf_controller dls2_pid_controller dls2_prep_gait_generator dls2_prep_gait_generator dls2_trunk_controller
