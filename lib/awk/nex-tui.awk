# Function to map box-drawing characters for UI elements
# V: Dictionary to store characters
# D: Specifies the box style ('s' for single-line, 'd' for double-line)
function __nx_box_map(V, D)
{
	D = tolower(D)  # Convert mode to lowercase for uniform processing
	# Single-line border characters
	if (D == "s") {
		V["ulc"] = "┌"  # Upper-left corner
		V["llc"] = "└"  # Lower-left corner
		V["urc"] = "┐"  # Upper-right corner
		V["lrc"] = "┘"  # Lower-right corner
		V["vrl"] = "├"  # Left vertical connector
		V["vll"] = "┤"  # Right vertical connector
		V["hd"] = "┬"   # Top horizontal connector
		V["hu"] = "┴"   # Bottom horizontal connector
		V["hv"] = "┼"   # Center intersection
		V["hl"] = "─"   # Horizontal line
		V["vl"] = "│"   # Vertical line
	}
	# Double-line border characters
	else if (D == "d") {
		V["ulc"] = "╔"  # Upper-left corner
		V["llc"] = "╚"  # Lower-left corner
		V["urc"] = "╗"  # Upper-right corner
		V["lrc"] = "╝"  # Lower-right corner
		V["vr"] = "╠"   # Left vertical connector
		V["vl"] = "╣"   # Right vertical connector
		V["hd"] = "╦"   # Top horizontal connector
		V["hu"] = "╩"   # Bottom horizontal connector
		V["hv"] = "╬"   # Center intersection
		V["hl"] = "═"   # Horizontal line
		V["vl"] = "║"   # Vertical line
	}
	
	# Additional graphic characters (if the variable B is set)
	if (B) {
		V["thb"] = "▀"  # Upper half block
		V["bs"] = "■"   # Solid block
		V["bhb"] = "▄"  # Lower half block
		V["gb"] = "█"   # Full block
		V["ldd"] = "░"  # Light shading
		V["mdd"] = "▒"  # Medium shading
		V["hdd"] = "▓"  # Heavy shading
		V["vbb"] = "¦"  # Broken vertical bar
		V["ldi"] = "ı"  # Small vertical bar
		V["ms"] = "¯"   # Overbar
		V["ln"] = "¬"   # Logical negation
	}
}

function nx_tui_return(tok, scrt, V)
{

}

function nx_tui_fold(V1, V2, V3)
{
	# **Step 1: Check if the current field fits within the column width**
	# If the number of characters in the field (`fcnt`) is less than the column width (`col`),
	# we determine how much of the remaining record can be added before wrapping.
	if (V1["fcnt"] < V1["col"]) {
		# **Step 2: Determine how much of the current record has already been processed**
		# `ta` calculates the remaining characters that are part of the ongoing record.
		V2["ta"] = V1["rcnt"] - V1["fcnt"]

		# **Step 3: Compute necessary padding for alignment**
		# Ensures proper word wrapping without abrupt shifts in visual formatting.
		V1["pd"] = V1["col"] - V2["ta"] + 1

		# **Step 4: Store the portion that fits within the current column width**
		# A new entry in the stack (`V3`) is created, ensuring proper spacing.
		V3[++V3[0]] = nx_append_str(" ", V1["pd"], substr(V1["rec"], 1, V2["ta"] - 1), 0)

		# **Step 5: Update the record by removing processed text**
		# `rec` now contains only the remaining unprocessed portion.
		V1["rec"] = substr(V1["rec"], V2["ta"] + 1)

		# **Step 6: Reset counters to reflect changes**
		# The record count (`rcnt`) aligns with the number of characters currently in the field (`fcnt`).
		V1["rcnt"] = V1["fcnt"]
	} else {
		# **Step 7: Handle cases where padding needs adjustment**
		# If `pd` is set, it indicates extra space was reserved earlier.
		if (V1["pd"]) {
			# **Step 8: Append leftover field content to the previous entry**
			# This ensures continuity and prevents artificial splitting.
			V3[V3[0]] = substr(V3[V3[0]], 1, V1["col"] - V1["pd"] + 1) substr(V1["rec"], 1, V1["pd"] - 1)

			# **Step 9: Remove processed content and reset record**
			V1["rec"] = substr(V1["rec"], V1["pd"])
			V1["rcnt"] = length(V1["rec"])

			# **Step 10: Reset padding tracker**
			V1["pd"] = 0
		} else {
			# **Step 11: If no padding adjustments are needed, store the full field**
			# Ensures fields remain contiguous without unnecessary fragmentation.
			V3[++V3[0]] = V1["rec"]
			V1["rec"] = ""
			V1["rcnt"] = 0
		}

		# **Step 12: Align field tracking with record count**
		# Ensures proper character alignment for subsequent iterations.
		V1["fcnt"] = V1["rcnt"]
	}

	# **Step 13: Assign tracking metadata for page and line markers**
	# These markers assist in structuring output when further processing occurs.
	V3[V3[0] "_ln"] = "~"
	V3[V3[0] "_pg"] = "~"
}

