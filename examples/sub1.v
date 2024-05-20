module main 

import vmosquitto as vmq 
import rand

fn get_temperature() int {
	temp := rand.int_in_range(10, 100) or { 
		return 0
	}
	return temp
}

fn on_connect(mq &vmq.Mosquitto, obj voidptr, reason_code int) {
	println("on_connect: ${reason_code}")
}

fn on_sub(mq &vmq.Mosquitto, bj voidptr, mid int, qos_count int, granted_qos &int) {
	println("on_sub: mid=${mid} ${qos_count}")
}

fn on_msg(mq &vmq.Mosquitto, obj voidptr, msg &vmq.Message) {
	println('on_sub: ${msg.str()}')
}

fn main() {
	// client := vmq.new('sub1', true)
	client := vmq.new(vmq.no_id, true)

	client.on_connect(on_connect)
	client.on_subscribe(on_sub)
	client.on_message(on_msg)

	if client.connect('127.0.0.1', 1883, 1000, vmq.no_bind_addr, false) != .ok {
		println('failed to connect')
		client.destroy()
		return
	}
	defer {
		client.disconnect()
	}

	mut topics := []vmq.Topic{}
	topics << vmq.Topic{
		topic: '/miza/get/temp'
		qos: .qos1
	}

	client.subscribe(topics)

	client.loop_forever(true, -1, 1)
	
}