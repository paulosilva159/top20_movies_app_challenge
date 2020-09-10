// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_BR';

  static m0(score) => "Pontuação: ${score}";

  static m1(voteQuantity) => "Qtd. de Votos: ${voteQuantity}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "bottomNavigationItemGridTitle" : MessageLookupByLibrary.simpleMessage("Grade"),
    "bottomNavigationItemListTitle" : MessageLookupByLibrary.simpleMessage("Lista"),
    "connectionErrorMessage" : MessageLookupByLibrary.simpleMessage("Verifique sua conexão!"),
    "detailsScreenTopTitle" : MessageLookupByLibrary.simpleMessage("Detalhes"),
    "detailsTileScore" : m0,
    "detailsTileVotesQtt" : m1,
    "dioErrorMessage" : MessageLookupByLibrary.simpleMessage("Erro durante tentativa de obter dados"),
    "genericErrorMessage" : MessageLookupByLibrary.simpleMessage("Deu erro!"),
    "listSavedMessage" : MessageLookupByLibrary.simpleMessage("Lista salva"),
    "tryAgainMessage" : MessageLookupByLibrary.simpleMessage("Tente Novamente"),
    "wantToSaveListMessage" : MessageLookupByLibrary.simpleMessage("Salvar lista?")
  };
}
