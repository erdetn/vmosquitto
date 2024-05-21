# vmosquitto

The `vmosquitto` library is a V language binding for `libmosquitto` - the Mosquitto MQTT (Message Queuing Telemetry Transport) client library. This library provides a comprehensive interface for interacting with MQTT brokers, facilitating the development of applications that require messaging capabilities.

## Install
On how to install `libmosquitto`, check the official page [mosquitto.org](https://mosquitto.org/download/).

---- 
### Key Features:

#### Initialization and Cleanup:
- `init()` and `cleanup()` functions for initializing and cleaning up the Mosquitto library.

#### Client Management:
- `new()`: Create a new Mosquitto client instance with optional clean session.
- `destroy()`: Free memory associated with a Mosquitto client instance.

#### Connection Handling:
- `connect()`, `reconnect()`, `disconnect()`: Manage connections to an MQTT broker with support for synchronous and asynchronous operations.
- `set_account()`: Set username and password for the MQTT connection.
- `will_set()`, `will_clear()`: Configure or clear the Last Will and Testament (LWT) message.

#### Messaging:
- `publish()`: Publish messages to a specified topic with different Quality of Service (QoS) levels.
- `subscribe()`, `unsubscribe()`: Subscribe to or unsubscribe from a list of topics.

#### Event Loop:
- `loop()`, `loop_start()`, `loop_stop()`, `ping()`: Manage the event loop, either in a blocking or threaded manner, to handle incoming and outgoing network traffic.

#### Callbacks:
- Set various callbacks for handling events like connection, disconnection, message reception, logging, and subscription updates (`on_connect()`, `on_disconnect()`, `on_message()`, etc.).

#### Logging and Status:
- `Log` and `ReturnStatus` enums for detailed logging and status reporting.
- Utility functions for error handling and status reporting (`str()` methods for enums).

#### Helpers:
- `validate_utf8()`: Validate UTF-8 strings.
- `socket()`, `is_write_ready()`: Low-level network operations.
- `threaded_set()`: Indicate threaded mode without using `loop_start()`.

### Example
This example demonstrates the basic usage of the vmosquitto library, covering client creation, connection setup, message publishing, subscription, and event handling. The library encapsulates the complexity of MQTT communication, providing an easy-to-use interface for V language developers.

```v
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
```
Check `/examples` for more examples.

Note: The documentation for functions is primarily based on the official `libmosquitto` documentation.