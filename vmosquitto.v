// Author: erdetn //

module vmosquitto

#flag -l mosquitto
#include <mosquitto.h>

// TYPES

struct C.mosquitto_message {
	mid        int
	topic      &char
	payload    voidptr
	payloadlen int
	qos        int
	retain     bool
}

pub type Message = C.mosquitto_message

pub type Mosquitto = C.mosquitto

struct C.mosquitto {
}

struct C.mosquitto_property {
}

// ENUM

// `Log`
// The `Log` enum defines various logging levels 
// for use in applications that need to categorize 
// and filter log messages. Each variant of the `Log` 
// enum corresponds to a specific logging level, 
// allowing developers to specify the granularity 
// and type of logging information they want to capture.
pub enum Log {
	@none       = C.MOSQ_LOG_NONE
	info        = C.MOSQ_LOG_INFO
	notice      = C.MOSQ_LOG_NOTICE
	warning     = C.MOSQ_LOG_WARNING
	error       = C.MOSQ_LOG_ERR
	debug       = C.MOSQ_LOG_DEBUG
	subscribe   = C.MOSQ_LOG_SUBSCRIBE
	unsubscribe = C.MOSQ_LOG_UNSUBSCRIBE
	websocket   = C.MOSQ_LOG_WEBSOCKETS
	internal    = C.MOSQ_LOG_INTERNAL
	all         = C.MOSQ_LOG_ALL
}

// Function `str`.
// Stringify the `Log` enum.
pub fn (log Log) str() string {
	return match log {
		.@none { 'NONE' }
		.info { 'INFO' }
		.notice { 'NOTICE' }
		.warning { 'WARNING' }
		.error { 'ERROR' }
		.debug { 'DEBUG' }
		.subscribe { 'SUBSCRIBE' }
		.unsubscribe { 'UNSUBSCRIBE' }
		.websocket { 'WEBSOCKET' }
		.internal { 'INTERNAL' }
		.all { 'ALL' }
	}
}

// `ReturnStatus`
// The ReturnStatus enum defines various return statuses 
// for MQTT operations. Each variant corresponds to a specific 
// status code, providing a standardized way to handle different 
// outcomes and errors.
pub enum ReturnStatus {
	auth_continue       = C.MOSQ_ERR_AUTH_CONTINUE
	no_sub              = C.MOSQ_ERR_NO_SUBSCRIBERS
	sub_exists          = C.MOSQ_ERR_SUB_EXISTS
	conn_pending        = C.MOSQ_ERR_CONN_PENDING
	ok                  = C.MOSQ_ERR_SUCCESS
	no_memory           = C.MOSQ_ERR_NOMEM
	protocol            = C.MOSQ_ERR_PROTOCOL
	invalide            = C.MOSQ_ERR_INVAL
	no_conn             = C.MOSQ_ERR_NO_CONN
	conn_refused        = C.MOSQ_ERR_CONN_REFUSED
	not_found           = C.MOSQ_ERR_NOT_FOUND
	conn_lost           = C.MOSQ_ERR_CONN_LOST
	tls                 = C.MOSQ_ERR_TLS
	payload_size        = C.MOSQ_ERR_PAYLOAD_SIZE
	not_supported       = C.MOSQ_ERR_NOT_SUPPORTED
	auth                = C.MOSQ_ERR_AUTH
	acl_denied          = C.MOSQ_ERR_ACL_DENIED
	unknown             = C.MOSQ_ERR_UNKNOWN
	errno               = C.MOSQ_ERR_ERRNO
	eai                 = C.MOSQ_ERR_EAI
	proxy               = C.MOSQ_ERR_PROXY
	plugin_defer        = C.MOSQ_ERR_PLUGIN_DEFER
	malformed_utf8      = C.MOSQ_ERR_MALFORMED_UTF8
	keep_alive          = C.MOSQ_ERR_KEEPALIVE
	lookup              = C.MOSQ_ERR_LOOKUP
	malformed_packet    = C.MOSQ_ERR_MALFORMED_PACKET
	duplicated_property = C.MOSQ_ERR_DUPLICATE_PROPERTY
	tls_handshake       = C.MOSQ_ERR_TLS_HANDSHAKE
	qos_not_supported   = C.MOSQ_ERR_QOS_NOT_SUPPORTED
	oversized_packet    = C.MOSQ_ERR_OVERSIZE_PACKET
	ocsp                = C.MOSQ_ERR_OCSP
}

