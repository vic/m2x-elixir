# AT&T M2X Elixir Client

[AT&T M2X](http://m2x.att.com) is a cloud-based fully managed time-series data storage service for network connected machine-to-machine (M2M) devices and the Internet of Things (IoT).

The [AT&T M2X API](https://m2x.att.com/developer/documentation/overview) provides all the needed operations and methods to connect your devices to AT&T's M2X service. This library aims to provide a simple wrapper to interact with the AT&T M2X API for [Elixir](http://elixir-lang.org/), a dynamic, functional language designed for building scalable and maintainable applications.

Refer to the [Glossary of Terms](https://m2x.att.com/developer/documentation/glossary) to understand the nomenclature used throughout this documentation.

## Getting Started
1. Signup for an [M2X Account](https://m2x.att.com/signup).
2. Obtain your _Master Key_ from the Master Keys tab of your [Account Settings](https://m2x.att.com/account) screen.
2. Create your first [Device](https://m2x.att.com/devices) and copy its _Device ID_.
3. Review the [M2X API Documentation](https://m2x.att.com/developer/documentation/overview).

## Usage

This library uses Elixir structs to contain data fetched from the AT&T M2X service, but these also contain all the data necessary to interact with the resource again, so they are used as convenience handles for deeper levels of the API.

In order to communicate with the M2X API, you need to create an `M2X.Client` struct containing your API key.

[M2X.Client](lib/m2x/device.ex)
```elixir
client = %M2X.Client { api_key: "<YOUR-API-KEY>" }
#=> %M2X.Client { ... }
```

The `M2X.Client` struct can be passed to functions that fetch existing remote resources and return their corresponding structs for further interactions:

- [M2X.Device](lib/m2x/device.ex)
  ```elixir
  device = M2X.Device.fetch(client, "<DEVICE-ID>")
  #=> %M2X.Device { ... }
  ```

- [M2X.Distribution](lib/m2x/distribution.ex)
  ```elixir
  distribution = M2X.Distribution.fetch(client, "<DISTRIBUTION-ID>")
  #=> %M2X.Distribution { ... }
  ```

- [M2X.Collection](lib/m2x/collection.ex)
  ```elixir
  collections = M2X.Collection.fetch(client, "<COLLECTION-ID>")
  #=> %M2X.Collection { ... }
  ```

- [M2X.Key](lib/m2x/key.ex)
  ```elixir
  key = M2X.Key.fetch(client, "<KEY-ID>")
  #=> %M2X.Key { ... }
  ```

- [M2X.Job](lib/m2x/job.ex)
  ```elixir
  key = M2X.Job.fetch(client, "<JOB-ID>")
  #=> %M2X.Job { ... }
  ```

- [M2X.Stream](lib/m2x/stream.ex)
  ```elixir
  device = M2X.Device.fetch(client, "<DEVICE-ID>")
  stream = M2X.Device.stream(device, "<STREAM-NAME>")
  #=> %M2X.Stream { ... }
  ```

The `M2X.Client` struct can also be passed to REST methods to directly access any M2X API endpoint and get an `M2X.Response` struct in return:

[M2X.Response](lib/m2x/response.ex)
```elixir
res = M2X.Client.get(client, "/some_path")
#=> %M2X.Response { ... }
res = M2X.Client.post(client, "/some/other_path", %{ "foo"=>"bar" })
#=> %M2X.Response { ... }
```

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0](http://semver.org/). As a summary, given a version number `MAJOR.MINOR.PATCH`:

1. `MAJOR` will increment when backwards-incompatible changes are introduced to the client.
2. `MINOR` will increment when backwards-compatible functionality is added.
3. `PATCH` will increment with backwards-compatible bug fixes.

Additional labels for pre-release and build metadata are available as extensions to the `MAJOR.MINOR.PATCH` format.

**Note**: the client version does not necessarily reflect the version used in the AT&T M2X API.

## License

This library is provided under the MIT license. See [LICENSE](LICENSE) for applicable terms.
