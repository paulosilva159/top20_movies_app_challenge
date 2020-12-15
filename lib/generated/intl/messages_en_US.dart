// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
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
  String get localeName => 'en_US';

  static m0(movie) => "${movie} favorited with success!";

  static m1(movie) => "${movie} unfavorited with success!";

  static m2(score) => "${score}: Score";

  static m3(voteQuantity) => "${voteQuantity}: Votes";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "alertDialogActionTitle" : MessageLookupByLibrary.simpleMessage("Done"),
    "alertDialogErrorMessage" : MessageLookupByLibrary.simpleMessage("Error while trying to (un)favorite!"),
    "alertDialogErrorTitle" : MessageLookupByLibrary.simpleMessage("Error"),
    "alertDialogSuccessTitle" : MessageLookupByLibrary.simpleMessage("Success"),
    "alertDialogToFavoriteSuccessMessage" : m0,
    "alertDialogToUnfavoriteSuccessMessage" : m1,
    "bottomNavigationItemGridTitle" : MessageLookupByLibrary.simpleMessage("Grid"),
    "bottomNavigationItemListTitle" : MessageLookupByLibrary.simpleMessage("List"),
    "connectionErrorMessage" : MessageLookupByLibrary.simpleMessage("Verify your connection!"),
    "detailsScreenTopTitle" : MessageLookupByLibrary.simpleMessage("Details"),
    "detailsTileScore" : m2,
    "detailsTileVotesQtt" : m3,
    "dioErrorMessage" : MessageLookupByLibrary.simpleMessage("Error while trying to obtain data"),
    "favoritesListScreenTitle" : MessageLookupByLibrary.simpleMessage("Favorites"),
    "genericErrorMessage" : MessageLookupByLibrary.simpleMessage("Error!"),
    "tryAgainMessage" : MessageLookupByLibrary.simpleMessage("Try Again")
  };
}