// `QoS` enum
// The QoS enum defines the Quality of Service levels for 
// MQTT (Message Queuing Telemetry Transport) messaging. 
// Each level specifies a different guarantee of delivery 
// for messages, providing flexibility in balancing between
// reliability and performance.
pub enum QoS {
	qos0 = 0
	qos1 = 1
	qos2 = 2
}

pub enum OptionValue {
	protocol_version      = C.MOSQ_OPT_PROTOCOL_VERSION
	ssl_ctx               = C.MOSQ_OPT_SSL_CTX
	received_max          = C.MOSQ_OPT_SSL_CTX_WITH_DEFAULTS
	send_max              = C.MOSQ_OPT_SEND_MAXIMUM
	tls_keyform           = C.MOSQ_OPT_TLS_KEYFORM
	tls_engine            = C.MOSQ_OPT_TLS_ENGINE
	tls_engine_kpass_sha1 = C.MOSQ_OPT_TLS_ENGINE_KPASS_SHA1
	tls_ocsp_required     = C.MOSQ_OPT_TLS_OCSP_REQUIRED
	tls_alpn              = C.MOSQ_OPT_TLS_ALPN
}

const id_max_len = C.MOSQ_MQTT_ID_MAX_LENGTH

pub enum ProtocolVersion {
	v31  = C.MQTT_PROTOCOL_V31
	v311 = C.MQTT_PROTOCOL_V311
	v5   = C.MQTT_PROTOCOL_V5
}

// FUNCTIONS

fn C.mosquitto_lib_init() int
fn init() {
	_ := C.mosquitto_lib_init()
}

fn C.mosquitto_lib_cleanup() int
fn cleanup() {
	_ := C.mosquitto_lib_cleanup()
}

pub const random_id = ''

fn C.mosquitto_new(id &char, clean_session bool, obj voidptr) &C.mosquitto

// Function: `new`
// Create a new mosquitto client instance.
// `id`: Unique name (string) as client ID. If `random_id`, random ID will be generated.
// `clean_session`: set to true to instruct the broker to clean all messages
// and subscriptions on disconnect, false to instruct it to keep them.
// Returns `Mosquitto` client instance.
pub fn new(id string, clean_session bool) &Mosquitto {
	if id == vmosquitto.random_id {
		return unsafe {
			&Mosquitto(C.mosquitto_new(&char(nil), clean_session, nil))
		}
	}
	return unsafe {
		&Mosquitto(C.mosquitto_new(id.str, clean_session, nil))
	}
}

fn C.mosquitto_destroy(C.mosquitto)

// Function: `destroy`
// Use to free memory associated with a mosquitto client instance.
pub fn (m &Mosquitto) destroy() {
	if m == unsafe { nil } {
		return
	}
	C.mosquitto_destroy((&m))
}

fn C.mosquitto_will_set(mosq &C.mosquitto, topic &char, payloadlen int, payload voidptr, qos int, retain bool) int

// Function `will_set`
// Is used to configure the "Last Will and Testament" (LWT) message
// for an MQTT client. This message is published by the broker on
// behalf of the client if the client disconnects unexpectedly.
// The LWT feature is crucial for notifying other clients about
// an unexpected disconnection of a client.
// `will_set` must be called before calling `connect`.
// `topic`: The topic on which the will message will be published.
// `payload`: The content of the will message.
// `qos`: The Quality of Service level for the message
//        (.qos0, .qos1, or .qos2).
// retain: A boolean value indicating if the message should be retained by the broker.
// Returns `ReturnStatus`.
pub fn (m &Mosquitto) will_set(topic string, payload string, qos QoS, retain bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_will_set(m, topic.str, payload.len, voidptr(payload.str),
			int(qos), retain))
	}
}

fn C.mosquitto_will_clear(mq &C.mosquitto) int

// Function `will_clear`  is used to remove the Last Will and Testament (LWT) message
// that was previously set using `will_set`. This can be useful if you want to change
// the will message or if you no longer want to have a will message associated with your MQTT client.
// `will_clear` must be called before calling `connect`.
// Returns `ReturnStatus`.
pub fn (m &Mosquitto) will_clear() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_will_clear(m))
	}
}

