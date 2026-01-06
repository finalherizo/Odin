// Bindings for [[ SDL3 Net ; https://wiki.libsdl.org/SDL3_net/FrontPage ]].
package sdl3_net

import SDL ".."
import "base:intrinsics"
import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "SDL3_net.lib"
} else {
	foreign import lib "system:SDL3_net"
}

bool :: distinct b32

MAJOR_VERSION :: 3
MINOR_VERSION :: 0
PATCHLEVEL :: 0

SocketType :: enum c.int {
	SOCKETTYPE_STREAM,
	SOCKETTYPE_DATAGRAM,
	SOCKETTYPE_SERVER,
}

AddressType :: enum c.int {
	NET_ADDRTYPE_UNKNOWN = -1,
	NET_ADDRTYPE_UNICAST,
	NET_ADDRTYPE_MULTICAST,
	NET_ADDRTYPE_BROADCAST,
}

Address :: struct {
	hostname:       cstring,
	human_readable: cstring,
	errstr:         cstring,
	refcount:       SDL.AtomicInt,
	status:         SDL.AtomicInt,
	type:           AddressType,
	ainfo:          rawptr,
	resolver_next:  ^Address,
}

Status :: enum c.int {
	NET_FAILURE = -1,
	NET_WAITING = 0,
	NET_SUCCESS = 1,
}

@(default_calling_convention = "c", link_prefix = "NET_")
foreign lib {
	Version :: proc() -> c.int ---

	Init :: proc() -> bool ---
	Quit :: proc() ---

	ResolveHostname :: proc(host: cstring) -> ^Address ---
	WaitUntilResolved :: proc(address: ^Address, timeout: SDL.Sint32) -> Status ---
	GetAddressStatus :: proc(address: ^Address) -> Status ---
	GetAddressString :: proc(address: ^Address) -> cstring ---
	RefAddress :: proc(address: ^Address) -> ^Address ---
	UnrefAddress :: proc(address: ^Address) ---
	SimulateAddressResolutionLoss :: proc(_: c.int) ---
	CompareAddresses :: proc(a, b: ^Address) -> c.int ---
	GetLocalAddresses :: proc(num_addresses: ^c.int) -> [^]^Address ---
	FreeLocalAddresses :: proc(addresses: [^]^Address) ---
}
