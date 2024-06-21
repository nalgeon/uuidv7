function! s:uuidv7() abort
	let timestamp_str = ''

	if has('win32') || has('win64')
		let timestamp_str = system('powershell -Command "[DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()"')
	elseif has('macunix') || has('osxdarwin') || has('osx') || has('bsd')
		" Has coreutils from Homebrew
		if executable('gdate')
			let timestamp_str = system('gdate +%s%3N')
		else
			" POSIX (incl. BSD) date doesn't have the right precision
			let timestamp_str = system('$(date +%s)') . '000'
		endif
	elseif has('linux')
		let timestamp_str = system('date +%s%3N')
	else
		if executable('python')
			let timestamp_str = system('python -c "import time; print(int(time.time() * 1000))"')
		elseif executable('perl')
			let timestamp_str = system('perl -MTime::HiRes -e "print int(Time::HiRes::time() * 1000);"')
		elseif executable('ruby')
			let timestamp_str = system('ruby -e "puts (Time.now.to_f * 1000).to_i"')
		elseif executable('tclsh')
			let timestamp_str = system('tclsh <<< "puts [expr {[clock milliseconds]}]"')
		else
			let timestamp = localtime() * 1000
		endif
	endif

	if timestamp_str != ''
		let timestamp = str2nr(timestamp_str)
	endif
	let uuid = []

	for i in range(0, 15)
		if i < 6
			call add(uuid, and(timestamp >> (40 - 8*i), 255))
		else
			call add(uuid, rand() % 256)
		endif
	endfor

	let uuid[6] = or(and(uuid[6], 15), 112)
	let uuid[8] = or(and(uuid[8], 63), 128)

	return uuid
endfunction

function! s:bytes_to_hexstring(bytes) abort
	let hexstring = ''
	for byte in a:bytes
		let hex = printf("%02x", byte)
		let hexstring .= hex
	endfor
	return hexstring
endfunction

let uuid_bytes = s:uuidv7()
let hex_uuid = s:bytes_to_hexstring(uuid_bytes)
echo hex_uuid