fn C.mosquitto_username_pw_set(mq &C.mosquitto, username &char, password &char) int

// Function `set_account`: set // `username` and `password` for a mosquitto instance.
// By default, no `username` or `password` will be sent.
// For v3.1 and v3.1.1 clients, if `username`, the `password` argument is ignored.
// `set_account` must be called before calling `connect`.
// Returns `ReturnStatus`
pub fn (m &Mosquitto) set_account(username string, password string) ReturnStatus {
	if username.trim_space() == '' {
		return unsafe {
			ReturnStatus(C.mosquitto_username_pw_set(m, &char(nil), &char(nil)))
		}
	}
	return unsafe {
		ReturnStatus(C.mosquitto_username_pw_set(m, username.str, password.str))
	}
}

fn C.mosquitto_connect(mq &C.mosquitto, host &char, port int, keepalive int) int
fn C.mosquitto_connect_bind(mq &C.mosquitto, host &char, port int, keepalive int, bind_address &char) int

fn C.mosquitto_connect_async(mq &C.mosquitto, host &char, port int, keepalive int) int
fn C.mosquitto_connect_bind_async(mq &C.mosquitto, host &char, port int, keepalive int, bind_address &char) int

pub const no_bind_addr = ''

// Function `connect`
// Connect to an MQTT broker.
// `host`: the hostname or ip address of the broker to connect to.
// `port`: the network port to connect to. Usually 1883.
// `keep_alive`: the number of seconds after which the broker should send a PING
//               message to the client if no other messages have been exchanged
//               in that time.
// `bind_address`: the hostname or ip address of the local network interface to
//               bind to. `no_bind_address` if you don't want to use connect_bind.
//               This extends the functionality of `connect` by adding the
//               bind_address parameter. Use this function if you need to restrict
//               network communication over a particular interface.
// `async`: This is a non-blocking call. If you use `async`, the client must use
//          the threaded interface `loop_start`. If you need to use `loop`, you
//          must set `async` to `false` to connect the client.
pub fn (m &Mosquitto) connect(host string, port int, keep_alive int, bind_address string, async bool) ReturnStatus {
	if bind_address.trim_space() != '' {
		if async {
			return unsafe {
				ReturnStatus(C.mosquitto_connect_bind_async(m, host.str, port, keep_alive,
					bind_address.str))
			}
		}

		return unsafe {
			ReturnStatus(C.mosquitto_connect_bind(m, host.str, port, keep_alive, bind_address.str))
		}
	}

	if async {
		return unsafe {
			ReturnStatus(C.mosquitto_connect(m, host.str, port, keep_alive))
		}
	}

	return unsafe {
		ReturnStatus(C.mosquitto_connect(m, host.str, port, keep_alive))
	}
}

fn C.mosquitto_reconnect(mq &C.mosquitto) int
fn C.mosquitto_reconnect_async(mq &C.mosquitto) int

// Function `reconnect`. Reconnect to a broker.
// This function provides an easy way of reconnecting to a broker after a
// connection has been lost. It uses the values that were provided in the
// `connect` call. It must not be called before `connect`.
// `async`: enables non-blocking function of `reconnect`.
pub fn (m &Mosquitto) reconnect(async bool) ReturnStatus {
	if async {
		return unsafe {
			ReturnStatus(C.mosquitto_reconnect_async(m))
		}
	}
	return unsafe {
		ReturnStatus(C.mosquitto_reconnect(m))
	}
}

fn C.mosquitto_disconnect(mq &C.mosquitto) int

// Function `disconnect`. Disconnect from the broker.
pub fn (m &Mosquitto) disconnect() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_disconnect(m))
	}
}

fn C.mosquitto_publish(mq &C.mosquitto, mid &int, topic &char, payloadlen int, payload voidptr, qos int, retain bool) int

// Function `publish`. Publish a message on a given topic.
pub fn (m &Mosquitto) publish(topic string, payload string, qos QoS, retain bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_publish(m, nil, topic.str, payload.len, voidptr(payload.str),
			int(qos), retain))
	}
}

// TODO
fn C.mosquitto_publish_v5(mq &C.mosquitto, mid &int, topic &char, payloadlen int, payload voidptr, qos int, retain bool, mp &C.mosquitto_property) int

