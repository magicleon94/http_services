# 3.0.1
* Replaced DioError with DioException as it was deprecated
# 3.0.0
* Bumped dio version to 5.5.0+1
* Bumped http_mock_adapter to ^0.6.1
* Replaced old pedantic dependency with lints
# 2.1.1
Added `toString`implementation for `ResponseMappingException` and `UnexpectedStatusCodeException`.
# 2.1.0
Added `download` and `getBytes` features.
# 2.0.3
* `networkError` in `ApiError` is now non nullable
# 2.0.2
* Added `allowCache` parameter
# 2.0.1
* ResponseMappingException now includes the stacktrace
# 2.0.0
* Sound null safety migration
* Added RequestCanceledException to catch when a request is canceled
# 2.0.0-beta2
Updated readme with some notes.
# 2.0.0-beta1
Added sound null safety.
# 1.2.6
* Added unit tests [#3](https://github.com/magicleon94/http_services/pull/3)
# 1.2.5+1
* Fixed README [#2](https://github.com/magicleon94/http_services/pull/2)
# 1.2.5
* ApiException now includes the original exception.
# 1.2.4
* Mapper and orElse now take the raw Response as parameter
# 1.2.3
* Dio exposed
# 1.2.2
* Fixed web compatibility
# 1.2.1
* Added error response body.
# 1.2.0
* Added methods to perform `PUT`, `DELETE` and `PATCH`requests.
# 1.1.1
* `ApiException` `toString` method now returns the `httpMessage`.
# 1.1.0
* Separated `DisposableObject` dependency.
* Updated README
# 1.0.0+1
Formatting and description updated
# 1.0.0
Initial release
