ip -batch "$NEXUS_CNF/batch/clean.batch"
ip -batch "$NEXUS_CNF/batch/nex-default.batch"
nsenter --net=/var/run/netns/nex-posix-128 -- ip -batch "$NEXUS_CNF/batch/nex-posix-128.batch"
nsenter --net=/var/run/netns/nex-posix-128 -- bridge -batch "$NEXUS_CNF/batch/nex-br-posix-128.batch"
nsenter --net=/var/run/netns/nex-posix-128 -- nft -f "$NEXUS_CNF/nft/nat.nft"

nsenter --net=/var/run/netns/nex-qemu-176 -- ip -batch "$NEXUS_CNF/batch/nex-qemu-176.batch"
nsenter --net=/var/run/netns/nex-qemu-176 -- bridge -batch "$NEXUS_CNF/batch/nex-br-qemu-176.batch"

nsenter --net=/var/run/netns/nex-pod-208 -- ip -batch "$NEXUS_CNF/batch/nex-pod-208.batch"
nsenter --net=/var/run/netns/nex-pod-208 -- bridge -batch "$NEXUS_CNF/batch/nex-br-pod-208.batch"

nsenter --net=/var/run/netns/nex-pod-208-adminer -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-adminer.batch"
nsenter --net=/var/run/netns/nex-pod-208-pgadmin -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-pgadmin.batch"
nsenter --net=/var/run/netns/nex-pod-208-ri -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-ri.batch"
nsenter --net=/var/run/netns/nex-pod-208-jellyfin -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-jellyfin.batch"
nsenter --net=/var/run/netns/nex-pod-208-nextcloud -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-nextcloud.batch"
nsenter --net=/var/run/netns/nex-pod-208-cups -- ip -batch "$NEXUS_CNF/batch/nex-pod-208-cups.batch"
