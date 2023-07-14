abstract class INavigator  {
  void push(String route, {bool toNative = true, Map<String, dynamic>? param});
  void pop();
}