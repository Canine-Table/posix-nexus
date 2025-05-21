function nx_tui_log(V, D)
{
	return "(\n\tFile: " V["fl"] "\n\tLine: " V["ln"] "\n\tPage: " V["pg"] "\n\tRecord: " V["rcnt"] "\n\tField: " V["rec"] "\n\tState: " V["ste"] "\n): " D
}

function nx_tui_log_db(V, N, D, B)
{
	if (length(V)) {
		return nx_log_db(N, D, B, V)
	} else {
		# Empty input (1)
		nx_grid_stack(db, "Dialog attempted without entries. JSON is deeply concerned—what exactly were you planning to display?", 1)
		nx_grid_stack(db, "Critical error! '<nx:placeholder/>' is missing—this dialog is an empty void, a message without a voice!", 1)
		nx_grid_stack(db, "Parsing failure detected! '<nx:placeholder/>' is undefined—dialog execution aborted due to structural instability!", 1)
	}
}

# Function to map box-drawing characters for UI elements
# V: Dictionary to store characters
# D: Specifies the box style ('s' for single-line, 'd' for double-line)
function __nx_box_map(V, D)
{
	D = tolower(D)	# Convert mode to lowercase for uniform processing
	# Single-line border characters
	if (D == "s") {
		V["ulc"] = "┌"	# Upper-left corner
		V["llc"] = "└"	# Lower-left corner
		V["urc"] = "┐"	# Upper-right corner
		V["lrc"] = "┘"	# Lower-right corner
		V["vrl"] = "├"	# Left vertical connector
		V["vll"] = "┤"	# Right vertical connector
		V["hd"] = "┬"	# Top horizontal connector
		V["hu"] = "┴"	# Bottom horizontal connector
		V["hv"] = "┼"	# Center intersection
		V["hl"] = "─"	# Horizontal line
		V["vl"] = "│"	# Vertical line
	}
	# Double-line border characters
	else if (D == "d") {
		V["ulc"] = "╔"	# Upper-left corner
		V["llc"] = "╚"	# Lower-left corner
		V["urc"] = "╗"	# Upper-right corner
		V["lrc"] = "╝"	# Lower-right corner
		V["vr"] = "╠"	# Left vertical connector
		V["vl"] = "╣"	# Right vertical connector
		V["hd"] = "╦"	# Top horizontal connector
		V["hu"] = "╩"	# Bottom horizontal connector
		V["hv"] = "╬"	# Center intersection
		V["hl"] = "═"	# Horizontal line
		V["vl"] = "║"	# Vertical line
	}

	# Additional graphic characters (if the variable B is set)
	if (B) {
		V["thb"] = "▀"	# Upper half block
		V["bs"] = "■"	# Solid block
		V["bhb"] = "▄"	# Lower half block
		V["gb"] = "█"	# Full block
		V["ldd"] = "░"	# Light shading
		V["mdd"] = "▒"	# Medium shading
		V["hdd"] = "▓"	# Heavy shading
		V["vbb"] = "¦"	# Broken vertical bar
		V["ldi"] = "ı"	# Small vertical bar
		V["ms"] = "¯"	# Overbar
		V["ln"] = "¬"	# Logical negation
	}
}

function nx_tui_return(V1, V2, V3, V4, B, V5)
{

	# TODO
	if (V3[V2["cr"]] == "\x0a" || (0 in V1 && int(V[0]) > 0 && V2["rln"] > V1[0])) {
		if (0 in V1 && int(V[0]) > 0 && V1[0] < V2["rln"]) {
			split(V1[V2["rln"]], V4, "")
			for (; V2["rcnt"] <= V2["col"]; V2["rcnt"]++) {
				V2["rec"] = V2["rec"] __nx_else(V4[V2["rcnt"]], " ")
			}
			V1[V2["rln"]] = V2["rec"]
			V2["rec"] = V2["rrec"]
			V2["rrec"] = ""
			V2["rcnt"] = length(V2["rec"])
		} else {
			V2["ta"] = split(V2["rrec"], V4, "")
			for (V2["rcnt"]++; V2["rcnt"] <= V2["ta"]; V2["rcnt"]++)
				V2["rec"] = V2["rec"] V4[V2["rcnt"]]
			V2["rrec"] = ""
		}

		if (V3[V2["cr"]] == "\x0a") {
			V1[++V1[0]] = nx_append_str(" ", V2["col"] - V2["rcnt"], V2["rec"], 0)
			V2["ll"] = V1[0]
			V1[V1[0] "_line"] = V2["ln"]++
			V1[V1[0] "_page"] = V2["pg"]
			V2["rfcnt"] = 0
		}
		delete V4
		V2["ll"] = V1[0]
		V2["fcnt"] = V2["rfcnt"]
		V2["ste"] = "NX_DEFAULT"
	} else {
		if (V3[V2["cr"]] == "\x20") {
			V2["rfcnt"] = 0
			V2["pd"] = 0
		} else {
			V2["rfcnt"]++
		}
		if (++V2["rcnt"] == V2["col"]) {
			V1[++V2["rln"]] = V2["rec"]
			V2["rcnt"] = 0
			V2["rec"] = ""
		}
		V2["rec"] = V2["rec"] V3[V2["cr"]]
		#if (V3[V2["cr"]] ~ /[\x09\x0b\x0d\x08\x0a\x0c\x1b]/) {
		#	nx_tui_escape(V1, V2, V3, B, V5)
	}
}

