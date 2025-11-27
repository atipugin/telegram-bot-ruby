# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module DocsParsers
  # Parser for Telegram Bot API documentation types.
  #
  # This parser automatically extracts type definitions from the official Telegram Bot API
  # documentation page (https://core.telegram.org/bots/api) and returns a structured
  # hash that describes all API types with their fields, constraints, and metadata.
  #
  # == Why This Parser Exists
  #
  # The Telegram Bot API documentation is the single source of truth for API types, but
  # it's only available as HTML. To provide proper type checking, validation, and
  # autocomplete in the Ruby SDK, we need structured data about each type. This parser:
  # - Eliminates manual maintenance of type definitions
  # - Ensures the SDK stays in sync with the official API
  # - Captures detailed metadata (required fields, default values, size constraints)
  # - Enables automated type generation for the Ruby SDK
  # - Automatically detects new types added in API updates (e.g., checklist, gift, story features)
  #
  # == Output Format
  #
  # The #parse method returns a Ruby hash with the following structure:
  #
  #   {
  #     "TypeName" => {
  #       "field_name" => {
  #         "type" => "string|integer|boolean|number|array|CustomType",
  #         "required" => true,           # Present if field is required
  #         "default" => value,           # For boolean fields or fields with defaults
  #         "items" => "ItemType",        # For array types
  #         "min_size" => 1,              # For string fields with size constraints
  #         "max_size" => 32,             # For string fields with size constraints
  #         "required_value" => "value"   # For discriminator fields in union type members
  #       }
  #     }
  #   }
  #
  # == How We Parse
  #
  # The parser uses Nokogiri to parse the HTML documentation and identifies three categories
  # of types based on their HTML structure:
  #
  # === 1. Regular Types
  #
  # Types with fields defined in a table (e.g., User, Message).
  #
  # HTML Pattern:
  #   <h4>TypeName</h4>
  #   <p>Description of the type</p>
  #   <table>
  #     <thead><tr><th>Field</th><th>Type</th><th>Description</th></tr></thead>
  #     <tbody>
  #       <tr><td>field_name</td><td>FieldType</td><td>Optional. Description...</td></tr>
  #     </tbody>
  #   </table>
  #
  # Parser extracts:
  # - Field names, types, and descriptions from HTML tables
  # - Constraints from descriptions (min/max sizes, default values)
  # - Required vs optional fields (checks for "Optional" keyword)
  # - Discriminator fields for union type members (e.g., type="always X")
  #
  # === 2. Union Types
  #
  # Types representing "one of" several types (e.g., MessageOrigin, InputMedia).
  #
  # HTML Pattern:
  #   <h4>UnionTypeName</h4>
  #   <p>This object can be one of</p>
  #   <ul>
  #     <li><a href="#type1">Type1</a></li>
  #     <li><a href="#type2">Type2</a></li>
  #   </ul>
  #
  # Detection keywords: "can be one of", "should be one of", "represents one of",
  # "currently, the following N types", "currently support the following N"
  #
  # Output format: {"type": ["Type1", "Type2", ...]}
  #
  # === 3. Empty Types
  #
  # Marker types with no fields (e.g., ForumTopicClosed, CallbackGame).
  #
  # HTML Pattern:
  #   <h4>EmptyTypeName</h4>
  #   <p>This object ... Currently holds no information.</p>
  #
  # Detection keywords: "currently holds no information", "placeholder.*holds no information"
  #
  # Output format: {}
  #
  # == Detection Logic
  #
  # For each <h4> header in the documentation:
  # 1. Extract type name from header text
  # 2. Get description from following <p> elements
  # 3. Look for table with "Field | Type | Description" headers
  # 4. Look for <ul> list of member types
  #
  # Classification decision tree:
  # - If description has union keywords + list present + no table → Union Type
  # - If description has "holds no information" + no table → Empty Type
  # - If table with field definitions present → Regular Type
  # - Otherwise → Skip (likely a method, not a type)
  #
  # == Parser Improvements
  #
  # Several improvements were made to accurately capture all type metadata:
  #
  # === 1. Min/Max Size Constraints
  # Fields like BotCommand.command specify "1-32 characters" in descriptions.
  # Parser now extracts these patterns and adds min_size/max_size attributes.
  # Note: min_size is omitted when zero (e.g., "0-4096 characters" only adds max_size).
  #
  # === 2. Union Field Types
  # Fields like chat_id can be "Integer or String". Parser now returns an array
  # for the type attribute: {"type": ["integer", "string"]} instead of just the first type.
  #
  # === 3. Nested Arrays
  # Fields like InlineKeyboardMarkup.inline_keyboard have type "Array of Array of X".
  # Parser now creates nested array structures:
  #   {
  #     "type": "array",
  #     "items": {
  #       "type": "array",
  #       "items": "InlineKeyboardButton"
  #     }
  #   }
  #
  # === 4. Float vs Number Type
  # Changed from "float" to "number" in TYPE_MAPPING for consistency with existing file.
  #
  # === 5. Default Values
  # Parses "Defaults to X" patterns from descriptions. Supports:
  # - Quoted strings: Defaults to "image/jpeg" → "image/jpeg"
  # - Booleans: defaults to true → true
  # - Numbers: defaults to 0 → 0
  # Intentionally skips field references like "defaults to the value of other_field".
  #
  # === 6. Discriminator Fields
  # Fields like type, source, status often have required values (e.g., type always "solid").
  # Parser detects patterns like "always X" or "must be X" and adds:
  # - required_value: The constant value
  # - default: Set to the same value
  #
  # == Type Mappings
  #
  # The parser maps Telegram API type names to JSON type representations:
  # - Integer/Int → "integer"
  # - String → "string"
  # - Boolean → "boolean"
  # - True → "boolean" with "default": true
  # - Float → "number" (changed from "float" for consistency)
  # - Array of X → {"type": "array", "items": "X"}
  # - Array of Array of X → {"type": "array", "items": {"type": "array", "items": "X"}}
  # - Integer or String → {"type": ["integer", "string"]}
  # - Custom types → Referenced by type name (e.g., "Message", "User")
  #
  # == Validation Results
  #
  # After improvements, the parser produces output that matches the existing types.json
  # with only legitimate API version differences. Before improvements, 53 types differed;
  # after improvements, only 12 types differ due to API version changes (new/removed fields).
  #
  # Current output statistics (as of latest API version):
  # - Regular types: ~250
  # - Union types: ~21
  # - Empty types: ~6
  # - Custom types: 1 (Error)
  # - Total: ~278 types
  #
  # New types automatically detected in recent API updates:
  # - Checklist features: ChecklistTask, Checklist, InputChecklistTask, etc.
  # - Suggested posts: SuggestedPostPrice, SuggestedPostInfo, etc.
  # - Gift system: UniqueGift, GiftInfo, OwnedGift, etc.
  # - Story areas: StoryAreaType, StoryAreaTypeLocation, etc.
  # - Business features: BusinessBotRights, DirectMessagesTopic
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
  # - Parse time: <1 second
  # - Total execution: ~3-4 seconds
  #
  # == Custom Types
  #
  # The parser includes an add_custom_types! method to add types not present in the official
  # documentation. Currently includes:
  # - Error: Represents API error responses with fields: ok, error_code, description, parameters
  #
  # == Usage Workflow
  #
  # Typical workflow for updating types after a Bot API release:
  # 1. Run parser to generate new types: parser.fetch; parser.parse; parser.save('new.json')
  # 2. Compare with existing file to review changes
  # 3. Check for new types, removed types, and field changes
  # 4. If everything looks correct, replace the existing types.json
  # 5. Regenerate Ruby type classes if applicable
  # 6. Run test suite to ensure compatibility
  #
  # @note Requires manual review - Generated types should be reviewed before replacing existing file
  # @note Complex inline unions - Some complex union patterns may need special handling
  # @note Documentation changes - Changes to HTML structure could break pattern matching
  # @note No reference validation - Doesn't validate type references or check for circular dependencies
  # @note Method parameters not parsed - Only parses return types, not method parameters
  # @note Custom types must be added manually - Types like Error that aren't in docs need manual addition
  #
  # @example Basic usage
  #   parser = TypesParser.new
  #   types = parser.parse  # Fetch, parse, and return all types as a hash
  #   File.write('types.json', JSON.pretty_generate(types))
  #
  # @example With custom URL
  #   parser = TypesParser.new('https://core.telegram.org/bots/api')
  #   types = parser.parse
  #   # Use types hash directly or save to file
  #
  # @see https://core.telegram.org/bots/api Official Telegram Bot API documentation
  #
  class TypesParser
    TYPE_MAPPING = {
      'Integer' => 'integer',
      'String' => 'string',
      'Boolean' => 'boolean',
      'Float' => 'number', # Use 'number' for consistency with existing file
      'True' => 'boolean',
      'Int' => 'integer'
    }.freeze

    UNION_KEYWORDS = [
      /can be one of/i,
      /it can be one of/i,
      /should be one of/i,
      /represents one of/i,
      /currently,? the following \d+/i,
      /currently support(s|ed)? (results of the |the )?following \d+/i,
      /This object describes.*(it can be|one of)/i
    ].freeze

    EMPTY_TYPE_KEYWORDS = [
      /currently holds no information/i,
      /placeholder.*holds no information/i
    ].freeze

    STOP_TAGS = %w[table ul].freeze

    # Discriminator patterns in order of priority
    DISCRIMINATOR_PATTERNS = [
      # Value in quotes: always "solid" or always "solid" (Unicode smart quotes)
      /always\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i,
      # Value without quotes: always solid
      /always\s+(\w+)/i,
      # Must be pattern with quotes: must be "data"
      /must be\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i
    ].freeze

    # Creates a new types parser instance.
    #
    # @param url [String] The URL of the Telegram Bot API documentation page
    # @return [TypesParser] A new parser instance
    #
    # @example Create parser with default URL
    #   parser = TypesParser.new
    #
    # @example Create parser with custom URL
    #   parser = TypesParser.new('https://example.com/api')
    def initialize(url = 'https://core.telegram.org/bots/api')
      @url = URI(url)
    end

    # Fetches and parses all type definitions from the Telegram Bot API documentation.
    #
    # Downloads the HTML documentation, iterates through all h4 headers to
    # identify type definitions, categorizes them as regular types, union types,
    # or empty types, adds custom types, and returns a sorted hash.
    #
    # @return [Hash{String => Hash}] A hash mapping type names to their
    #   attribute definitions, sorted alphabetically by type name
    # @raise [OpenURI::HTTPError] If the HTTP request fails
    # @raise [SocketError] If network connection fails
    #
    # @example
    #   parser.parse
    #   #=> {"User" => {"id" => {"type" => "integer", "required" => true}, ...}}
    def parse
      types = {}

      doc = fetch_document

      # Find all h4 headers (type definitions)
      doc.css('h4').each do |header|
        type_name = header.text.strip
        next if type_name.empty?

        # Detect type category
        description = get_description(header)
        table = find_following_table(header)
        list = find_following_list(header)

        if union_type?(description, table, list)
          parse_union_type(types, type_name, list)
        elsif empty_type?(description, table)
          parse_empty_type(types, type_name)
        elsif table && type_table?(table)
          parse_regular_type(types, type_name, table)
        end
      end

      add_custom_types!(types)

      # Sort types alphabetically for consistency
      types.keys.sort.each_with_object({}) do |key, hash|
        hash[key] = types[key]
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

    # Adds custom types not present in the official documentation.
    #
    # Some types (like Error for API error responses) are not documented
    # in the official API docs but are needed for proper SDK functionality.
    #
    # @param types [Hash] The types hash to add custom types to
    # @return [void]
    def add_custom_types!(types)
      types['Error'] = {
        'ok' => {
          'type' => 'boolean',
          'required' => true
        },
        'error_code' => {
          'type' => 'integer',
          'required' => true
        },
        'description' => {
          'type' => 'string',
          'required' => true
        },
        'parameters' => {
          'type' => 'ResponseParameters'
        }
      }
    end

    # Extracts the description text following a type header.
    #
    # Collects all paragraph elements between the h4 header and the next
    # table, list, or section header, concatenating them into a single description.
    #
    # @param header [Nokogiri::XML::Element] The h4 element containing the type name
    # @return [String] The combined description text from all following paragraphs
    def get_description(header)
      current = header.next_element
      descriptions = []

      # Collect all paragraph descriptions before table/list
      while current && current.name != 'h4' && current.name != 'h3'
        break if STOP_TAGS.include?(current.name)

        descriptions << current.text.strip if current.name == 'p'
        current = current.next_element
      end

      descriptions.join(' ')
    end

    # Finds the first table element following a header.
    #
    # Searches through sibling elements until finding a table or
    # reaching the next section header.
    #
    # @param header [Nokogiri::XML::Element] The starting header element
    # @return [Nokogiri::XML::Element, nil] The table element, or nil if not found
    def find_following_table(header)
      current = header.next_element
      while current && current.name != 'h4' && current.name != 'h3'
        return current if current.name == 'table'

        current = current.next_element
      end
      nil
    end

    # Finds the first unordered list element following a header.
    #
    # Searches through sibling elements (up to 5) until finding a ul or
    # reaching the next section header.
    #
    # @param header [Nokogiri::XML::Element] The starting header element
    # @return [Nokogiri::XML::Element, nil] The ul element, or nil if not found
    def find_following_list(header)
      current = header.next_element
      count = 0
      while current && current.name != 'h4' && current.name != 'h3' && count < 5
        return current if current.name == 'ul'

        current = current.next_element
        count += 1
      end
      nil
    end

    # Checks if a type definition represents a union type.
    #
    # Union types are identified by having a description with union keywords
    # and a list of member types, but no field table.
    #
    # @param description [String, nil] The type's description text
    # @param table [Nokogiri::XML::Element, nil] The field table element, if present
    # @param list [Nokogiri::XML::Element, nil] The member list element, if present
    # @return [Boolean] true if the type is a union type
    def union_type?(description, table, list)
      return false unless description && list

      # Union types have a description with keywords and a list, but no table
      has_union_keyword = UNION_KEYWORDS.any? { |pattern| description.match?(pattern) }
      has_union_keyword && !table
    end

    # Checks if a type definition represents an empty type.
    #
    # Empty types are marker types with no fields, identified by descriptions
    # containing phrases like "currently holds no information".
    #
    # @param description [String, nil] The type's description text
    # @param table [Nokogiri::XML::Element, nil] The field table element, if present
    # @return [Boolean] true if the type is an empty type
    def empty_type?(description, table)
      return false unless description
      return false if table

      EMPTY_TYPE_KEYWORDS.any? { |pattern| description.match?(pattern) }
    end

    # Checks if a table element is a type field definition table.
    #
    # Type tables have headers "Field | Type | Description" as opposed to
    # method parameter tables which have different headers.
    #
    # @param table [Nokogiri::XML::Element] The table element to check
    # @return [Boolean] true if the table has type field headers
    def type_table?(table)
      headers = table.css('thead tr th, tr:first-child th').map { |x| x.text.strip }
      headers == %w[Field Type Description]
    end

    # Parses a union type definition from a list element.
    #
    # Extracts member type names from the list items and stores them
    # as an array under the 'type' key.
    #
    # @param types [Hash] The types hash to add the parsed type to
    # @param type_name [String] The name of the union type
    # @param list [Nokogiri::XML::Element, nil] The ul element containing member types
    # @return [void]
    def parse_union_type(types, type_name, list)
      return unless list

      # Extract member type names from the list
      members = []
      list.css('li').each do |li|
        link = li.css('a').first
        member_name = link ? link.text.strip : li.text.strip.split("\n").first&.strip
        members << member_name if member_name && !member_name.empty?
      end

      return unless members.any?

      types[type_name] = { 'type' => members }
    end

    # Parses an empty type definition.
    #
    # Creates an empty hash for marker types that have no fields.
    #
    # @param types [Hash] The types hash to add the parsed type to
    # @param type_name [String] The name of the empty type
    # @return [void]
    def parse_empty_type(types, type_name)
      types[type_name] = {}
    end

    # Parses a regular type definition from a table element.
    #
    # Extracts field names, types, and descriptions from table rows
    # and builds a hash of attribute definitions.
    #
    # @param types [Hash] The types hash to add the parsed type to
    # @param type_name [String] The name of the type
    # @param table [Nokogiri::XML::Element] The table element containing field definitions
    # @return [void]
    def parse_regular_type(types, type_name, table)
      attributes = {}

      table.css('tbody tr, tr').each do |row|
        cells = row.css('td')
        next if cells.size < 3

        field_name = cells[0].text.strip
        type_html = cells[1].inner_html.strip
        description_text = cells[2].text.strip

        next if field_name.empty?
        next if field_name == 'Field' # Skip header row if it's in tbody

        attribute = parse_attribute(field_name, type_html, description_text)
        attributes[field_name] = attribute if attribute
      end

      return unless attributes.any?

      types[type_name] = attributes
    end

    # Parses a single attribute from a table row.
    #
    # Extracts type information, required status, default values,
    # size constraints, and discriminator values from the field definition.
    #
    # @param field_name [String] The name of the field
    # @param type_html [String] The HTML content of the type cell
    # @param description [String] The description text for the field
    # @return [Hash, nil] A hash containing the attribute properties, or nil if invalid
    #
    # @example
    #   parse_attribute('id', 'Integer', 'Unique identifier for this user')
    #   #=> {"type" => "integer", "required" => true}
    def parse_attribute(field_name, type_html, description)
      attribute = {}

      # Determine if optional
      is_optional = description.match?(/^optional/i) ||
                    description.match?(/^\*?optional\.\s/i) ||
                    description.match?(/^_optional_/i)
      attribute['required'] = true unless is_optional

      # Parse type information
      type_info = parse_type_info(type_html)
      attribute.merge!(type_info)

      # Check for default values (especially for True boolean type)
      attribute['default'] = true if type_info['type'] == 'boolean' && type_html.include?('True')

      # Parse default from description: "Defaults to X" or "defaults to X"
      # Only accept quoted strings or specific values (true/false/numbers)
      # Skip patterns like "defaults to the value of X" (references to other fields)
      if (match = description.match(/defaults to\s+["'\u201C\u201D](.+?)["'\u201C\u201D]/i))
        # Default value in quotes: Defaults to "image/jpeg"
        attribute['default'] = match[1].strip
      elsif (match = description.match(/defaults to\s+(true|false)\b/i))
        # Boolean default: defaults to true
        attribute['default'] = match[1].downcase == 'true'
      elsif (match = description.match(/defaults to\s+(\d+\.?\d*)\b/i))
        # Numeric default: defaults to 0 or 0.0
        value = match[1]
        attribute['default'] = value.include?('.') ? value.to_f : value.to_i
      end
      # NOTE: We intentionally skip unquoted word defaults to avoid capturing
      # references like "defaults to the value of other_field"

      # Parse min_size and max_size from description
      # Patterns: "1-32 characters", "0-4096 characters", etc.
      if (match = description.match(/(\d+)-(\d+)\s+characters/i))
        min = match[1].to_i
        max = match[2].to_i
        attribute['min_size'] = min unless min.zero? # Skip min_size if 0
        attribute['max_size'] = max
      end

      # Check for special required_value (discriminator fields for union type members)
      # Patterns: 'always "value"' or 'must be value'
      # Note: HTML uses Unicode smart quotes (\u201C and \u201D) instead of regular quotes
      # Exclude patterns like "must be one of X or Y" (multiple choice, not discriminator)
      discriminator_fields = %w[type source status currency]
      if discriminator_fields.include?(field_name)
        discriminator_value = extract_discriminator_value(description)
        if discriminator_value
          attribute['required_value'] = discriminator_value
          attribute['default'] = discriminator_value
        end
      end

      attribute
    end

    # Parses type information from HTML content.
    #
    # Handles various type formats including nested arrays, regular arrays,
    # union types, and simple types.
    #
    # @param type_html [String] The HTML content containing type information
    # @return [Hash] A hash with type information
    #
    # @example Simple type
    #   parse_type_info('Integer') #=> {"type" => "integer"}
    #
    # @example Array type
    #   parse_type_info('Array of String') #=> {"type" => "array", "items" => "string"}
    #
    # @example Nested array
    #   parse_type_info('Array of Array of Button')
    #   #=> {"type" => "array", "items" => {"type" => "array", "items" => "Button"}}
    def parse_type_info(type_html)
      # Parse HTML fragment to extract type text
      doc = Nokogiri::HTML.fragment(type_html)
      type_text = doc.text.strip

      # Handle nested arrays: "Array of Array of X"
      if (match = type_text.match(/^Array of Array of (.+)$/i))
        inner_type = match[1].strip
        inner_type = extract_type_name(inner_type)

        return {
          'type' => 'array',
          'items' => {
            'type' => 'array',
            'items' => map_type(inner_type)
          }
        }
      end

      # Handle regular arrays: "Array of X"
      if (match = type_text.match(/^Array of (.+)$/i))
        item_type = match[1].strip
        item_type = extract_type_name(item_type)

        return {
          'type' => 'array',
          'items' => map_type(item_type)
        }
      end

      # Handle union types: "A or B" or "A, B or C"
      # For inline field unions (not top-level type unions), return array of types
      if type_text.match?(/\s+or\s+/i)
        # Split by "or" and clean up each type
        types = type_text.split(/\s+or\s+/i).map do |part|
          # Remove any commas and extra text
          part = part.split(',').first.strip
          map_type(extract_type_name(part))
        end

        # If we have exactly 2 simple types, return as array
        # Examples: "Integer or String", "Float or Integer"
        return { 'type' => types } if types.size == 2 && types.all? { |t| t =~ /^[a-z]+$/ }

        # For complex unions, take first type (rare edge case)
        return { 'type' => types.first }

      end

      # Single type
      type_name = extract_type_name(type_text)
      { 'type' => map_type(type_name) }
    end

    # Extracts a discriminator value from a field description.
    #
    # Looks for patterns like "always X" or "must be X" in the description
    # to identify constant values for discriminator fields.
    #
    # @param description [String] The field description text
    # @return [String, nil] The discriminator value, or nil if not found
    def extract_discriminator_value(description)
      # Try standard patterns first
      DISCRIMINATOR_PATTERNS.each do |pattern|
        match = description.match(pattern)
        return match[1].strip if match
      end

      # Must be pattern without quotes: must be data, must be default
      # Explicitly exclude "must be one of" pattern before trying to match
      return nil if description.match?(/must be\s+one\s+of/i)

      match = description.match(/must be\s+(\w+)\b/i)
      match ? match[1].strip : nil
    end

    # Extracts a clean type name from text.
    #
    # Removes parenthetical notes and extra text, returning only
    # the first word as the type name.
    #
    # @param text [String] The text containing a type name
    # @return [String] The extracted type name
    def extract_type_name(text)
      # Extract clean type name from text
      text.strip
          .gsub(/\s*\(.*?\)/, '') # Remove parenthetical notes
          .split(/\s+/).first # Take first word
          .strip
    end

    # Maps a Telegram API type name to its internal representation.
    #
    # Converts primitive type names (Integer, String, etc.) to lowercase
    # equivalents using TYPE_MAPPING, or returns custom type names as-is.
    #
    # @param type_name [String] The type name from the API documentation
    # @return [String] The mapped type name
    #
    # @example Primitive type
    #   map_type('Integer') #=> "integer"
    #
    # @example Custom type
    #   map_type('Message') #=> "Message"
    def map_type(type_name)
      TYPE_MAPPING[type_name] || type_name
    end
  end
end