pub struct Topic {
pub:
	topic string
	qos   QoS
}

pub fn (t Topic) str() string {
	return '{ ${t.topic}, ${t.qos} }'
}

fn C.mosquitto_subscribe(mq &C.mosquitto, mid &int, sub &char, qos int) int

// Function `subscribe`. Subscribe to a list of topics.
pub fn (m &Mosquitto) subscribe(topics []Topic) ReturnStatus {
	for t in topics {
		unsafe {
			rc := ReturnStatus(C.mosquitto_subscribe(m, nil, t.topic.str, int(t.qos)))
			if rc != .ok {
				return rc
			}
		}
	}

	return ReturnStatus.ok
}

fn C.mosquitto_unsubscribe(mq &C.mosquitto, mid &int, sub &char) int

// Function `unsubscribe`. Unsubscribe from a list of topics.
pub fn (m &Mosquitto) unsubscribe(topics []string) ReturnStatus {
	for topic in topics {
		unsafe {
			rc := ReturnStatus(C.mosquitto_unsubscribe(m, nil, topic.str))
			if rc != .ok {
				return rc
			}
		}
	}
	return ReturnStatus.ok
}

fn C.mosquitto_loop_forever(mq &C.mosquitto, timeout int, max_packets int) int
fn C.mosquitto_loop(mq &C.mosquitto, timeout int, max_packets int) int

const max_packets = int(1)

// Function `loop`. The main network loop for the client.
// This must be called frequently to keep communications
// between the client and broker working.
// `forever` true calls `loop()` in an infinite blocking
// loop. It is useful for the case where you only want to
// run the MQTT client loop in your program.
pub fn (m &Mosquitto) loop(forever bool, timeout int) ReturnStatus {
	if forever {
		return unsafe {
			ReturnStatus(C.mosquitto_loop_forever(m, timeout, vmosquitto.max_packets))
		}
	}
	return unsafe {
		ReturnStatus(C.mosquitto_loop(m, timeout, vmosquitto.max_packets))
	}
}

fn C.mosquitto_loop_start(mq &C.mosquitto) int

// Function `loop_start`. This is part of the threaded client interface.
// Call this once to start a new thread to process network traffic.
// This provides an alternative to repeatedly calling `loop` yourself.
pub fn (m &Mosquitto) loop_start() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_start(m))
	}
}

fn C.mosquitto_loop_stop(mq &C.mosquitto, force bool) int

// Function `loop_stop`. This is part of the threaded client interface.
// Call this once to stop the network thread previously created with
// `loop_start`. This call will block until the network thread finishes.
// For the network thread to end, you must have previously called `disconnect`
// or have set the force parameter to `true`.
pub fn (m &Mosquitto) loop_stop(force bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_stop(m, force))
	}
}

fn C.mosquitto_loop_read(mq &C.mosquitto, max_packets int) int

// Function `loop_read()`. Carry out network read operations.
// This should only be used if you are not using `loop()` and are
// monitoring the client network socket for activity yourself.
fn (m &Mosquitto) loop_read() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_read(m, vmosquitto.max_packets))
	}
}

fn C.mosquitto_loop_write(mq &C.mosquitto, max_packets int) int

// Function `loop_write`. Carry out network write operations.
// This should only be used if you are not using `loop()` and are
// monitoring the client network socket for activity yourself.
fn (m &Mosquitto) loop_write() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_write(m, vmosquitto.max_packets))
	}
}

fn C.mosquitto_loop_misc(mq &C.mosquitto) int

// Function `loop_misc`. Carry out miscellaneous operations
// required as part of the network loop.
// This should only be used if you are not using `loop` and are
// monitoring the client network socket for activity yourself.
fn (m &Mosquitto) loop_misc() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_misc(m))
	}
}

pub enum Ping {
	write
	read
	misc
}

// Function `ping`.
// `ping`:
// `.write`: Carry out network write operations.
// `.read`:  Carry out network read operations.
// `.misc`:  Carry out miscellaneous operations
//           required as part of the network loop.
// This should only be used if you are not using `loop` and are
// monitoring the client network socket for activity yourself.
pub fn (m &Mosquitto) ping(ping Ping) ReturnStatus {
	return match ping {
		.write {
			m.loop_write()
		}
		.read {
			m.loop_read()
		}
		.misc {
			m.loop_misc()
		}
	}
}