function nx_tui_fold(V1, V2, V3, B, V4)
{
	# **Step 1: Check if the current field fits within the column width**
	# If the number of characters in the field (`fcnt`) is less than the column width (`col`),
	# we determine how much of the remaining record can be added before wrapping.
	if (V2["fcnt"] < V2["col"]) {
		if (B > 2)
			print nx_log_alert(nx_tui_log(V2, "Folding " V2["rec"]))
		# **Step 2: Determine how much of the current record has already been processed**
		# `ta` calculates the remaining characters that are part of the ongoing record.
		V2["ta"] = V2["rcnt"] - V2["fcnt"]

		# **Step 3: Compute necessary padding for alignment**
		# Ensures proper word wrapping without abrupt shifts in visual formatting.
		V2["pd"] = V2["col"] - V2["ta"] + 1

		# **Step 4: Store the portion that fits within the current column width**
		# A new entry in the stack (`V3`) is created, ensuring proper spacing.
		V1[++V1[0]] = nx_append_str(" ", V2["pd"], substr(V2["rec"], 1, V2["ta"] - 1), 0)

		# **Step 5: Update the record by removing processed text**
		# `rec` now contains only the remaining unprocessed portion.
		V2["rec"] = substr(V2["rec"], V2["ta"] + 1)

		# **Step 6: Reset counters to reflect changes**
		# The record count (`rcnt`) aligns with the number of characters currently in the field (`fcnt`).
		V2["rcnt"] = V2["fcnt"]
	} else {
		# **Step 7: Handle cases where padding needs adjustment**
		# If `pd` is set, it indicates extra space was reserved earlier.
		if (V2["pd"]) {
			# **Step 8: Append leftover field content to the previous entry**
			# This ensures continuity and prevents artificial splitting.
			V1[V1[0]] = substr(V1[V1[0]], 1, V2["col"] - V2["pd"] + 1) substr(V2["rec"], 1, V2["pd"] - 1)

			# **Step 9: Remove processed content and reset record**
			V2["rec"] = substr(V2["rec"], V2["pd"])
			V2["rcnt"] = length(V2["rec"])
			if (B > 2)
				print nx_log_alert(nx_tui_log(V2, "Wrapping " V2["rec"]))
			# **Step 10: Reset padding tracker**
			V2["pd"] = 0
		} else {
			# **Step 11: If no padding adjustments are needed, store the full field**
			# Ensures fields remain contiguous without unnecessary fragmentation.
			V1[++V1[0]] = V2["rec"]
			V2["rec"] = ""
			V2["rcnt"] = 0
		}

		# **Step 12: Align field tracking with record count**
		# Ensures proper character alignment for subsequent iterations.
		V2["fcnt"] = V2["rcnt"]
	}

	# **Step 13: Assign tracking metadata for page and line markers**
	# These markers assist in structuring output when further processing occurs.
	V1[V1[0] "_ln"] = "~"
	V1[V1[0] "_pg"] = "~"
}

