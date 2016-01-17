require_relative "LEDStripe"
require 'socket'

# testServer = UDPSocket.new
# testServer.bind("127.0.0.1", 4913)

led = LEDStripe.new(255, 'set', 226)

# FUNCTIONS
# led.solidColor('800080')
# led.seperate('ffffff','800080','000000')
# led.gradientLine('8000B0','3A63FF','94001F')
led.train(15, 0.1 , '000000', '00ff00', '0000ff', '000000', 'ff0000')
# led.gradientRandom
