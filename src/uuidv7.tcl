package require Tcl 8.6

namespace eval uuidv7 {
    namespace export uuidv7
}

proc ::uuidv7::generate { } {
    # random bytes
    set randomBytes {}
    for {set i 0} {$i < 16} {incr i} {
        lappend randomBytes [expr {int(rand() * 256)}]
    }

    # current timestamp in ms
    set timestamp_ms [expr {[clock milliseconds]}]

    # timestamp
    set timestamp_bytes {}
    for {set i 5} {$i >= 0} {incr i -1} {
        lappend timestamp_bytes [expr {($timestamp_ms >> ($i * 8)) & 0xFF}]
    }

    # version and variant
    set bytes [lreplace $randomBytes 0 5 {*}$timestamp_bytes]
    lset bytes 6 [expr {([lindex $bytes 6] & 0x0F) | 0x70}]
    lset bytes 8 [expr {([lindex $bytes 8] & 0x3F) | 0x80}]

    return [binary format c* $bytes]
}

proc ::uuidv7::tostring { uuid } {
    binary scan $uuid H* s
    return [string tolower $s]
}

puts [uuidv7::tostring [uuidv7::generate]]
