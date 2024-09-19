import 'package:shared_preferences/shared_preferences.dart';

class LocalPersistence {
  // método para adicionar mais um item na lista
  static Future<void> addToList(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(key) ?? [];
    list.add(value);
    await prefs.setStringList(key, list);
  }

  // método para pegar um item da lista
  static Future<List<String>> getList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  // método para atualizar um item da lista
  static Future<void> updateList(
      String key, String oldValue, String newValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(key) ?? [];

    if (list.contains(oldValue)) {
      list[list.indexOf(oldValue)] = newValue;
      await prefs.setStringList(key, list);
    } else {
      throw Exception("Item '$oldValue' não encontrado na lista.");
    }
  }

  // método para remover um item da lista
  static Future<void> removeFromList(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(key) ?? [];
    list.remove(value);
    await prefs.setStringList(key, list);
  }

  // Limpar a lista
  static Future<void> clearList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
