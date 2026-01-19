ip -batch clean.batch
ip -batch nex-default.batch

nsenter --net=/var/run/netns/nex-posix-128 -- ip -batch nex-posix-128.batch
nsenter --net=/var/run/netns/nex-posix-128 -- bridge -batch nex-br-posix-128.batch
nsenter --net=/var/run/netns/nex-posix-128 -- nft -f /etc/nftables.d/nex-posix-128/nat.nft

nsenter --net=/var/run/netns/nex-qemu-176 -- ip -batch nex-qemu-176.batch
nsenter --net=/var/run/netns/nex-qemu-176 -- bridge -batch nex-br-qemu-176.batch
