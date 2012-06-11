class StopReconnect
  def outgoing(message,callback)
    if message['advice'] && message['advice']['reconnect'] == 'handshake'
        message['advice']['reconnect'] = 'none'
    end
    callback.call(message)
  end

  def incoming(message, callback)
    callback.call(message) unless message['clientId'] == '805rqorp4uoiq92hah52h1hn4'
    # callback.call(message) 
  end
end