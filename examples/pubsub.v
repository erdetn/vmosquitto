module main

import vmosquitto
import time 

fn main() {

    // Create a new client instance
    client := vmosquitto.new('client_id', true)
    defer { client.destroy() }

    // Set callbacks
    client.on_connect(fn (mosq &vmosquitto.Mosquitto, obj voidptr, rc int) {
        println('Connected with code: $rc')
    })

    client.on_message(fn (mosq &vmosquitto.Mosquitto, obj voidptr, msg &vmosquitto.Message) {
        println('Received message on topic: ${msg.topic()}')
    })

    // Connect to the broker
    status := client.connect('localhost', 1883, 60, vmosquitto.no_bind_addr, false)
    if status != .ok {
        println('Connection failed: ${status.str()}')
        return
    }

    // Start the loop
    client.loop_start()

    // Subscribe to a topic
    client.subscribe([vmosquitto.Topic{'test/topic', .qos0}])

    // Publish a message
    client.publish('test/topic', 'Hello MQTT!', .qos0, false)

    // Sleep to allow callbacks to process (simulation of async behavior)
    time.sleep(5 * time.second)

    // Disconnect and cleanup
    client.disconnect()
    client.loop_stop(true)
}
