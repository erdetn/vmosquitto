// Author: erdetn //

module vmosquitto

#flag -l mosquitto
#include <mosquitto.h>

// TYPES

struct C.mosquitto_message {
	mid int 
	topic &char
	payload voidptr
	payloadlen int 
	qos int 
	retain bool
}

pub type Message = C.mosquitto_message

pub type Mosquitto = C.mosquitto

struct C.mosquitto{

}

struct C.mosquitto_property{

}

struct C.libmosquitto_will {
	// char *topic;
	// void *payload;
	// int payloadlen;
	// int qos;
	// bool retain;
}

struct C.libmosquitto_auth {
	// char *username;
	// char *password;
}

struct C.libmosquitto_tls {
	// char *cafile;
	// char *capath;
	// char *certfile;
	// char *keyfile;
	// char *ciphers;
	// char *tls_version;
	// int (*pw_callback)(char *buf, int size, int rwflag, void *userdata);
	// int cert_reqs;
}

// ENUM

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

pub const no_id = ''

fn C.mosquitto_new(id &char, clean_session bool, obj voidptr) &C.mosquitto
pub fn new(id string, clean_session bool) &Mosquitto {
	if id == no_id {
		return unsafe {
			&Mosquitto(C.mosquitto_new(&char(nil), clean_session, nil))
		}
	}
	return unsafe {
		&Mosquitto(C.mosquitto_new(id.str, clean_session, nil))
	}
}

fn C.mosquitto_destroy(C.mosquitto)
pub fn (m &Mosquitto) destroy() {
	if m == unsafe { nil } {
		return
	}
	C.mosquitto_destroy((&m))
}

fn C.mosquitto_reinitialise(&C.mosquitto, &char, bool, voidptr) int
pub fn (m &Mosquitto) reinitialise(id string, clean_session bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_reinitialise(m, id.str, clean_session, nil))
	}
}

fn C.mosquitto_will_set(mosq &C.mosquitto, topic &char, payloadlen int, payload voidptr, qos int, retain bool) int
pub fn (m &Mosquitto) will_set(topic string, payload string, qos int, retain bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_will_set(m, topic.str, payload.len, voidptr(payload.str),
			qos, retain))
	}
}

// TODO
fn C.mosquitto_will_set_v5(mq &C.mosquitto, topic &char, payloadlen int, payload voidptr, qos int, retain boolt, prop &C.mosquitto_property) int

fn C.mosquitto_will_clear(mq &C.mosquitto) int
pub fn (m &Mosquitto) will_clear() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_will_clear(m))
	}
}

fn C.mosquitto_username_pw_set(mq &C.mosquitto, username &char, password &char) int
pub fn (m &Mosquitto) set_account(username string, password string) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_username_pw_set(m, username.str, password.str))
	}
}

fn C.mosquitto_connect(mq &C.mosquitto, host &char, port int, keepalive int) int
fn C.mosquitto_connect_bind(mq &C.mosquitto, host &char, port int, keepalive int, bind_address &char) int

fn C.mosquitto_connect_async(mq &C.mosquitto, host &char, port int, keepalive int) int
fn C.mosquitto_connect_bind_async(mq &C.mosquitto, host &char, port int, keepalive int, bind_address &char) int

pub const no_bind_addr = ''

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

// TODO
fn C.mosquitto_connect_bind_v5(mq &C.mosquitto, host &char, port int, keepalive int, bind_address &char, properties &C.mosquitto_message) int
fn C.mosquitto_connect_srv(mq &C.mosquitto, host &char, port int, keepalive int, bind_address &char) int

fn C.mosquitto_reconnect(mq &C.mosquitto) int
fn C.mosquitto_reconnect_async(mq &C.mosquitto) int
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
pub fn (m &Mosquitto) disconnect() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_disconnect(m))
	}
}

// TODO
fn C.mosquitto_disconnect_v5(mq &C.mosquitto, reason_code int, mp &C.mosquitto_property) int

fn C.mosquitto_publish(mq &C.mosquitto, mid &int, topic &char, payloadlen int, payload voidptr, qos int, retain bool) int
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
	qos QoS
}

pub fn (t Topic)str() string {
	return '{ ${t.topic}, ${t.qos} }'
}

fn C.mosquitto_subscribe(mq &C.mosquitto, mid &int, sub &char, qos int) int
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

// TODO
fn C.mosquitto_subscribe_v5(mq &C.mosquitto, mid &int, sub &char, qos int, options int, mp &C.mosquitto_property) int

// TODO
fn C.mosquitto_subscribe_multiple(mq &C.mosquitto, mid &int, sub_count int, sub &&char, qos int, options int, mp &C.mosquitto_property) int

fn C.mosquitto_unsubscribe(mq &C.mosquitto, mid &int, sub &char) int
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

// TODO
fn C.mosquitto_unsubscribe_v5(mq &C.mosquitto, mid &int, sub &char, mp &C.mosquitto_property) int

// TODO
fn C.mosquitto_unsubscribe_multiple(mq &C.mosquitto, mid &int, sub_count int, sub &&char, mp &C.mosquitto_property) int

// TODO
fn C.mosquitto_message_copy(dst &C.mosquitto_message, src &C.mosquitto_message) int

// TODO
fn C.mosquitto_message_free(msg &&C.mosquitto_message)

// TODO
fn C.mosquitto_message_free_contents(msg &C.mosquitto_message)