function nx_tui_escape(V1, V2, V3)
{
	# **Handling Tab (\x09)**
	# Tabs require dynamic spacing based on the current record position.
	if (V1[V1["cr"]] == "\x09") { # Tab
		# Instead of inserting a fixed amount of spaces, this ensures alignment to the next tab stop.
		V2["ta"] = __nx_else(V1["rcnt"] % V1["tsz"], V1["tsz"])  # Calculate remaining spaces to the next tab stop.
		if ((V2["tb"] = V2["ta"] + V1["rcnt"]) >= V1["col"]) {  # If tab extends beyond the column width...
			if (V2["tc"] = V2["tb"] % V1["col"]) {  # Check how much of the tab fits.
				V3[++V3[0]] = nx_append_str(" ", V2["ta"] - V2["tc"], V1["rec"], 0)  # Append partial tab spacing.
				V1["rec"] = nx_append_str(" ", V2["tc"])  # Push the remainder into the next record.
			} else {
				V3[++V3[0]] = nx_append_str(" ", V2["ta"], V1["rec"], 0)  # If it fits perfectly, append full tab spacing.
				V1["rec"] = ""
			}
			# Add tracking markers for new line/page entries.
			V3[V3[0] "_ln" ] = "~"
			V3[V3[0] "_pg"] = "~"
		} else {
			# If the tab fits within the column width, append it directly.
			V1["rcnt"] = V["rcnt"] + V2["ta"]
			V1["rec"] = nx_append_str(" ", V2["ta"], V1["rec"], 0)
		}
		V1["rcnt"] = length(V1["rec"])  # Update record count.
	# **Handling Vertical Tab (\x0b)**
	# Moves the cursor down a line but maintains horizontal alignment.
	# This ensures vertical spacing without affecting text formatting.
	} else if (V1[V1["cr"]] == "\x0b") {
		V3[++V3[0]] = nx_append_str(" ", V1["col"] - V1["rcnt"], V1["rec"], 0)  # Fill remaining spaces for alignment.
		V1["rec"] = nx_append_str(" ", --V1["rcnt"])  # Adjust record to prepare for the next line.
		V3[V3[0] "_ln" ] = "~"
		V3[V3[0] "_pg"] = "~"
	# **Handling Carriage Return (\x0d)**
	# Moves to the beginning of the line. If not followed by a newline, triggers a special return state.
	} else if (V1[V1["cr"]] == "\x0d") {
		if (V1["len"] > V1["cr"] && V1[V1["char"] + 1] != "\n") {
			V1["ste"] = "NX_RETURN"  # Switch state for return processing.
			V1["rcnt"] = 0  # Reset record count.
		}
	# **Handling Backspace (\x08)**
	# Removes the last character from the record, or backtracks if necessary.
	} else if (V1[V1["cr"]] == "\x08") {
		if (V1["rcnt"]) {
			V1["rec"] = substr(V1["rec"], 1, --V1["rcnt"])  # Remove last character.
		} else if (V3[0]) {  # If record is empty, backtrack into the previous stack entry.
			V1["rcnt"] = length(V3[V3[0]]) - 1  # Adjust record count.
			V1["rec"] = substr(V3[V3[0]], 1, V1["rcnt"])  # Restore previous data.
			delete V3[V3[0] "_ln"]  # Cleanup tracking markers.
			delete V3[V3[0] "_pg"]
			delete V3[V3[0]--]  # Remove last stored entry.
		}
	# **Handling Newline (\x0a) or Formfeed (\x0c)**
	# Ensures proper text flow, advancing to a new line or page when necessary.
	} else if (V1[V1["cr"]] ~ /[\x0a|\x0c]/) {
		V3[++V3[0]] = nx_append_str(" ", V1["col"] - V1["rcnt"], V1["rec"], 0)  # Fill remaining spaces.
		if (V1[V1["cr"]] == "\x0a") {  # Newline: Move to next line.
			V1["ll"] = V3[0]  # Update last line reference.
			V3[V3[0] "_line"] = V1["ln"]++  # Increment line counter.
			V3[V3[0] "_page"] = V1["pg"]  # Maintain current page.
		} else {  # Formfeed: Move to next page.
			V1["lf"] = V3[0]  # Update last formfeed reference.
			V3[V3[0] "_ln"] = V1["ln"]
			V3[V3[0] "_pg"] = V1["pg"]++
		}
		V1["rec"] = ""  # Reset record for new line/page.
		V1["rcnt"] = 0  # Reset character count.
	# **Handling Escape (\x1b)**
	# Switches to ANSI escape processing mode.
	} else if (V1[V1["cr"]] == "\x1b") {
		V1["ste"] = "NX_CODE"
	}
	# **Final Cleanup**
	# Ensure pending adjustments don’t interfere with further processing.
	V1["pd"] = 0
	if (V1["ste"] != "NX_CODE")
		V1["fcnt"] = 0  # Reset field count if not processing an escape sequence.
}


