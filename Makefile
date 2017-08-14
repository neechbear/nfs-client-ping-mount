
NAME=nfs-client-ping-mount
SYSTEMD_UNIT_DIR=/etc/systemd/system
SCRIPTS_DIR=/usr/local/bin
SERVICE_UNIT=$(SYSTEMD_UNIT_DIR)/$(NAME).service
MOUNT_SCRIPT=$(SCRIPTS_DIR)/$(NAME).sh

.PHONY = install

install: $(SERVICE_UNIT) $(MOUNT_SCRIPT)
	systemctl daemon-reload
	systemctl enable $(NAME).service
	systemctl start $(NAME).service

$(SERVICE_UNIT): $(NAME).service
	install -m 0644 "$<" "$@"

$(MOUNT_SCRIPT): $(NAME).sh
	install -m 0755 "$<" "$@"

