# DNS JSON API

## Dependencies
- Ruby 2.5.1
- Bundler 1.16+

## Configuration

```bash
$ bundle install
$ bundle exec rake db:setup
```

## Run server
```bash
$ bundle exec rails server
```

## Run tests
```bash
$ bundle exec rspec
$ bundle exec rspec -fd # to run tests with description
```

## Endpoints
### Create a DNS
`POST /api/v1/domain_name_systems`

Request Body:
```json
{
  "domain_name_system": {
    "address": "8.8.0.0",
    "hosts": [ "google.com", "google.com.br" ]
  }
}
```
- `address`(required): the IP address of the DNS server
- `hosts`(optional): an array of domains of the DNS server

### List DNSs
`GET /api/v1/domain_name_systems`

Request Body:
```json
{
  "page": 1,
  "included_hostnames": [ "ipsum.com" ],
  "excluded_hostnames": [ "lorem.com" ],
}
```
- `page`(required): page number
- `included_hostnames`(optional): an array of domains the DNSs must have
- `excluded_hostnames`(optional): an array of domains the DNSs must not have


# License
Copyright 2018 Mateus Cruz, github.com/mateuscruz

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
