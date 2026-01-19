ip -batch clean.batch
ip -batch nex-default.batch

nsenter --net=/var/run/netns/nex-a -- ip -batch nex-a.batch
nsenter --net=/var/run/netns/nex-a -- bridge -batch nex-br-a.batch

nsenter --net=/var/run/netns/nex-b -- ip -batch nex-b.batch
nsenter --net=/var/run/netns/nex-b -- bridge -batch nex-br-b.batch

