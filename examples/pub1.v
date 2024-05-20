module main 

import vmosquitto as vmq 
import rand
import time

fn get_temperature() int {
	temp := rand.int_in_range(10, 100) or { 
		return 0
	}
	return temp
}

fn on_connect(mq &vmq.Mosquitto, obj voidptr, reason_code int) {
	println("on_connect: ${reason_code}")
}

fn on_pub(mq &vmq.Mosquitto, obj voidptr, mid int) {
	println("on_pub: mid=${mid}")
}

fn main() {
	client := vmq.new('pub1', true)


	client.on_connect(on_connect)
	client.on_publish(on_pub)

	if client.connect('127.0.0.1', 1883, 1000, vmq.no_bind_addr, false) != .ok {
		println('failed to connect')
		client.destroy()
		return
	}
	defer {
		client.disconnect()
	}

	for {
		temp := get_temperature()
		payload := '${temp} degreeC'
		rc := client.publish('/miza/get/temp', payload, .qos0, false)
		if rc != .ok {
			println('Failed to pub {topic=/miza/get/temp, payload="${payload}"}')
			println(rc)
		} else {
			println('pub {topic=/miza/get/temp, payload="${payload}"}')
		}
		time.sleep(150*time.millisecond)
	}
}