# Changelog

## 2.4.0

### Added

- [Bot API 8.3](https://core.telegram.org/bots/api-changelog#february-12-2025) [#323](https://github.com/atipugin/telegram-bot-ruby/pull/323)

## 2.3.0

### Added

- [Bot API 8.2](https://core.telegram.org/bots/api#january-1-2025) [#322](https://github.com/atipugin/telegram-bot-ruby/pull/322)

## 2.2.0

### Added

- [Bot API 8.1](https://core.telegram.org/bots/api-changelog#december-4-2024) [#319](https://github.com/atipugin/telegram-bot-ruby/pull/319)

## 2.1.0

### Added

- [Bot API 8.0](https://core.telegram.org/bots/api-changelog#november-17-2024) (thx [@seorgiy](https://github.com/seorgiy))

## 2.0.0

### Added

- [Bot API 7.0](https://core.telegram.org/bots/api-changelog#december-29-2023)

### Changed

- API method calls now return corresponding response objects ([#285](https://github.com/atipugin/telegram-bot-ruby/pull/285), thx [@AlexWayfer](https://github.com/AlexWayfer))

## 1.0.0

- Replace [virtus](https://github.com/solnic/virtus) with [dry-struct](https://github.com/dry-rb/dry-struct)
- Use [zeitwerk](https://github.com/fxn/zeitwerk) for code loading
- Implement [Bot API 6.4](https://core.telegram.org/bots/api-changelog#december-30-2022)
- Implement [Bot API 6.5](https://core.telegram.org/bots/api-changelog#february-3-2023)

## 0.23.0

- Rename `Telegram::Bot.configuration` options:
  - `timeout` to `connection_timeout`
  - `open_timeout` to `connection_open_timeout`
- Fix issue with missing default value for long-polling timeout

## 0.21.0

- Implement [Bot API 6.1](https://core.telegram.org/bots/api-changelog#june-20-2022)
- Implement [Bot API 6.2](https://core.telegram.org/bots/api-changelog#august-12-2022)

## 0.20.0

- Update `faraday` up to `2.0`

## 0.19.0

- Implement [Bot API 6.0](https://core.telegram.org/bots/api-changelog#april-16-2022)
- Update `rubocop` up to `1.27`

## 0.18.0

- Implement [Bot API 5.2](https://core.telegram.org/bots/api-changelog#april-26-2021)
- Implement [Bot API 5.3](https://core.telegram.org/bots/api-changelog#june-25-2021)
- Implement [Bot API 5.4](https://core.telegram.org/bots/api-changelog#november-5-2021)
- Implement [Bot API 5.5](https://core.telegram.org/bots/api-changelog#december-7-2021)
- Implement [Bot API 5.6](https://core.telegram.org/bots/api-changelog#december-30-2021)
- Implement [Bot API 5.7](https://core.telegram.org/bots/api-changelog#january-31-2022)

## 0.17.0

- Pin `faraday` to 1.0

## 0.16.0

- Replace `inflecto` with `dry-inflector`
- Update `virtus` up to 2.0

## 0.15.0

- Implement [Bot API 5.1](https://core.telegram.org/bots/api-changelog#march-9-2021)

## 0.14.0

- Implement [Bot API 5.0](https://core.telegram.org/bots/api-changelog#november-4-2020)

## 0.13.0

- Implement [Bot API 4.9](https://core.telegram.org/bots/api-changelog#june-4-2020)
- Implement [Bot API 4.8](https://core.telegram.org/bots/api-changelog#april-24-2020)
- Implement [Bot API 4.7](https://core.telegram.org/bots/api-changelog#march-30-2020)

## 0.12.0

- Implement [Bot API 4.5](https://core.telegram.org/bots/api-changelog#december-31-2019) and [Bot API 4.6](https://core.telegram.org/bots/api-changelog#january-23-2020)

## 0.11.0

- Implement [Bot API 4.4](https://core.telegram.org/bots/api-changelog#july-29-2019)

## 0.10.1

- Fix issue #202 with `Poll` messages and logging

## 0.10.0

- Implement [Bot API 4.3](https://core.telegram.org/bots/api-changelog#may-31-2019)

## 0.9.1

- Allow to configure API URL (thx [@markfrst][])

## 0.9.0

- Implement [Bot API 4.2](https://core.telegram.org/bots/api-changelog#april-14-2019)
- Implement [Bot API 4.1](https://core.telegram.org/bots/api-changelog#august-27-2018)
- Implement [Bot API 4.0](https://core.telegram.org/bots/api-changelog#july-26-2018)
- Implement [Bot API 3.6](https://core.telegram.org/bots/api-changelog#february-13-2018)

## 0.8.6.1

- Fix #163

## 0.8.6

- Implement [Bot API 3.5](https://core.telegram.org/bots/api-changelog#november-17-2017)

## 0.8.5

- Implement [Bot API 3.4](https://core.telegram.org/bots/api-changelog#october-11-2017) (thx [@ivanovaleksey][])

## 0.8.4

- Implement [Bot API 3.3](https://core.telegram.org/bots/api-changelog#august-23-2017) (thx [@ivanovaleksey][])

## 0.8.3

- Implement [Bot API 3.2](https://core.telegram.org/bots/api-changelog#july-21-2017) (thx [@ivanovaleksey][])

## 0.8.2

- Implement [Bot API 3.1](https://core.telegram.org/bots/api-changelog#june-30-2017) (thx [@ivanovaleksey][])

## 0.8.1

- Add [missing methods](https://github.com/atipugin/telegram-bot-ruby/pull/127) from earlier versions earlier

## 0.8.0

- Implement [Bot API 3.0](https://core.telegram.org/bots/api-changelog#may-18-2017) (thx [@ivanovaleksey][])

## 0.7.2

- Bug fixes

## 0.7.1

- Implement [Bot API 2.3.1](https://core.telegram.org/bots/api-changelog#december-4-2016)

## 0.7.0

- Implement [Bot API 2.3](https://core.telegram.org/bots/api-changelog#november-21-2016) (thx [@ivanovaleksey][])

## 0.6.0

- Implement Bot API changes (October 3, 2016 API update)

## 0.5.2

- Implement Bot API 2.1 changes

## 0.5.1

- Update `Sticker` and `Message` objects (May 6, 2016 API update)

## 0.5.0

- Replace [httparty](https://github.com/jnunemaker/httparty) with [faraday](https://github.com/lostisland/faraday)
- Implement [Bot API 2.0](https://core.telegram.org/bots/2-0-intro)

## 0.4.2

- Let `Client#logger` be overwritten later (use `attr_accessor` instead of `attr_reader`)

[@ivanovaleksey]: https://github.com/ivanovaleksey
[@markfrst]: https://github.com/markfrst
