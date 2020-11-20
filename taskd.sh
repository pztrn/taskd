#!/usr/bin/env bash

# Copy'd from https://github.com/mrdaemon/taskd-server/
export TASKDDATA=/var/taskd

if [[ ! -w $TASKDDATA ]] ; then
    >&2 echo "Warning: Home directory \"$TASKDDATA\" is not writable."
    >&2 echo "  Did you set permissions on the volume correctly?"
fi

# Do preliminary configuration if needed.
if [[ ! -f $TASKDDATA/config ]] ; then
    mkdir "$TASKDDATA"

    taskd init --data "$TASKDDATA"
	taskd config --force server=0.0.0.0:53589

	# Generating stub certificates that WILL BE INVALID.
	# See taskd configuration guide for configuring it right.
	/usr/share/doc/taskd/pki/generate
fi

# Print version and diagnostics to logs
taskd diagnostics --data "$TASKDDATA"

# Hand off to taskd
exec taskd server
