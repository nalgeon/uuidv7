function! s:uuidv7() abort
	let timestamp = localtime() * 1000
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
