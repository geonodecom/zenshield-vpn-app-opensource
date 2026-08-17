import 'package:injectable/injectable.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/launch/domain/useCase/launch_use_case.dart';

// ignore: unused-code
@Injectable(as: AbstractLaunchUseCase)
class LaunchUseCaseImpl implements AbstractLaunchUseCase {
  LaunchUseCaseImpl({required Preferences preferences})
      : _preferences = preferences;
  final Preferences _preferences;

  @override
  Future<LaunchType> handle() async {
    final launchCount = await _preferences.launchCount;
    final currentLaunchCount = launchCount + 1;
    await _preferences.setLaunchCount(currentLaunchCount);

    LaunchType type;

    switch (currentLaunchCount) {
      case 0:
        type = LaunchType.first;
      default:
        type = LaunchType.normal;
    }

    return type;
  }
}
