require_relative "LEDStripe"
require 'socket'

# testServer = UDPSocket.new
# testServer.bind("127.0.0.1", 4914)

led = LEDStripe.new("127.0.0.1:4913", 226, 1)

# FUNCTIONS
# led.solidColor('800080')
# led.seperate('ffffff','800080','000000')
led.gradientLine('8000B0',%w(3A63FF 94001F))
# led.train(30, 0.025, '000000', %w(00ff00 0000ff), '000000', 'ff0000')
# led.gradientRandom
# p testServer.recvfrom(1000)
