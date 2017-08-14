# nfs-mount

Install using the `Makefile`:

    $ sudo make install
    install -m 0644 "nfs-client-ping-mount.service" "/etc/systemd/system/nfs-client-ping-mount.service"
    install -m 0755 "nfs-client-ping-mount.sh" "/usr/local/bin/nfs-client-ping-mount.sh"
    systemctl daemon-reload
    systemctl enable nfs-client-ping-mount.service
    systemctl start nfs-client-ping-mount.service

Simply add your NFS filesystem mounts to `/etc/fstab` as you would normally.
Optionally add the `noauto` argument to the `fs_mntops` field.

