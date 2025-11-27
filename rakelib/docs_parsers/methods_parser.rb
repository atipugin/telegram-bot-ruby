# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'

module DocsParsers
  # Parser for Telegram Bot API documentation methods.
  #
  # This parser automatically extracts method definitions from the official Telegram Bot API
  # documentation page (https://core.telegram.org/bots/api) and generates a structured
  # JSON file (endpoints.json) that maps method names to their return types.
  #
  # == Why This Parser Exists
  #
  # The OpenAPI schema for Telegram Bot API is no longer being maintained by Telegram,
  # making it necessary to parse the HTML documentation directly. While type definitions
  # are important, knowing what each API method returns is equally crucial for proper
  # type inference and SDK functionality. This parser provides an automated solution to
  # extract method return type information from the official HTML documentation.
  #
  # The Telegram Bot API provides dozens of methods (sendMessage, getUpdates, etc.), each
  # with specific return types. To provide accurate type information in the Ruby SDK, we need
  # to know what each method returns. This parser:
  # - Eliminates manual maintenance of return type mappings
  # - Ensures the SDK stays in sync with the official API
  # - Enables proper type inference and IDE autocomplete
  # - Supports automatic method wrapper generation
  # - Automatically detects new methods added in API updates
  #
  # == Output Format
  #
  # The parser generates a JSON file with the following structure:
  #
  #   {
  #     "getMe": "Types::User",
  #     "sendMessage": "Types::Message",
  #     "getUpdates": "Types::Array.of(Types::Update)",
  #     "stopPoll": "Types::Poll | Types::Bool",
  #     "setWebhook": "Types::Bool"
  #   }
  #
  # Each key is a method name (camelCase) and each value is a Ruby dry-types type expression.
  #
  # == How We Parse
  #
  # The parser uses Nokogiri to parse the HTML documentation and extracts return type
  # information from method descriptions.
  #
  # HTML Structure for Methods:
  #   <h4>methodName</h4>
  #   <p>Description explaining what the method does. Returns TypeName on success.</p>
  #   <table>
  #     <thead><tr><th>Parameter</th><th>Type</th><th>Required</th><th>Description</th></tr></thead>
  #     <tbody>
  #       <tr><td>param_name</td><td>Type</td><td>Yes</td><td>Description</td></tr>
  #     </tbody>
  #   </table>
  #
  # Parsing Steps:
  #
  # 1. Identify Methods - Find all h4 headers that start with lowercase letters
  #    (methods use camelCase like "sendMessage", types use PascalCase like "Message")
  #
  # 2. Extract Descriptions - Collect paragraph text following each method header
  #    (descriptions contain the return type information)
  #
  # 3. Parse Return Types - Analyze description text for return type patterns:
  #    - Returns True on success → Types::Bool
  #    - Returns an Array of X → Types::Array.of(Types::X)
  #    - Returns X on success → Types::X
  #    - Returns X or Y → Types::X | Types::Y (union types)
  #
  # 4. Map Types - Convert API type names to Ruby type representations:
  #    - Primitive types: Integer → Types::Integer, String → Types::String, etc.
  #    - Custom types: Message → Types::Message, User → Types::User, etc.
  #    - Special handling for True/Bool variations
  #
  # == Parsing Patterns
  #
  # The parser recognizes several common documentation patterns:
  #
  # === Pattern 1: Boolean Success
  # "Returns True on success" → Types::Bool
  # Used by methods like setWebhook, deleteMessage
  #
  # === Pattern 2: Array Returns
  # "Returns an Array of Update objects" → Types::Array.of(Types::Update)
  # Used by methods like getUpdates, getChatAdministrators
  #
  # === Pattern 3: Union Returns
  # "Returns Message or True" → Types::Message | Types::Bool
  # Used by methods like stopPoll, editMessageText
  #
  # === Pattern 4: Simple Object Returns
  # "Returns a Message object" → Types::Message
  # "Returns User on success" → Types::User
  # Most methods follow this pattern
  #
  # === Pattern 5: Contextual Returns
  # Some methods describe what they return without explicit "Returns X" phrasing.
  # Example: "Returns basic information about the bot" → Types::User (for getMe)
  #
  # === Pattern 6: Fallback for Known Methods
  # For methods that don't follow standard patterns, the parser has hardcoded
  # return types as a fallback (getUpdates, setWebhook, getMe, etc.)
  #
  # == Type Mapping
  #
  # The parser maps Telegram API type names to Ruby dry-types representations:
  # - Integer/Int → Types::Integer
  # - String → Types::String
  # - Boolean/Bool/True → Types::Bool
  # - Float → Types::Float
  # - Array of X → Types::Array.of(Types::X)
  # - X or Y → Types::X | Types::Y (union type syntax)
  # - Custom types → Types::TypeName (e.g., Message → Types::Message)
  #
  # == Pattern Matching Details
  #
  # The parser uses regex patterns to extract return types from natural language descriptions.
  # It must handle various documentation writing styles:
  #
  # Skip words: Common words that aren't types are filtered out:
  # - "False", "success", "information", "object", "file", "the", "a", "an", "if", "when", "basic"
  #
  # Fallback for known methods: Some methods have hardcoded return types when patterns fail:
  # - getUpdates → Types::Array.of(Types::Update)
  # - setWebhook/deleteWebhook → Types::Bool
  # - getMe → Types::User
  #
  # == Dependencies
  #
  # Required Ruby gems:
  # - nokogiri - HTML/XML parsing
  # - open-uri - HTTP fetching (Ruby standard library)
  # - json - JSON generation (Ruby standard library)
  #
  # == Performance
  #
  # - Fetch time: ~2-3 seconds (depends on network)
  # - Parse time: <1 second (processes ~80-100 methods)
  # - Total execution: ~3-4 seconds
  #
  # == Validation Approach
  #
  # To ensure parser accuracy:
  # 1. Compare generated endpoints.json with expected output
  # 2. Check that all known methods are detected (e.g., getMe, sendMessage, getUpdates)
  # 3. Verify return types match documentation
  # 4. Test with multiple API versions to ensure pattern robustness
  # 5. Review any methods that return nil (pattern match failures)
  #
  # == Usage Workflow
  #
  # Typical workflow for updating methods after a Bot API release:
  # 1. Run parser to generate new methods: parser.fetch; parser.parse; parser.save('new.json')
  # 2. Compare with existing file to review changes
  # 3. Check for new methods, removed methods, and return type changes
  # 4. Review any nil values (methods that couldn't be parsed)
  # 5. Add fallback cases for edge case methods if needed
  # 6. If everything looks correct, replace the existing endpoints.json
  #
  # @note Natural language dependency - Relies on specific phrasing in descriptions (e.g., "Returns X")
  # @note Pattern brittleness - Documentation style changes could break pattern matching
  # @note Incomplete coverage - Some methods may not match any pattern and return nil
  # @note No parameter parsing - Only parses return types, not method parameters or their types
  # @note Manual fallbacks needed - Edge case methods require hardcoded return types
  # @note No validation - Doesn't verify if return type actually exists in types.json
  #
  # @example Basic usage
  #   parser = MethodsParser.new
  #   methods = parser.parse  # Fetch, parse, and return all methods as a hash
  #   File.write('endpoints.json', JSON.pretty_generate(methods))
  #
  # @example With custom URL
  #   parser = MethodsParser.new('https://core.telegram.org/bots/api')
  #   methods = parser.parse
  #   # Use methods hash directly or save to file
  #
  # @example Generated output format
  #   {
  #     "getMe": "Types::User",
  #     "sendMessage": "Types::Message",
  #     "getUpdates": "Types::Array.of(Types::Update)",
  #     "stopPoll": "Types::Poll | Types::Bool",
  #     "forwardMessage": "Types::Message",
  #     "deleteMessage": "Types::Bool"
  #   }
  #
  # @see https://core.telegram.org/bots/api Official Telegram Bot API documentation
  #
  class MethodsParser
    # Map Telegram API type names to Ruby type representations
    TYPE_MAPPING = {
      'Integer' => 'Types::Integer',
      'String' => 'Types::String',
      'Boolean' => 'Types::Bool',
      'Bool' => 'Types::Bool',
      'True' => 'Types::Bool',
      'Float' => 'Types::Float',
      'Int' => 'Types::Integer'
    }.freeze

    # Creates a new methods parser instance.
    #
    # @param url [String] The URL of the Telegram Bot API documentation page
    # @return [MethodsParser] A new parser instance
    #
    # @example Create parser with default URL
    #   parser = MethodsParser.new
    #
    # @example Create parser with custom URL
    #   parser = MethodsParser.new('https://example.com/api')
    def initialize(url = 'https://core.telegram.org/bots/api')
      @url = URI(url)
    end

    # Fetches and parses all API methods from the Telegram Bot API documentation.
    #
    # Downloads the HTML documentation, iterates through all h4 headers to
    # identify method definitions, extracts their descriptions, determines
    # return types, and returns a sorted hash.
    #
    # @return [Hash{String => String}] A hash mapping method names to return types,
    #   sorted alphabetically by method name
    # @raise [OpenURI::HTTPError] If the HTTP request fails
    # @raise [SocketError] If network connection fails
    #
    # @example
    #   parser.parse
    #   #=> {"getMe" => "Types::User", "sendMessage" => "Types::Message"}
    def parse
      methods = {}

      doc = fetch_document

      # Find all h4 headers that represent methods
      doc.css('h4').each do |header|
        method_name = header.text.strip
        next if method_name.empty?

        # Skip if it's a type (starts with uppercase)
        next if method_name[0] == method_name[0].upcase

        # Get the description and return type
        description = get_description(header)
        return_type = parse_return_type(method_name, description)

        next unless return_type

        methods[method_name] = return_type
      end

      # Sort methods alphabetically for consistency
      methods.keys.sort.each_with_object({}) do |key, hash|
        hash[key] = methods[key]
      end
    end

    private

    # Fetches the HTML documentation from the configured URL.
    #
    # @return [Nokogiri::HTML::Document] The parsed HTML document
    # @raise [OpenURI::HTTPError] If the HTTP request fails
    # @raise [SocketError] If network connection fails
    def fetch_document
      html = URI.parse(@url).open
      Nokogiri::HTML(html)
    end

    # Extracts the description text following a method header.
    #
    # Collects all paragraph elements between the h4 header and the next
    # table or section header, concatenating them into a single description.
    #
    # @param header [Nokogiri::XML::Element] The h4 element containing the method name
    # @return [String] The combined description text from all following paragraphs
    def get_description(header)
      current = header.next_element
      descriptions = []

      # Collect all paragraph descriptions before table
      while current && current.name != 'h4' && current.name != 'h3'
        break if current.name == 'table'

        descriptions << current.text.strip if current.name == 'p'
        current = current.next_element
      end

      descriptions.join(' ')
    end

    # Parses the return type from a method's description text.
    #
    # Analyzes the description using multiple regex patterns to identify
    # what type the method returns. Handles various documentation styles
    # including boolean returns, arrays, union types, and simple objects.
    #
    # @param method_name [String] The name of the method (used for fallback lookups)
    # @param description [String] The method's description text
    # @return [String, nil] The dry-types expression for the return type,
    #   or nil if the type couldn't be determined
    #
    # @example Boolean return
    #   parse_return_type('setWebhook', 'Returns True on success')
    #   #=> "Types::Bool"
    #
    # @example Array return
    #   parse_return_type('getUpdates', 'Returns an Array of Update objects')
    #   #=> "Types::Array.of(Types::Update)"
    def parse_return_type(method_name, description)
      return nil if description.empty?

      # Common patterns for return types in Telegram API docs:
      # "Returns X on success"
      # "On success, returns X"
      # "On success, X is returned"
      # "Returns an Array of X objects"
      # "Returns True on success"
      # "Returns Message or True"

      # Pattern 1: "Returns True on success" or "Returns True"
      return 'Types::Bool' if description.match?(/returns?\s+True\b/i) && !description.match?(/\s+or\s+/i)

      # Pattern 2: "Returns an Array of X" or "Returns Array of X"
      if (match = description.match(/returns?\s+(?:an?\s+)?Array of\s+(\w+)/i))
        inner_type = match[1].strip
        return "Types::Array.of(#{map_type(inner_type)})"
      end

      # Pattern 3: Union types "Returns X or Y" or "Returns Message or True"
      if (match = description.match(/returns?\s+(?:an?\s+)?(\w+)(?:\s+object)?\s+or\s+(\w+)/i))
        type1 = match[1].strip
        type2 = match[2].strip
        # Handle "Message or True" -> "Types::Message | Types::Bool"
        return "#{map_type(type1)} | #{map_type(type2)}"
      end

      # Pattern 4: "Returns basic information about the bot" -> extract "User" from context
      # Some methods describe what they return without using "Returns X" pattern
      # We'll try to extract the type from phrases like "information about X"
      if description.match?(/information about (?:the )?bot/i)
        return 'Types::User' # getMe returns User
      end

      # Pattern 5: "Returns X on success" or "On success, returns X"
      # Look for common return type patterns
      return_type_pattern = /(?:returns?|returned)\s+(?:an?\s+)?(\w+)(?:\s+(?:object|on success|is returned))?/i
      if (match = description.match(return_type_pattern))
        type_name = match[1].strip

        # Skip common words that aren't types - don't return, just skip to next pattern
        skip_words = %w[False success information object file the a an if when basic to error]
        unless skip_words.include?(type_name)
          # Check if it's a known type
          return map_type(type_name)
        end
      end

      # Pattern 6: "On success, X is returned"
      if (match = description.match(/on success,\s+(?:an?\s+)?(\w+)\s+(?:is|are)\s+returned/i))
        type_name = match[1].strip
        skip_words = %w[information the message]
        return map_type(type_name) unless skip_words.include?(type_name)
      end

      # Pattern 7: For specific methods with known return types
      # This is a fallback for methods that don't follow standard patterns
      case method_name
      when 'getUpdates'
        'Types::Array.of(Types::Update)'
      when 'setWebhook', 'deleteWebhook', 'banChatMember', 'unbanChatMember', 'setGameScore'
        'Types::Bool'
      when 'getMe'
        'Types::User'
      end
    end

    # Maps a Telegram API type name to its dry-types equivalent.
    #
    # Looks up the type in TYPE_MAPPING for primitive types (Integer, String, etc.)
    # and prefixes custom types with "Types::".
    #
    # @param type_name [String] The type name from the API documentation
    # @return [String] The corresponding dry-types type reference
    #
    # @example Primitive type
    #   map_type('Integer') #=> "Types::Integer"
    #
    # @example Custom type
    #   map_type('Message') #=> "Types::Message"
    def map_type(type_name)
      # Check if it's a primitive type
      return TYPE_MAPPING[type_name] if TYPE_MAPPING.key?(type_name)

      # Otherwise, assume it's a custom type
      "Types::#{type_name}"
    end
  end
end