fn C.mosquitto_socket(mq &C.mosquitto) int

// Function `socket`: Return the socket handle for a mosquitto instance.
pub fn (m &Mosquitto) socket() int {
	return C.mosquitto_socket(m)
}

fn C.mosquitto_want_write(mq &C.mosquitto) bool

// Function `is_write_ready`: Returns true if there is data ready
// to be written on the socket.
pub fn (m &Mosquitto) is_write_ready() bool {
	return C.mosquitto_want_write(m)
}

fn C.mosquitto_threaded_set(mq &C.mosquitto, threaded bool) int

// Function `threaded_set`: Used to tell the library that
// your application is using threads, but not using `loop_start`.
// The library operates slightly differently when not in threaded
// mode in order to simplify its operation. If you are managing
// your own threads and do not use this function you will experience crashes
// due to race conditions.
// When using `loop_start`, this is set automatically.
pub fn (m &Mosquitto) threaded_set(threaded bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_threaded_set(m, threaded))
	}
}

fn C.mosquitto_strerror(mosq_errno int) &char
pub fn (rc ReturnStatus) str() string {
	return unsafe {
		cstring_to_vstring(C.mosquitto_strerror(int(rc)))
	}
}

fn C.mosquitto_validate_utf8(str &char, len int) int
pub fn validate_utf8(input string) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_validate_utf8(input.str, input.len))
	}
}

// Callbacks

fn C.mosquitto_connect_callback_set(mq &Mosquitto, cb fn (&Mosquitto, voidptr, int))

// Function `on_connect` sets the connect callback.
// This is called when the broker sends a CONNACK
// message in response to a connection.
pub fn (m &Mosquitto) on_connect(cb fn (&Mosquitto, voidptr, int)) {
	C.mosquitto_connect_callback_set(m, cb)
}

// Function `on_disconnect` sets the disconnect callback.
// This is called when the broker has received the
// DISCONNECT command and has disconnected the client.
fn C.mosquitto_disconnect_callback_set(mq &Mosquitto, cb fn (&Mosquitto, voidptr, int))
pub fn (m &Mosquitto) on_disconnect(cb fn (&Mosquitto, voidptr, int)) {
	C.mosquitto_disconnect_callback_set(m, cb)
}

fn C.mosquitto_publish_callback_set(mq &Mosquitto, cb fn (&Mosquitto, voidptr, int))

// Function `on_publish` sets the publish callback.
// This is called when a message initiated with
// `publish` has been sent to the broker successfully.
pub fn (m &Mosquitto) on_publish(callback fn (&Mosquitto, voidptr, int)) {
	C.mosquitto_publish_callback_set(m, callback)
}

fn C.mosquitto_subscribe_callback_set(mq &C.mosquitto, cb fn (mq &Mosquitto, obj voidptr, mid int, qos_count int, granted_qos &int))

// Function `on_subscribe` sets the subscribe callback.
// This is called when the broker responds to a
// subscription request.
pub fn (m &Mosquitto) on_subscribe(callback fn (mq &Mosquitto, obj voidptr, mid int, qos_count int, granted_qos &int)) {
	C.mosquitto_subscribe_callback_set(m, callback)
}

fn C.mosquitto_unsubscribe_callback_set(m &C.mosquitto, cb fn (mq &Mosquitto, obj voidptr, msg_id int))

// Function `on_unsubscribe` sets the unsubscribe callback.
// This is called when the broker responds to a
// unsubscription request.
pub fn (m &Mosquitto) on_unsubscribe(callback fn (mq &Mosquitto, obj voidptr, msg_id int)) {
	C.mosquitto_unsubscribe_callback_set(m, callback)
}

fn C.mosquitto_log_callback_set(m &C.mosquitto, cb fn (m &Mosquitto, obj voidptr, level Log, log_str &char))

// Function `on_log` ests the logging callback.
// This should be used if you want event logging
// information from the client library.
pub fn (m &Mosquitto) on_log(callback fn (m &Mosquitto, obj voidptr, level Log, log_str &char)) {
	C.mosquitto_log_callback_set(m, callback)
}

