#!/usr/bin/env bash

set -Eeuo pipefail

nfs_mounts () {
  declare fs_spec="" fs_file="" fs_vfstype="" fs_mntops="" fs_freq="" fs_passno=""
  while read -r fs_spec fs_file fs_vfstype fs_mntops fs_freq fs_passno
  do
    case "${fs_vfstype:-}" in
      nfs|nfs3|nfs4)
        printf "%s %s\n" "${fs_spec%%:*}" "${fs_file:-}"
        ;;
      *)
        continue
        ;;
    esac
  done < /etc/fstab
}

host_is_online () {
  # Could be imptoved to explicitly test for RPC availability.
  ping -q -c "$PING_COUNT" -w "$PING_DEADLINE" -W "$PING_TIMEOUT" "$1" >/dev/null
}

is_mounted () {
  # Could be improved to check explicitly that fs_spec is mounted as fs_vfstype.
  mountpoint -q "$1" >/dev/null
}

maintain_nfs_mounts () {
  declare host="" path=""
  while read -r host fs_file
  do
    if host_is_online "$host"
    then
      if ! is_mounted "$fs_file"
      then
        echo "Mounting $fs_file from $host ..."
        mount "$fs_file" || true
      fi

    else
      if is_mounted "$fs_file"
      then
        echo "Un-mounting $fs_file from $host ..."
        umount -l -f "$fs_file" || true
      fi
    fi
  done < <(nfs_mounts)
}

main () {
  if [[ -r "/etc/defaults/nfs-client-ping-mount" ]]
  then
    source "/etc/defaults/nfs-client-ping-mount"
  fi

  PING_COUNT="${PING_COUNT:-3}"
  PING_DEADLINE="${PING_DEADLINE:-15}"
  PING_TIMEOUT="${PING_TIMEOUT:-15}"

  while :
  do
    maintain_nfs_mounts
  done
}

main "$@"

