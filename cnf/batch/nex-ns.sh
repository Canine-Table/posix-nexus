
ip -batch clean.batch
ip -batch nex-default.batch

nsenter --net=/var/run/netns/nex-posix-128 -- ip -batch nex-posix-128.batch
nsenter --net=/var/run/netns/nex-posix-128 -- bridge -batch nex-br-posix-128.batch

nsenter --net=/var/run/netns/nex-pod-208 -- ip -batch nex-pod-208.batch
nsenter --net=/var/run/netns/nex-pod-208 -- bridge -batch nex-br-pod-208.batch

nsenter --net=/var/run/netns/nex-208-pgadmin -- ip -batch nex-pod-208.d/nex-208-pgadmin.batch
nsenter --net=/var/run/netns/nex-208-phpmyadmin -- ip -batch nex-pod-208.d/nex-208-phpmyadmin.batch

