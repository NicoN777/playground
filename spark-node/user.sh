#!/bin/bash
#Author: Nicolas Nunez

USER=${1}
USER_UID=${2}
echo "Creating user ${USER} to run Spark and all related..."
HOME_DIRECTORY=/home/${USER}
useradd \
--create-home \
--home-dir ${HOME_DIRECTORY} \
--comment "User to run Spark services" \
--shell /bin/bash \
--uid ${USER_UID} \
--user-group \
${USER}

echo "Just in case..."
chown -R ${USER}:${USER} ${HOME_DIRECTORY}
ls -lrt ${HOME_DIRECTORY}/..

SUDOERS=/etc/sudoers.d/${USER}
text="%${USER}        ALL=(ALL)       NOPASSWD: ALL"
echo ${text}
cat <<EOF >>${SUDOERS}
${text}
EOF

chmod 0440 ${SUDOERS}
