nx_dbus_playbook()
(
	nx_data_longopt -v 3 -- ',

	n<names>
	<description List all names on the session bus>
	<lazy>
	<build
		dbus-send --session \
			--dest=org.freedesktop.DBus \
			/org/freedesktop/DBus \
			org.freedesktop.DBus.ListNames;
	>

	m<monitor>
	<description Monitor all session bus traffic>
	<lazy>
	<build
		dbus-monitor --session;
	>

	T<%monitor-type>
	<regex ^(signal|method_call|method_return|error)$>
	<description Monitor only DBus type specified [signal|method_call|method_return|error]>
	<default type=signal>
	<prepend signal=>

	M<monitor-signals>
	<description Monitor only DBus signals>
	<lazy>
	<build
		dbus-monitor --session <nx@T/\>;
	>

	I<%interface>
	<description Match DBus messages by interface>
	<default interface=org.freedesktop.DBus>
	<prepend interface=>
	<regex ^[A-Za-z0-9_.]+$>

	i<monitor-interface>
	<description Monitor messages for a specific interface>
	<lazy>
	<build
		dbus-monitor --session <nx@I/\>;
	>

	N<%member>
	<description Match DBus messages by member name>
	<prepend member=>
	<regex ^[A-Za-z0-9_]+$>

	n<monitor-member>
	<description Monitor messages for a specific member>
	<lazy>
	<build
		dbus-monitor --session <nx@N/\>;
	>

	S<%sender>
	<description Match DBus messages by sender unique or well-known name>
	<prepend sender=>
	<regex ^[A-Za-z0-9_.:]+$>

	s<monitor-sender>
	<description Monitor messages from a specific sender>
	<lazy>
	<build
		dbus-monitor --session <nx@S/\>;
	>

	D<%destination>
	<description Match DBus messages by destination>
	<lazy>
	<prepend destination=>
	<regex ^[A-Za-z0-9_.]+$>

	d<monitor-destination>
	<description Monitor messages sent to a specific destination>
	<lazy>
	<build
		dbus-monitor --session <nx@D/\>;
	>

	A<%arg>
	<description Match DBus messages where arg0 matches>
	<prepend arg0=>
	<regex ^[A-Za-z0-9_.:/-]+$>

	a<monitor-arg>
	<description Monitor messages where arg0 matches a value>
	<lazy>
	<build
	    dbus-monitor --session <nx@A/\>;
	>

	X<%ping-target>
	<default org.freedesktop.DBus>
	<description Ping a DBus service using Peer.Ping>
	<regex ^[A-Za-z0-9_.]+$>

	x<ping>
	<description Ping a DBus service>
	<lazy>
	<build
		dbus-send --session \
			--dest=<nx@X/\> \
			/org/freedesktop/DBus \
			org.freedesktop.DBus.Peer.Ping;
	>

	O<%owner-target>
	<default org.freedesktop.DBus>
	<description Query the unique name that owns a DBus name>
	<regex ^[A-Za-z0-9_.]+$>

	o<owner>
	<description Show the unique name that owns a DBus name>
	<lazy>
	<build
		dbus-send --session \
			--dest=org.freedesktop.DBus \
			/org/freedesktop/DBus \
			org.freedesktop.DBus.GetNameOwner \
			string:<nx@O/\>;
	>

	Q<%request-name>
	<default org.example.Test>
	<description Request a DBus name>
	<regex ^[A-Za-z0-9_.]+$>

	q<request>
	<description Request a DBus name on the session bus>
	<lazy>
	<build
		dbus-send --session \
			--dest=org.freedesktop.DBus \
			/org/freedesktop/DBus \
			org.freedesktop.DBus.RequestName \
			string:<nx@Q/\> uint32:0;
	>

	R<%release-name>
	<default org.example.Test>
	<description Release a DBus name>
	<regex ^[A-Za-z0-9_.]+$>

	r<release>
	<description Release a DBus name>
	<lazy>
	<build
		dbus-send --session \
			--dest=org.freedesktop.DBus \
			/org/freedesktop/DBus \
			org.freedesktop.DBus.ReleaseName \
			string:<nx@R/\>;
	>

	v<daemon-version>
	<description Show dbus-daemon version>
	<lazy>
	<build dbus-daemon --version;>

	A<address>
	<description Print the session bus address>
	<lazy>
	<build dbus-daemon --print-address --session;>

	B<run-session>
	<description Start a temporary DBus session and run a shell>
	<lazy>
	<build dbus-run-session -- ${SHELL:-sh};>

	P<%path>
	<description Match DBus messages by object path>
	<default path=/org/freedesktop/DBus>
	<prepend path=>
	<regex ^/([A-Za-z0-9_]+/?)*$>

	p<monitor-path>
	<description Monitor messages for a specific object path>
	<lazy>
	<build
		dbus-monitor --session <nx@P/\>;
	>

	ix<introspect>
	<description Introspect a DBus service (raw XML)>
	<default org.freedesktop.DBus>
	<regex ^[A-Za-z0-9_.]+$>
	<lazy>
	<build
		dbus-send --session \
			--dest=<nx@ix/\> \
			/ \
			org.freedesktop.DBus.Introspectable.Introspect;
	>

	help<h>
	<description Show help>
	<build exit;>
	' "$@"
	__nx_data_longopt_eval
)

