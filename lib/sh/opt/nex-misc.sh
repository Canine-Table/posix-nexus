

nx_misc_lemonade()
{
	h_nx_cmd lemonade && test -z "$DISPLAY" && {
		ps -a | grep -q 'lemonade' || {
			nx_io_printf -i "starting the lemonade service"
			nohup lemonade server 1> /dev/null 2>&1 &
		}
	}
	unset E_NEX_LEMONADE
}

nx_misc_soffice()
{
	h_nx_cmd soffice && {
		ps -a | grep -q 'soffice.bin' || {
			nx_io_printf -i "starting the soffice service on port 2002"
			nohup soffice --headless --accept="socket,host=localhost,port=2002;urp;" 1> /dev/null 2>&1 &
		}
	}
	unset E_NEX_SOFFICE
}

export E_NEX_SOFFICE=false
export E_NEX_LEMONADE=true

