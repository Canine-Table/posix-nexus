#!/bin/sh

new_net_dev_vlan() {
	chk_net_dev "$1" || (
		:
	)
}
