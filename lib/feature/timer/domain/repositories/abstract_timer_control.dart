abstract class AbstractTimerControl {
  Future<String?> get currentValue;

  Future<void> start();

  Future<void> stop();
}
