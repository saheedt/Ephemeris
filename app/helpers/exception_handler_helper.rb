module ExceptionHandlerHelper
  class DecodeError < StandardError ; end
  class ExpiredSignature < StandardError ; end

  class GQLCustomError < GraphQL::ExecutionError
    attr_reader :message
    def initialize(message)
      @message = message
    end

    def to_h
      return message if message.is_a?(Hash)
      { "message": message }
    end
  end
end
