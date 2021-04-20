Map<String, String> splitUriFragment(Uri url) {
  Map<String, String> queryPairs = Map<String, String>();
  String query = url.fragment;
  List<String> pairs = query.split("&");
  pairs.forEach((pair) {
    queryPairs.putIfAbsent((pair.split('='))[0], () => (pair.split('='))[1]);
  });
  return queryPairs;
}
