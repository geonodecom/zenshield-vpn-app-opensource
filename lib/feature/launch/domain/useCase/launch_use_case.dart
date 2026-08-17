enum LaunchType { first, normal }

abstract class AbstractLaunchUseCase {
  Future<LaunchType> handle();
}