function nx_tui_escape(V1, V2, V3, B, V4)
{
	# **Handling Tab (\x09)**
	# Tabs require dynamic spacing based on the current record position.
	if (V3[V2["cr"]] == "\x09") { # Tab
		# Instead of inserting a fixed amount of spaces, this ensures alignment to the next tab stop.
		V2["ta"] = __nx_else(V2["rcnt"] % V2["tsz"], V2["tsz"])  # Calculate remaining spaces to the next tab stop.
		if ((V2["tb"] = V2["ta"] + V2["rcnt"]) >= V2["col"]) {	# If tab extends beyond the column width...
			if (V2["tc"] = V2["tb"] % V2["col"]) {	# Check how much of the tab fits.
				V1[++V1[0]] = nx_append_str(" ", V2["ta"] - V2["tc"], V2["rec"], 0)  # Append partial tab spacing.
				V1["rec"] = nx_append_str(" ", V2["tc"])  # Push the remainder into the next record.
			} else {
				V1[++V1[0]] = nx_append_str(" ", V2["ta"], V2["rec"], 0)  # If it fits perfectly, append full tab spacing.
				V2["rec"] = ""
			}
			# Add tracking markers for new line/page entries.
			V1[V1[0] "_ln" ] = "~"
			V1[V1[0] "_pg"] = "~"
		} else {
			# If the tab fits within the column width, append it directly.
			V2["rcnt"] = V2["rcnt"] + V2["ta"]
			V2["rec"] = nx_append_str(" ", V2["ta"], V2["rec"], 0)
		}
		if (B > 3)
			print nx_log_debug(nx_tui_log(V2, V2["tsz"] " Space Tab (\\x09)"))
		V2["rcnt"] = length(V2["rec"])	# Update record count.
	# **Handling Vertical Tab (\x0b)**
	# Moves the cursor down a line but maintains horizontal alignment.
	# This ensures vertical spacing without affecting text formatting.
	} else if (V3[V2["cr"]] == "\x0b") {
		V1[++V1[0]] = nx_append_str(" ", V2["col"] - V2["rcnt"], V2["rec"], 0)	# Fill remaining spaces for alignment.
		V2["rec"] = nx_append_str(" ", --V2["rcnt"])  # Adjust record to prepare for the next line.
		V1[V1[0] "_ln" ] = "~"
		V1[V1[0] "_pg"] = "~"
		if (B > 3)
			print nx_log_debug(nx_tui_log(V2, "Vertical Tab (\\x0b)"))
	# **Handling Carriage Return (\x0d)**
	# Moves to the beginning of the line. If not followed by a newline, triggers a special return state.
	} else if (V3[V2["cr"]] == "\x0d") {
		if (V2["len"] > V2["cr"] && V3[V2["cr"] + 1] != "\n") {
			V2["ste"] = "NX_RETURN"  # Switch state for return processing.
			V2["rln"] = V2["ll"]
			if (V2["rrec"] == "") {
				V2["rrec"] = V2["rec"]
				V2["rfcnt"] = V2["fcnt"]
			}
			V2["fcnt"] = 0
			V2["rcnt"] = 0
			V2["rec"] = ""
			if (B > 3)
				print nx_log_debug(nx_tui_log(V2, "Carrage Return (\\x0d)"))
		}
	# **Handling Backspace (\x08)**
	# Removes the last character from the record, or backtracks if necessary.
	} else if (V3[V2["cr"]] == "\x08") {
		if (V2["rcnt"]) {
			V2["rec"] = substr(V2["rec"], 1, --V2["rcnt"])	# Remove last character.
		} else if (V3[0]) {  # If record is empty, backtrack into the previous stack entry.
			V2["rcnt"] = length(V1[V1[0]]) - 1  # Adjust record count.
			V2["rec"] = substr(V1[V1[0]], 1, V2["rcnt"])  # Restore previous data.
			delete V1[V1[0] "_ln"]	# Cleanup tracking markers.
			delete V1[V1[0] "_pg"]
			delete V1[V1[0]--]  # Remove last stored entry.
		}
		if (B > 3)
			print nx_log_debug(nx_tui_log(V2, "Backspace (\\x08)"))
	# **Handling Newline (\x0a) or Formfeed (\x0c)**
	# Ensures proper text flow, advancing to a new line or page when necessary.
	} else if (V3[V2["cr"]] ~ /[\x0a|\x0c]/) {
		V1[++V1[0]] = nx_append_str(" ", V2["col"] - V2["rcnt"], V2["rec"], 0)	# Fill remaining spaces.
		if (V3[V2["cr"]] == "\x0a") {  # Newline: Move to next line.
			V2["ll"] = V1[0]  # Update last line reference.
			V1[V1[0] "_line"] = V2["ln"]++	# Increment line counter.
			V1[V1[0] "_page"] = V2["pg"]  # Maintain current page.
			if (B > 3)
				print nx_log_debug(nx_tui_log(V2, "Newline (\\x0a)"))
		} else {  # Formfeed: Move to next page.
			V2["lf"] = V1[0]  # Update last formfeed reference.
			V1[V1[0] "_ln"] = V2["ln"]
			V1[V1[0] "_pg"] = V2["pg"]++
			if (B > 3)
				print nx_log_debug(nx_tui_log(V2, "Formfeed (\\x0c)"))
		}
		V2["rec"] = ""	# Reset record for new line/page.
		V2["rcnt"] = 0	# Reset character count.
	# **Handling Escape (\x1b)**
	# Switches to ANSI escape processing mode.
	} else if (V3[V2["cr"]] == "\x1b") {
		if (B > 3)
			print nx_log_debug(nx_tui_log(V2, "Escape (\\x1b)"))
		V2["ste"] = "NX_CODE"
	}
	# **Final Cleanup**
	# Ensure pending adjustments don’t interfere with further processing.
	V2["pd"] = 0
	if (V2["ste"] != "NX_CODE")
		V2["fcnt"] = 0	# Reset field count if not processing an escape sequence.
}