fn C.mosquitto_message_callback_set(m &C.mosquitto, cb fn (&Mosquitto, voidptr, &Message))

// Function `on_message` sets the message callback.
// This is called when a message is received from the broker.
pub fn (m &Mosquitto) on_message(callback fn (mq &Mosquitto, obj voidptr, msg &Message)) {
	C.mosquitto_message_callback_set(m, callback)
}

fn C.mosquitto_string_option(m &C.mosquitto, option int, value &char) int
fn (m &Mosquitto) string_option(option OptionValue, value string) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_string_option(m, int(option), value.str))
	}
}

fn C.mosquitto_reconnect_delay_set(m &C.mosquitto, reconnect_delay u32, reconnect_delay_max u32, reconnect_exponential_backoff bool) int

// Function `set_reconnect_delay`.
// Control the behaviour of the client when it has unexpectedly disconnected in
// `loop` (with `forever` set to `true`) or after `loop_start`. The default
// behaviour if this function is not used is to repeatedly attempt to reconnect
// with a delay of 1 second until the connection succeeds.
// 
// Use `reconnect_delay` parameter to change the delay between successive
// reconnection attempts. You may also enable exponential backoff of the time
// between reconnections by setting `reconnect_exponential_backoff` to `true` and
// set an upper bound on the delay with `reconnect_delay_max`.
// 
// Example 1:
//  *	delay=2, delay_max=10, exponential_backoff=False
//  *	Delays would be: 2, 4, 6, 8, 10, 10, ...
//  *
// Example 2:
//  *	delay=3, delay_max=30, exponential_backoff=True
//  *	Delays would be: 3, 6, 12, 24, 30, 30, ...
//  *
// Parameters:
//  `reconnect_delay` -               the number of seconds to wait between
//                                    reconnects.
//  `reconnect_delay_max` -           the maximum number of seconds to wait
//                                    between reconnects.
//  `reconnect_exponential_backoff` - use exponential backoff between
//                                    reconnect attempts. Set to true to enable
//                                    exponential backoff.
pub fn (m &Mosquitto) set_reconnect_delay(reconnect_delay u32, reconnect_delay_max u32, reconnect_exponential_backoff bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_reconnect_delay_set(m, reconnect_delay, reconnect_delay_max,
			reconnect_exponential_backoff))
	}
}

fn C.mosquitto_message_free(msg &&C.mosquitto_message)

// Function `free`
// Completely free a `Message` struct.
pub fn (msg &Message) free() {
	C.mosquitto_message_free(&msg)
}

fn C.mosquitto_message_free_contents(msg &C.mosquitto_message)

// Function `clear`
// Free a `Message` struct contents, leaving the struct unaffected.
pub fn (msg &Message) clear() {
	C.mosquitto_message_free_contents(msg)
}

// Function `str`.
// Returns a formated string of `Message`.
pub fn (msg &Message) str() string {
	mid := msg.message_id()
	topic := msg.topic()
	payload := msg.payload()
	qos := msg.qos()
	retain := msg.retain()
	return '{${mid}, ${topic}, ${payload}, ${qos}, ${retain}}'
}

// Function `qos`.
// Return `QoS` enumeratios:
// `.qos0`, `.qos1` or `.qos2`.
pub fn (msg Message) qos() QoS {
	return unsafe { QoS(msg.qos) }
}

// Function `message_id`.
// Return ID of message.
pub fn (msg Message) message_id() int {
	return msg.mid
}

// Function `topic`.
// Return `topic` of this message.
pub fn (msg Message) topic() string {
	return unsafe {
		msg.topic.vstring()
	}
}

// Function `retain`.
// Return if retain is `true` or `false`.
pub fn (msg Message) retain() bool {
	return msg.retain
}

// Function `payload`.
// Returns the payload as string.
pub fn (msg Message) payload() string {
	return unsafe {
		msg.payload.vbytes(msg.payloadlen).bytestr()
	}
}

fn C.mosquitto_message_copy(dst &C.mosquitto_message, src &C.mosquitto_message) int

// Function `copy`.
// Copy the contents of a mosquitto message to another message.
// Useful for preserving a message received in the on_message() callback.
pub fn (msg Message) copy(dst &Message) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_message_copy(dst, &msg))
	}
}
