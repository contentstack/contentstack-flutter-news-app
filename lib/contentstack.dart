import 'dart:convert';
import 'package:http/http.dart' as http;

class Contentstack {
  /* This is the contentstack class used to instantiate stack*/
  static Stack stack({String apiKey, String accessToken, String environment}) {
    if (apiKey == null || apiKey.isEmpty) {
      return throw new ArgumentError('Kindly provide apiKey');
    } else if (accessToken == null || accessToken.isEmpty) {
      return throw new ArgumentError('Kindly provide accessToken');
    } else if (accessToken == null || accessToken.isEmpty) {
      return throw new ArgumentError('Kindly provide environment');
    }

    /* Instance of the config */
    Config _config = Config(apiKey, accessToken, environment);
    return Stack(_config);
  }
}

class Config {
  /*
  Docs for the config
   */
  String _apiKey;
  String _accessToken;
  String _environment;
  String host = 'cdn.contentstack.io';
  String _region = 'us';

  Config(this._apiKey, this._accessToken, this._environment);

  Config setRegion({String region}) {
    this._region = region;
    if (this._region != 'us') {
      this.host = '$region-cdn.contentstack.com';
    }
    return this;
  }

  Config setHost({String host}) {
    if (host != null || host.isEmpty) {
      this.host = host;
    }
    return this;
  }

  _endpoint() {
    return '$host';
  }
}

class Stack {
  final Config config;
  String _contentTypeName;
  Stack(this.config);

  ContentType contentType(String contentTypeUid) {
    if (contentTypeUid == null || contentTypeUid.isEmpty) {
      return throw new ArgumentError('Please provide valid content_type_uid');
    }
    _contentTypeName = contentTypeUid;
    ContentType contentType = new ContentType(_contentTypeName);
    contentType.setConfig(this.config);
    return contentType;
  }

  Asset asset(String uid) {
    Asset asset = new Asset.uid(uid);
    asset.setConfig(config);
    return asset;
  }

  Asset assets() {
    Asset asset = new Asset();
    asset.setConfig(config);
    return asset;
  }
}

class ContentType {
  // content type of the stack.
  String contentTypeName;

  Config config;

  ContentType(this.contentTypeName);

  setConfig(config) {
    this.config = config;
  }

  Entry entry({String uid}) {
    Entry entry = Entry();
    if (uid != null && uid.isNotEmpty) {
      entry._uid = uid;//new Entry.uid(uid);
    }
    entry.setConfig(config, this.contentTypeName);
    return entry;
  }
}

class Entry {
  String _uid;
  String _contentTypeUid;
  Config config;
  Map<String, String> _queryParameters = {};

  Entry();
  Entry.uid(this._uid);

  setConfig(config, contentTypeUid) {
    this.config = config;
    this._contentTypeUid = contentTypeUid;
  }

  Entry version({int version}) {
    this._queryParameters['version'] = version.toString();
    return this;
  }

  Entry locale({String locale}) {
    this._queryParameters['locale'] = locale;
    return this;
  }

  fetch() async {
    if (this._uid == null || this._uid.isEmpty) {
      throw ArgumentError('Kindly provide entry_uid');
    }
    this._queryParameters['environment'] = config._environment;
    Uri uri = Uri.https(
        config._endpoint().toString(),
        '/v3/content_types/$_contentTypeUid/entries/$_uid',
        this._queryParameters);
    return await HTTPConnection(config, uri).getData();
  }

  find(Map<String, String> queryPrams) async {
    if (queryPrams == null) {
      throw TypeError();
    }
    this._queryParameters['environment'] = config._environment;
    this._queryParameters.addAll(queryPrams);
    Uri uri = Uri.https(config._endpoint(),
        '/v3/content_types/$_contentTypeUid/entries', this._queryParameters);
    return await HTTPConnection(config, uri).getData();
  }
}

class Asset {
  String _uid;
  Asset();
  Config _config;
  Map<String, String> _queryParameters = {};
  Asset.uid(this._uid);

  setConfig(config) {
    this._config = config;
  }

  Asset relativeUrl() {
    this._queryParameters['relative_urls'] = 'true';
    return this;
  }

  Asset includeDimension() {
    this._queryParameters['include_dimension'] = 'true';
    return this;
  }

  fetch() async {
    if (_uid == null || _uid.isEmpty) {
      throw ArgumentError('Kindly provide asset_uid');
    }
    Uri uri = Uri.https(
        this._config._endpoint(), '/v3/assets/$_uid', this._queryParameters);
    return await HTTPConnection(_config, uri).getData();
  }

  find(Map query) async {
    if (query == null) {
      throw TypeError();
    }
    Uri uri = Uri.https(
        this._config._endpoint(), '/v3/assets', this._queryParameters);
    return await HTTPConnection(_config, uri).getData();
  }
}

class HTTPConnection {
  // This class returns Server result.
  Uri _uri;
  Config _config;
  HTTPConnection(this._config, this._uri);

  getData() async {
    // getting server data
    Map headers = <String, String>{
      'api_key': this._config._apiKey,
      'access_token': this._config._accessToken,
      'Content-Type': 'application/json',
      'X-User-Agent': 'contentstack-cda-dart-flutter-sdk-v0.0.1'
    };

    try {
      var response = await http.get(this._uri, headers: headers);
      if (response.body != null || response.body.isNotEmpty) {
        Map responseBody = jsonDecode(response.body);
        //var statusCode = response.statusCode;
        //print('response $statusCode :: $responseBody');
        return responseBody;
      }
    } catch (e) {
      e.toString();
    }
  }
}