# Function to configure terminal UI properties and apply box styling
# V1: Dictionary storing terminal properties
# V2: Dictionary for formatted UI elements
# D: Specifies box style ('s' for single-line, 'd' for double-line)
function nx_tui_prop(V1, V2, D)
{
	# Initialize padding and margin values
	V1["pdr"] = 0  # Right padding
	V1["pdl"] = 0  # Left padding
	V1["mgr"] = 0  # Right margin
	V1["mgl"] = 0  # Left margin
	
	# Retrieve terminal dimensions from environment variables
	V1["row"] = ENVIRON["G_NEX_TTY_ROWS"]	  # Number of terminal rows
	V1["col"] = ENVIRON["G_NEX_TTY_COLUMNS"]   # Number of terminal columns
	
	# Set tab size, defaulting to 8 if not explicitly specified
	V1["tsz"] = __nx_else(int(ENVIRON["G_NEX_TTY_TABS"]), 8)

	# Configure padding values based on environment settings
	if (int(ENVIRON["G_NEX_TTY_PADDING"]) != 0) {
		# Apply the same padding on both sides if a general value is set
		V1["pdl"] = ENVIRON["G_NEX_TTY_PADDING"]
		V1["pdr"] = ENVIRON["G_NEX_TTY_PADDING"]
	} else {
		# Apply individual left and right padding values if specified
		if (int(ENVIRON["G_NEX_TTY_PAD_LEFT"]) != 0)
			V1["pdl"] = ENVIRON["G_NEX_TTY_PAD_LEFT"]
		if (int(ENVIRON["G_NEX_TTY_PAD_RIGHT"]) != 0)
			V1["pdr"] = ENVIRON["G_NEX_TTY_PAD_RIGHT"]
	}

	# Configure margin values based on environment settings
	if (int(ENVIRON["G_NEX_TTY_MARGINS"]) != 0) {
		# Apply a uniform margin if a general value is set
		V1["mgr"] = ENVIRON["G_NEX_TTY_MARGINS"]
		V1["mgl"] = ENVIRON["G_NEX_TTY_MARGINS"]
	} else {
		# Apply individual left and right margins if specified
		if (int(ENVIRON["G_NEX_TTY_MARGIN_LEFT"]) != 0)
			V1["mgl"] = ENVIRON["G_NEX_TTY_MARGIN_LEFT"]
		if (int(ENVIRON["G_NEX_TTY_MARGIN_RIGHT"]) != 0)
			V1["mgr"] = ENVIRON["G_NEX_TTY_MARGIN_RIGHT"]
	}

	# Adjust the column width by subtracting padding and margin values
	V1["col"] = V1["col"] - (V1["pdr"] + V1["pdl"] + V1["mgr"] + V1["mgl"])

	# If box styling is requested ('s' for single-line, 'd' for double-line)
	if ((D = tolower(D)) ~ /[sd]/) {
		__nx_box_map(V1, D)  # Apply box-drawing characters
		V1["col"] = V1["col"] - 2  # Adjust width to accommodate borders

		# Append necessary strings for UI formatting
		V2["hl"] = nx_append_str(V1["hl"], V1["col"] + V1["pdr"] + V1["pdl"]) # Horizontal line filling width

		# Convert padding and margins into space strings for proper alignment
		V1["pdr"] = nx_append_str(" ", V1["pdr"])
		V1["pdl"] = nx_append_str(" ", V1["pdl"])
		V1["mgr"] = nx_append_str(" ", V1["mgr"])
		V1["mgl"] = nx_append_str(" ", V1["mgl"])

		# Define UI border components using ANSI escape sequences
		V2["lvl"]  = "\x1b[0m" V1["pdl"] V1["vl"] V1["mgl"]	# Left vertical border
		V2["lvr"]  = "\x1b[0m" V1["mgr"] V1["vl"] V1["pdr"]	# Right vertical border
		V2["tbdr"] = "\x1b[0m" V1["pdl"] V1["ulc"] V2["hl"] V1["urc"] V1["pdr"] # Top border
		V2["mbdr"] = "\x1b[0m" V1["pdl"] V1["vrl"] V2["hl"] V1["vll"] V1["pdr"] # Middle border
		V2["dbdr"] = "\x1b[0m" V1["pdl"] V1["vl"] V2["hl"] V1["vl"] V1["pdr"]  # Double vertical border (if needed)
		V2["bbdr"] = "\x1b[0m" V1["pdl"] V1["llc"] V2["hl"] V1["lrc"] V1["pdr"] # Bottom border
	}
}

