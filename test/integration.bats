#!/usr/bin/env bats

setup() {
	. ./test/lib/test-helper.sh
	mock_path test/bin
}

@test "./nsupdate-wrapper.sh" {
	run ./nsupdate-wrapper.sh
	[ "$status" -eq 11 ]
}

@test "./nsupdate-wrapper.sh -h" {
	run ./nsupdate-wrapper.sh -h
	[ "$status" -eq 0 ]
}

@test "./nsupdate-wrapper.sh full example" {
	run ./nsupdate-wrapper.sh \
		--zone=example.com. \
		--name-server=ns.example.com \
		--record=sub.example.com. \
		--device=eno1 \
		--literal-key='hmac-sha256:example.com:n+WgaHXqgopqlovvjfwnF+TEDUVIQXIXQ0ni+HOQew8='
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = 'Input: server ns.example.com' ]
	[ "${lines[1]}" = 'Input: zone example.com.' ]
	[ "${lines[2]}" = 'Input: update delete sub.example.com. A' ]
	[ "${lines[3]}" = 'Input: update add sub.example.com. 3600 A 1.2.3.4' ]
	[ "${lines[4]}" = 'Input: show' ]
	[ "${lines[5]}" = 'Input: send' ]
	[ "${lines[6]}" = 'Arg: -y' ]
	[ "${lines[7]}" = 'Arg: hmac-sha256:example.com:n+WgaHXqgopqlovvjfwnF+TEDUVIQXIXQ0ni+HOQew8=' ]
	[ "${lines[8]}" = 'Input: server ns.example.com' ]
	[ "${lines[9]}" = 'Input: zone example.com.' ]
	[ "${lines[10]}" = 'Input: update delete sub.example.com. AAAA' ]
	[ "${lines[11]}" = 'Input: update add sub.example.com. 3600 AAAA 200c:ef45:4c06:3300:b832:fe2d:bb21:60bd' ]
	#echo ${lines[11]} > $HOME/debug
}