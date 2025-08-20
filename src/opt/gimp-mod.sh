#!/bin/sh

nx_gimp_export()
{
	h_nx_cmd gimp && {
		export G_NEX_GIMP_PLUG="$HOME/.config/GIMP/$(ls --color=never -1t "$HOME/.config/GIMP" | head -n 1)/plug-ins"
		[ -d "$G_NEX_GIMP_PLUG" -a -r "$G_NEX_GIMP_PLUG" ] || unset G_NEX_GIMP_PLUG
	}
}