function nx_tui(D1, D2, V,  tok, scrt)
{
	# Split input into individual characters for processing.
	# This allows handling each character separately, enabling escape sequence detection and word wrapping.
	D1 = split(D1, tok, "")
	nx_tui_prop(tok, V, D2)
	# Initialize record tracking variables.
	tok["len"] = D1  # Total length of input.
	tok["ste"] = "NX_DEFAULT"  # Start in the default state.
	tok["ln"] = 1  # Line number tracking.
	tok["ll"] = 1  # Last line reference.
	tok["pg"] = 1  # Page number tracking.
	tok["lf"] = 1  # Last form feed reference.
	# Iterate through each character in the input stream.
	for (tok["cr"] = 1; tok["cr"] <= tok["len"]; tok["cr"]++) {
		# Core processing happens in NX_DEFAULT, handling escape sequences and word wrapping.
		if (tok["ste"] == "NX_DEFAULT") {
			# Handle special control characters (excluding \r and \e).
			# These influence how text is structured but do not modify the overall logic of records and fields.
			if (tok[tok["cr"]] ~ /[\x09\x0b\x0d\x08\x0a\x0c\x1b]/) {
				nx_tui_escape(tok, scrt, V)
			} else {
				# Reset `fcnt` when encountering a space, signifying a field boundary.
				if (tok[tok["cr"]] == "\x20") {
					tok["fcnt"] = 0
					tok["pd"] = 0
				} else {
					tok["fcnt"]++  # Increase character count within current field.
				}
				# Append the character to the active record.
				tok["rec"] = tok["rec"] tok[tok["cr"]]
				# If the accumulated record reaches column width, wrap the line.
				if (++tok["rcnt"] >= tok["col"]) {
					nx_tui_fold(tok, scrt, V)  # Move excess content to a new line.
				}
			}
		}
	}
	# If there is remaining content, store it before terminating.
	if (tok["rec"] != "") {
		V[++V[0]] = nx_append_str(" ", tok["col"] - tok["rcnt"], tok["rec"], 0)
		V[V[0] "_ln"] = "~"
		V[V[0] "_pg"] = "~"
	}
	# Clean up tracking objects.
	delete tok
	delete scrt
}

