require 'socket'

module RaceResult
  class Decoder
    attr_accessor :host, :port

    STATUS_KEYS = [:date, :time, :has_power, :antennas, :timing_mode, :file_no,
                   :gps_fix, :location, :rfid_ok]

    def initialize(host, port = 3601)
      self.host = host
      self.port = port

      connect
    end

    def has_power?
      get_status[:has_power] == "1"
    end

    def antennas
      get_status[:antennas]
    end

    def datetime
      if get_status[:date].start_with?('0')
        date=Date.today.to_s
      else
        date=get_status[:date]
      end
        datetime=DateTime.parse(date+' '+get_status[:time])
    end


  private
    def connect
      @socket = TCPSocket.new(host, port)
    end

    def get_status
      @socket.puts 'GETSTATUS'
      status = @socket.gets.chomp.split(';')
      Hash[STATUS_KEYS.zip(status[1..-1])]
    end
  end
end
