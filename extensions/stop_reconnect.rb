class StopReconnect
  def outgoing(message,callback)
    if message['advice'] && message['advice']['reconnect'] == 'handshake'
      puts message
      message['advice'] = { 'reconnect' => 'none'}
      puts message
    end
    callback.call(message)
  end
end