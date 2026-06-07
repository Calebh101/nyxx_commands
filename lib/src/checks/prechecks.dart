import 'dart:async';

import 'package:nyxx/nyxx.dart';

typedef PrecheckData = DispatchEvent;
List<Precheck> _prechecks = [];

FutureOr<bool> firePrechecks(PrecheckData data) async {
  for (final x in _prechecks) {
    if (await x.callback.call(data) == false) {
      return false;
    }
  }

  return true;
}

class Precheck {
  final FutureOr<bool> Function(PrecheckData data) callback;
  const Precheck(this.callback);

  static void addPrecheck(Precheck check) {
    return _prechecks.add(check);
  }
}

extension GetData on DispatchEvent {
  T getData<T>(T Function(MessageComponentInteraction event) onMessageComponentInteraction, T Function(MessageCreateEvent event) onMessageCreate, T Function(InteractionCreateEvent<ApplicationCommandInteraction> event) onApplicationCommandInteraction, T Function(InteractionCreateEvent<ApplicationCommandAutocompleteInteraction> event) onApplicationCommandAutocompleteInteraction) {
    if (this is MessageComponentInteraction) return onMessageComponentInteraction.call(this as MessageComponentInteraction);
    if (this is MessageCreateEvent) return onMessageCreate.call(this as MessageCreateEvent);
    if (this is InteractionCreateEvent<ApplicationCommandInteraction>) return onApplicationCommandInteraction.call(this as InteractionCreateEvent<ApplicationCommandInteraction>);
    if (this is InteractionCreateEvent<ApplicationCommandAutocompleteInteraction>) return onApplicationCommandAutocompleteInteraction.call(this as InteractionCreateEvent<ApplicationCommandAutocompleteInteraction>);
    throw UnimplementedError("Invalid type: $runtimeType");
  }
}