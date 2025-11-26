# Telegram Bot API Type Attributes Parser

This parser generates the `data/type_attributes.json` file by scraping and parsing the official [Telegram Bot API documentation](https://core.telegram.org/bots/api).

## Why This Parser?

The OpenAPI schema for Telegram Bot API is no longer being updated, making it necessary to parse the HTML documentation directly to keep type definitions up-to-date with the latest Bot API changes.

## Structure Analysis

### type_attributes.json Format

The generated JSON file contains type definitions with the following structure:

```json
{
  "TypeName": {
    "field_name": {
      "type": "string|integer|boolean|CustomType|array",
      "required": true,          // Optional: present if field is required
      "default": true,            // Optional: default value (mainly for boolean fields)
      "items": "ItemType",        // Required for array types
      "required_value": "value"   // Optional: for discriminator fields in union types
    }
  }
}
```

### Type Categories

The parser handles three categories of types:

1. **Regular Types** - Types with fields and attributes (e.g., `User`, `Message`)
   ```json
   "User": {
     "id": { "type": "integer", "required": true },
     "first_name": { "type": "string", "required": true },
     "username": { "type": "string" }
   }
   ```

2. **Union Types** - Types that can be one of several concrete types (e.g., `MessageOrigin`)
   ```json
   "MessageOrigin": {
     "type": ["MessageOriginUser", "MessageOriginHiddenUser", "MessageOriginChat", "MessageOriginChannel"]
   }
   ```

3. **Empty Types** - Marker types with no fields (e.g., `ForumTopicClosed`)
   ```json
   "ForumTopicClosed": {}
   ```

## Usage

### Basic Usage

```bash
# Generate type_attributes.json
ruby lib/telegram_api_parser.rb

# Specify custom output file
ruby lib/telegram_api_parser.rb data/my_types.json
```

### Programmatic Usage

```ruby
require_relative 'lib/telegram_api_parser'

parser = TelegramApiParser.new
parser.fetch                 # Fetch HTML from Telegram Bot API docs
parser.parse                 # Parse types from HTML
parser.add_custom_types!     # Add custom types (like Error)
parser.save('output.json')   # Save to file

# Or get JSON string
json_string = parser.to_json
```

## How It Works

### 1. HTML Structure Detection

The parser identifies type definitions by analyzing the HTML structure:

- **Type headers**: `<h4>` elements containing type names
- **Type descriptions**: `<p>` elements following headers
- **Field tables**: `<table>` elements with "Field | Type | Description" headers
- **Union member lists**: `<ul>` lists following union type descriptions

### 2. Type Detection Logic

**Regular Types**:
- Have an h4 header followed by a table with columns: Field | Type | Description
- Each table row defines a field with its type and whether it's optional/required

**Union Types**:
- Have an h4 header followed by a description paragraph containing keywords like:
  - "can be one of"
  - "should be one of"
  - "currently, the following N types"
  - "currently support the following N"
- Followed by a `<ul>` list of member type names
- No table present

**Empty Types**:
- Have an h4 header followed by a description containing:
  - "currently holds no information"
  - "placeholder, holds no information"
- No table or list present

### 3. Field Attribute Parsing

For each field in a regular type:

- **Type**: Extracted from the "Type" column
  - Primitives: `Integer`, `String`, `Boolean`, `Float` → mapped to lowercase
  - `True` → `boolean` with `default: true`
  - Arrays: `Array of X` → `{ type: "array", items: "X" }`
  - Custom types: Referenced by name

- **Required**: Determined by checking if description starts with "Optional"
  - If not optional → `required: true`
  - If optional → no required field (implicit false)

- **Default**: Set for boolean fields with type "True"

- **Required Value**: For discriminator fields (like `type` or `source`) in union type members

## Output Statistics

Current output (as of latest API version):
- **Regular types**: 250
- **Union types**: 21
- **Empty types**: 6
- **Custom types**: 1 (Error)
- **Total**: 278 types

## Comparison with Existing Data

The parser has been validated against the existing `type_attributes.json`:

```bash
# Compare generated vs existing
ruby -r json -e "
existing = JSON.parse(File.read('data/type_attributes.json'))
generated = JSON.parse(File.read('data/type_attributes_generated.json'))
puts 'Existing: ' + existing.keys.size.to_s
puts 'Generated: ' + generated.keys.size.to_s
"
```

### New Types Detected

The parser automatically detects new types added to the Telegram Bot API that may not be in the existing `type_attributes.json`, such as:
- Checklist-related types (ChecklistTask, Checklist, etc.)
- Suggested post types (SuggestedPostParameters, etc.)
- New gift system types (UniqueGift, GiftInfo, etc.)
- Story-related types (StoryAreaType variants, etc.)

## Maintenance

### Updating Type Attributes

To update the types after a new Bot API release:

```bash
# 1. Generate new types
ruby lib/telegram_api_parser.rb data/type_attributes_new.json

# 2. Review differences
ruby -r json -e "
old = JSON.parse(File.read('data/type_attributes.json'))
new = JSON.parse(File.read('data/type_attributes_new.json'))
puts 'New types: ' + (new.keys - old.keys).join(', ')
puts 'Removed types: ' + (old.keys - new.keys).join(', ')
"

# 3. If everything looks good, replace the old file
mv data/type_attributes_new.json data/type_attributes.json

# 4. Regenerate Ruby type classes (if applicable)
# [Add your type generation command here]
```

### Adding Custom Types

To add types that don't exist in the official docs (like `Error`):

1. Add them in the `add_custom_types!` method in `lib/telegram_api_parser.rb`
2. Follow the same JSON structure as documented above

## Troubleshooting

### Parser doesn't detect a type

Check if the type follows the expected HTML structure:
- Use `check_union_types.rb` or `check_empty_types.rb` to inspect specific types
- The type might need a new detection pattern added to `UNION_KEYWORDS` or `EMPTY_TYPE_KEYWORDS`

### Field attributes are incorrect

The parser relies on specific patterns in the description text:
- "Optional" at the start indicates an optional field
- "must be X" indicates a required value
- Type "True" indicates a boolean with default true

### Missing dependencies

Install required gems:
```bash
bundle install
```

## Files

- `lib/telegram_api_parser.rb` - Main parser implementation
- `test_html_fetch.rb` - HTML structure exploration tool
- `check_union_types.rb` - Union type detection validator
- `check_empty_types.rb` - Empty type detection validator
- `analyze_differences.rb` - Comparison tool for existing vs generated types
- `data/type_attributes.json` - Current type attributes (manually maintained)
- `data/type_attributes_generated.json` - Generated output from parser

## License

Same as the main telegram-bot-ruby project.
