// Bindings for [[ SDL3 Net ; https://wiki.libsdl.org/SDL3_net/FrontPage ]].
package sdl3_net

import SDL ".."
import "base:intrinsics"
import "core:c"
import "core:image/netpbm"

SDL_NET_USE_SYSTEM :: #config(SDL_NET_USE_SYSTEM, true)

when ODIN_OS == .Windows {
	foreign import lib "SDL3_net.lib"
} else when ODIN_OS == .Darwin && !SDL_NET_USE_SYSTEM {
	foreign import lib "macos/libSDL3_net.dylib"
} else {
	foreign import lib "system:SDL3_net"
}

bool :: distinct b32

MAJOR_VERSION :: 3
MINOR_VERSION :: 0
PATCHLEVEL :: 0

Address :: distinct rawptr

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

StreamSocket :: distinct rawptr

@(default_calling_convention = "c", link_prefix = "NET_")
foreign lib {
	CreateClient :: proc(addr: ^Address, port: SDL.Uint16) -> ^StreamSocket ---
	CheckClientConnection :: proc(sock: ^StreamSocket, timeoutms: c.int) -> Status ---
	WaitUntilConnected :: proc(sock: ^StreamSocket, tomeout: SDL.Sint32) -> Status ---
	GetConnectionStatus :: proc(sock: ^StreamSocket) -> Status ---
}

Server :: distinct rawptr

@(default_calling_convention = "c", link_prefix = "NET_")
foreign lib {
	CreateServer :: proc(addr: ^Address, port: SDL.Uint16) -> ^Server ---
	AcceptClient :: proc(server: ^Server, client_stream: ^^StreamSocket) -> bool ---
	DestroyServer :: proc(server: ^Server) ---

	GetStreamSocketAddress :: proc(sock: ^StreamSocket) -> ^Address ---
	WriteToStreamSocket :: proc(sock: ^StreamSocket, buff: rawptr, buflen: c.int) -> bool ---
	GetStreamSocketPendingWrites :: proc(sock: ^StreamSocket) -> c.int ---
	WaitUntilStreamSocketDrained :: proc(sock: ^StreamSocket, timeoutms: c.int) -> c.int ---
	ReadFromStreamSocket :: proc(sock: ^StreamSocket, buff: rawptr, bufflen: c.int) -> c.int ---
	SimulateStreamPacketLoss :: proc(sock: ^StreamSocket, percent_loss: c.int) ---
	DestroyStreamSocket :: proc(sock: ^StreamSocket) ---
}

DatagramSocket :: distinct rawptr

Datagram :: struct {
	addr:   ^Address,
	port:   SDL.Uint16,
	buf:    [^]SDL.Uint8,
	buflen: c.int,
}

@(default_calling_convention = "c", link_prefix = "NET_")
foreign lib {
	CreateDatagramSocket :: proc(addr: ^Address, port: SDL.Uint16) -> ^DatagramSocket ---
	SendDatagram :: proc(sock: ^DatagramSocket, add: ^Address, port: SDL.Uint16, buff: rawptr, buflen: c.int) -> bool ---
	ReceiveDatagram :: proc(sock: ^DatagramSocket, dgram: [^]^Datagram) -> bool ---
	DestroyDatagram :: proc(dgram: ^Datagram) ---
	SimulateDatagramPacketLoss :: proc(sock: DatagramSocket, percent_loss: c.int) ---
	DestroyDatagramSocket :: proc(sock: ^DatagramSocket) ---
	WaitUntilInputAvailable :: proc(vsockets: rawptr, numsockets: c.int, timeout: SDL.Sint32) -> c.int ---
}