function nx_tui_prop(V1, V2, B, V4)
{
	# Initialize padding and margin values
	V2["pdr"] = 0  # Right padding
	V2["pdl"] = 0  # Left padding
	V2["mgr"] = 0  # Right margin
	V2["mgl"] = 0  # Left margin

	# Retrieve terminal dimensions from environment variables
	V2["row"] = ENVIRON["G_NEX_TTY_ROWS"]	  # Number of terminal rows
	V2["col"] = ENVIRON["G_NEX_TTY_COLUMNS"]   # Number of terminal columns
	
	# Set tab size, defaulting to 8 if not explicitly specified
	V2["tsz"] = __nx_else(int(ENVIRON["G_NEX_TTY_TABS"]), 8)

	# Configure padding values based on environment settings
	if (int(ENVIRON["G_NEX_TTY_PADDING"]) != 0) {
		# Apply the same padding on both sides if a general value is set
		V2["pdl"] = ENVIRON["G_NEX_TTY_PADDING"]
		V2["pdr"] = ENVIRON["G_NEX_TTY_PADDING"]
	} else {
		# Apply individual left and right padding values if specified
		if (int(ENVIRON["G_NEX_TTY_PAD_LEFT"]) != 0)
			V2["pdl"] = ENVIRON["G_NEX_TTY_PAD_LEFT"]
		if (int(ENVIRON["G_NEX_TTY_PAD_RIGHT"]) != 0)
			V2["pdr"] = ENVIRON["G_NEX_TTY_PAD_RIGHT"]
	}

	# Configure margin values based on environment settings
	if (int(ENVIRON["G_NEX_TTY_MARGINS"]) != 0) {
		# Apply a uniform margin if a general value is set
		V2["mgr"] = ENVIRON["G_NEX_TTY_MARGINS"]
		V2["mgl"] = ENVIRON["G_NEX_TTY_MARGINS"]
	} else {
		# Apply individual left and right margins if specified
		if (int(ENVIRON["G_NEX_TTY_MARGIN_LEFT"]) != 0)
			V2["mgl"] = ENVIRON["G_NEX_TTY_MARGIN_LEFT"]
		if (int(ENVIRON["G_NEX_TTY_MARGIN_RIGHT"]) != 0)
			V2["mgr"] = ENVIRON["G_NEX_TTY_MARGIN_RIGHT"]
	}

	# Adjust the column width by subtracting padding and margin values
	V2["col"] = V2["col"] - (V2["pdr"] + V2["pdl"] + V2["mgr"] + V2["mgl"])

	if (B > 4) {  # Debug mode enabled
		print nx_log_info("Initializing TUI Properties")
		print nx_log_info("(\n\tTerminal Size: '" V2["row"] "x" V2["col"] "'\n\tPadding: [ Left: '" V2["pdl"] "', Right = '" V2["pdr"] "' ]\n\tMargin: [ Left: '" V2["mgl"] "', Right: '" V2["mgr"] "' ]\n\tBox Style: '" __nx_if(V2["bx"] == "s", "single lines", "double lines") "'\n)", 1)
	}

	# If box styling is requested ('s' for single-line, 'd' for double-line)
	if ((V2["bx"] = tolower(ENVIRON["G_NEX_TTY_BOX"])) ~ /[sd]/) {
		__nx_box_map(V2, V2["bx"])  # Apply box-drawing characters
		V2["col"] = V2["col"] - 2  # Adjust width to accommodate borders

		# Append necessary strings for UI formatting
		V1["hl"] = nx_append_str(V2["hl"], V2["col"] + V2["pdr"] + V2["pdl"]) # Horizontal line filling width

		# Convert padding and margins into space strings for proper alignment
		V2["pdr"] = nx_append_str(" ", V2["pdr"])
		V2["pdl"] = nx_append_str(" ", V2["pdl"])
		V2["mgr"] = nx_append_str(" ", V2["mgr"])
		V2["mgl"] = nx_append_str(" ", V2["mgl"])

		# Define UI border components using ANSI escape sequences
		V1["lvl"]  = "\x1b[0m" V2["pdl"] V2["vl"] V2["mgl"] # Left vertical border
		V1["lvr"]  = "\x1b[0m" V2["mgr"] V2["vl"] V2["pdr"] # Right vertical border
		V1["tbdr"] = "\x1b[0m" V2["pdl"] V2["ulc"] V1["hl"] V2["urc"] V2["pdr"] # Top border
		V1["mbdr"] = "\x1b[0m" V2["pdl"] V2["vrl"] V1["hl"] V2["vll"] V2["pdr"] # Middle border
		V1["dbdr"] = "\x1b[0m" V2["pdl"] V2["vl"] V1["hl"] V2["vl"] V2["pdr"]  # Double vertical border (if needed)
		V1["bbdr"] = "\x1b[0m" V2["pdl"] V2["llc"] V1["hl"] V2["lrc"] V2["pdr"] # Bottom border
	}
}

