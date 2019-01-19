require 'faye/websocket'
require 'eventmachine'
require 'json'

EM.run {
  ws = Faye::WebSocket::Client.new('ws://127.0.0.1:9888/websocket-subscribe')

  ws.on :open do |event|
    p [:open]
    p ws.send("{\"topic\": \"notify_raw_blocks\"}")
    p ws.send("{\"topic\": \"notify_new_transactions\"}")
  end

  ws.on :message do |event|
    p [:message, event.data]
    response = JSON.parse(event.data)
    case response['notification_type']
    when 'raw_blocks_connected'
      p response['data']
    when 'raw_blocks_disconnected'
      p response['data']
    when 'new_transaction'
      p response['data']
    when 'request_status'
      p response['error_detail']
    end
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}

