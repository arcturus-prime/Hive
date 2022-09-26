--!strict

-- Helper Types --
type Channel = {
	handlers: { [string]: (...any) -> ...any },	
	results: ConservativeBuffer
}

-- Exported Types --
export type ConservativeBuffer = { any }
export type RemoteChannel = Channel & { cx: RemoteEvent }
export type LocalChannel = Channel & { tx: BindableEvent, rx: BindableEvent }