function nx_tui_machine(V1, V2, V3, V4, B, V5)
{
	# Iterate through each character in the input stream.
	for (V2["cr"] = 1; V2["cr"] <= V2["len"]; V2["cr"]++) {
		# Core processing happens in NX_DEFAULT, handling escape sequences and word wrapping.
		if (V2["ste"] == "NX_DEFAULT") {
			# Handle special control characters (excluding \r and \e).
			# These influence how text is structured but do not modify the overall logic of records and fields.
			if (V3[V2["cr"]] ~ /[\x09\x0b\x0d\x08\x0a\x0c\x1b]/) {
				nx_tui_escape(V1, V2, V3, B, V5)
			} else {
				# Reset `fcnt` when encountering a space, signifying a field boundary.
				if (V3[V2["cr"]] == "\x20") {
					V2["fcnt"] = 0
					V2["pd"] = 0
				} else {
					V2["fcnt"]++  # Increase character count within current field.
				}
				# Append the character to the active record.
				V2["rec"] = V2["rec"] V3[V2["cr"]]
				# If the accumulated record reaches column width, wrap the line.
				if (++V2["rcnt"] >= V2["col"]) {
					nx_tui_fold(V1, V2, V3, B, V5)	# Move excess content to a new line.
				}
			}
		} else if (V2["ste"] == "NX_RETURN") {
			nx_tui_return(V1, V2, V3, V4, B, V5)
		}
	}
	# If there is remaining content, store it before terminating.
	if (V2["rec"] != "") {
		if (B > 2)
			print nx_log_alert(nx_tui_log(V2, "Extra " V2["rec"]))
		V1[++V1[0]] = nx_append_str(" ", V2["col"] - V2["rcnt"], V2["rec"], 0)
		V1[V1[0] "_ln"] = "~"
		V1[V1[0] "_pg"] = "~"
	}
}

function nx_tui(D, V, B,	tok, rec, rtn, db)
{
	nx_tui_log_db(db)
	if (D == "") {
		if (B)
			print nx_log_error(nx_tui_log_db(db, 1, "", 1))
		return 10
	}

	nx_tui_prop(V, tok, B)
	# Initialize record tracking variables.
	tok["ste"] = "NX_DEFAULT"  # Start in the default state.
	tok["ln"] = 1  # Line number tracking.
	tok["ll"] = 1  # Last line reference.
	tok["pg"] = 1  # Page number tracking.
	tok["lf"] = 1  # Last form feed reference.
	if (nx_is_file(D)) {
		tok["fl"] = D
		while ((getline tok["len"] < tok["fl"]) > 0) {
			tok["len"] = split(tok["len"], rec, "")
			if (nx_tui_machine(V, tok, rec, rtn, B, db))
				break
			++tok["ln"]
		}
		close(tok["fl"])
	} else {
		tok["fl"] = "-"
		tok["len"] = split(D, rec, "")
		nx_tui_machine(V, tok, rec, rtn, B, db)
	}
	D = tok["err"]
	delete db; delete tok; delete rec
	return D
}

