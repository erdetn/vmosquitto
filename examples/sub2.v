module main

import vmosquitto as vmq
import rand

fn get_temperature() int {
	temp := rand.int_in_range(10, 100) or { return 0 }
	return temp
}

fn on_connect(mq &vmq.Mosquitto, obj voidptr, reason_code int) {
	println('on_connect: ${reason_code}')
}

fn on_sub(mq &vmq.Mosquitto, bj voidptr, mid int, qos_count int, granted_qos &int) {
	println('on_sub: mid=${mid} ${qos_count}')
}

fn on_msg(mq &vmq.Mosquitto, obj voidptr, msg &vmq.Message) {
	println('on_sub: ${msg.str()}')
}

fn on_log(m &vmq.Mosquitto, obj voidptr, level vmq.Log, log_str &char) {
	unsafe {
		log := log_str.vstring()
		println('${level}: ${log}')
	}
}

fn main() {
	// client := vmq.new('sub1', true)
	client := vmq.new(vmq.random_id, true)

	client.on_connect(on_connect)
	client.on_subscribe(on_sub)
	client.on_message(on_msg)
	client.on_log(on_log)

	if client.connect('127.0.0.1', 1883, 1000, vmq.no_bind_addr, false) != .ok {
		println('failed to connect')
		client.destroy()
		return
	}
	defer {
		client.disconnect()
	}

	if client.will_set('sub1/will', 'I am gone', .qos1, true) != .ok {
		println('Failed to `will_set`')
	}
	if client.will_clear() == .ok {
		if client.will_set('sub1/will', '2nd notification', .qos1, true) != .ok {
			println('Failed to set the 2nd `will_set`')
		}
	} else {
		println('Failed to revoke (clear) will message.')
	}

	if client.set_account('erdetn', '1234') != .ok {
		println('Failed to set account')
	}

	if client.connect('127.0.0.1', 1883, 1000, vmq.no_bind_addr, false) != .ok {
		println('failed to connect')
		client.destroy()
		return
	}

	mut topics := []vmq.Topic{}
	topics << vmq.Topic{
		topic: '/miza/get/temp'
		qos: .qos1
	}

	client.subscribe(topics)

	client.loop(true, -1)
}
