import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

mixin LaunchUrl<Event, State, SideEffect>
    on SideEffectBloc<Event, State, SideEffect> {
  Future<void> launchExternalUrl(Uri url) async {
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } on Exception catch (e, stackTrace) {
      addError(e, stackTrace);
    }
  }
}
