abstract class StorageService<T> {
  Future<void> init();
  Future<void> save(String key, T value);
  Future<T?> get(String key);
  Future<List<T>> getAll();
  Future<void> delete(String key);
  Future<void> clear();
  Future<void> close();
}
