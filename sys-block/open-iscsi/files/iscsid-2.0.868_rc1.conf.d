# /etc/conf.d/iscsid

# config file to use
CONFIG_FILE=/etc/iscsi/iscsid.conf

# you need to specify an initiatorname in the file
INITIATORNAME_FILE=/etc/iscsi/initiatorname.iscsi

# options to pass to iscsid
OPTS="-i ${INITIATORNAME_FILE}"