fn C.mosquitto_loop_forever(mq &C.mosquitto, timeout int, max_packets int) int
fn C.mosquitto_loop(mq &C.mosquitto, timeout int, max_packets int) int
pub fn (m &Mosquitto) loop_forever(forever bool, timeout int, max_packets int) ReturnStatus {
	if forever {
		return unsafe {
			ReturnStatus(C.mosquitto_loop_forever(m, timeout, max_packets))
		}
	}
	return unsafe {
		ReturnStatus(C.mosquitto_loop(m, timeout, max_packets))
	}
}

fn C.mosquitto_loop_start(mq &C.mosquitto) int
pub fn (m &Mosquitto) loop_start() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_start(m))
	}
}

fn C.mosquitto_loop_stop(mq &C.mosquitto, force bool) int
pub fn (m &Mosquitto) loop_stop(force bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_stop(m, force))
	}
}

fn C.mosquitto_loop_read(mq &C.mosquitto, max_packets int) int
pub fn (m &Mosquitto) loop_read(max_packets int) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_read(m, max_packets))
	}
}

fn C.mosquitto_loop_write(mq &C.mosquitto, max_packets int) int
pub fn (m &Mosquitto) loop_write(max_packets int) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_write(m, max_packets))
	}
}

fn C.mosquitto_loop_misc(mq &C.mosquitto) int
pub fn (m &Mosquitto) loop_misc() ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_loop_misc(m))
	}
}

fn C.mosquitto_socket(mq &C.mosquitto) int
pub fn (m &Mosquitto) socket() int {
	return C.mosquitto_socket(m)
}

fn C.mosquitto_want_write(mq &C.mosquitto) bool
pub fn (m &Mosquitto) is_write_ready() bool {
	return C.mosquitto_want_write(m)
}

fn C.mosquitto_threaded_set(mq &C.mosquitto, threaded bool) int
pub fn (m &Mosquitto) threadit(threaded bool) ReturnStatus {
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
pub fn (m &Mosquitto) on_connect(cb fn (&Mosquitto, voidptr, int)) {
	C.mosquitto_connect_callback_set(m, cb)
}

fn C.mosquitto_disconnect_callback_set(mq &Mosquitto, cb fn (&Mosquitto, voidptr, int))
pub fn (m &Mosquitto) on_disconnect(cb fn (&Mosquitto, voidptr, int)) {
	C.mosquitto_disconnect_callback_set(m, cb)
}

fn C.mosquitto_publish_callback_set(mq &Mosquitto, cb fn(&Mosquitto, voidptr, int))
pub fn (m &Mosquitto)on_publish(callback fn(&Mosquitto, voidptr, int)) {
	C.mosquitto_publish_callback_set(m, callback)
}

fn C.mosquitto_subscribe_callback_set(mq &C.mosquitto, cb fn(mq &Mosquitto, obj voidptr, mid int, qos_count int, granted_qos &int))
pub fn (m &Mosquitto)on_subscribe(callback fn(mq &Mosquitto, obj voidptr, mid int, qos_count int, granted_qos &int)) {
	C.mosquitto_subscribe_callback_set(m, callback)
}

fn C.mosquitto_unsubscribe_callback_set(m &C.mosquitto, cb fn(mq &Mosquitto, obj voidptr, msg_id int))
pub fn (m &Mosquitto)on_unsubscribe(callback fn(mq &Mosquitto, obj voidptr, msg_id int)) {
	C.mosquitto_unsubscribe_callback_set(m, callback)
}

fn C.mosquitto_log_callback_set(m &C.mosquitto, cb fn(m &Mosquitto, obj voidptr, level Log, log_str &char))
fn (m &Mosquitto)on_log(callback fn(m &Mosquitto, obj voidptr, level Log, log_str &char)) {
	C.mosquitto_log_callback_set(m, callback)
}

fn C.mosquitto_message_callback_set(m &C.mosquitto, cb fn(&Mosquitto, voidptr, &Message))
pub fn (m &Mosquitto)on_message(callback fn(mq &Mosquitto, obj voidptr, msg &Message)) {
	C.mosquitto_message_callback_set(m, callback)
}

fn C.mosquitto_string_option(m &C.mosquitto, option int, value &char) int 
pub fn (m &Mosquitto)string_option(option OptionValue, value string) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_string_option(m, int(option), value.str))
	}
}

fn C.mosquitto_reconnect_delay_set(m &C.mosquitto, reconnect_delay u32, reconnect_delay_max u32, reconnect_exponential_backoff bool) int
pub fn (m &Mosquitto)set_reconnect_delay(reconnect_delay u32, reconnect_delay_max u32, reconnect_exponential_backoff bool) ReturnStatus {
	return unsafe {
		ReturnStatus(C.mosquitto_reconnect_delay_set(m, reconnect_delay, reconnect_delay_max, reconnect_exponential_backoff))
	}
}

fn C.mosquitto_message_free(msg &&C.mosquitto_message)
pub fn (msg &Message) delete() {
	C.mosquitto_message_free(&msg)
}

fn C.mosquitto_message_free_contents(msg &C.mosquitto_message)
pub fn (msg &Message) clear() {
	C.mosquitto_message_free_contents(msg)
}

pub fn (msg &Message)str() string {
	mid := msg.mid() 
	topic := msg.topic()
	payload := msg.payload().bytestr()
	qos := msg.qos()
	retain := msg.retain()
	return '{${mid}, ${topic}, ${payload}, ${qos}, ${retain}}'
}


pub fn (msg Message) qos() int {
	return msg.qos
}

pub fn (msg Message) mid() int {
	return msg.mid
}

pub fn (msg Message) topic() string {
	return unsafe {
		msg.topic.vstring()
	}
}

pub fn (msg Message) retain() bool {
	return msg.retain
}

pub fn (msg Message) payload() []u8 {
	return unsafe {
		msg.payload.vbytes(msg.payloadlen)
	}
}
