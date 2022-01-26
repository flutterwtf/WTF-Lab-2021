import 'dart:developer';

import 'package:chat_diary/src/models/event_model.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/page_model.dart';

class FirebaseDBProvider {
  final FirebaseDatabase _firebaseDatabase;
  late final DatabaseReference _refPages;
  late final DatabaseReference _refMessages;

  FirebaseDBProvider() : _firebaseDatabase = FirebaseDatabase.instance {
    _refPages = _firebaseDatabase.ref().child('pages');
    _refMessages = _firebaseDatabase.ref().child('messages');
  }

  Future<List<PageModel>> retrievePages() async {
    final event = await _refPages.once();
    var pages = <PageModel>[];
    try {
      final value = event.snapshot.value;
      if (value != null) {
        final listOfMaps = (value as List<Object?>)
            .where((element) => element != null)
            .cast<Map<dynamic, dynamic>>();
        pages = listOfMaps.map((e) => PageModel.fromMap(e)).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return pages;
  }

  Future<void> insertPage(PageModel page) async {
    final pageJson = page.toMap();
    await _refPages.child(page.id.toString()).set(pageJson);
  }

  Future<void> updatePage(PageModel newPage) async {
    final pageJson = newPage.toMap();
    await _refPages.child(newPage.id.toString()).set(pageJson);
  }

  Future<void> removePage(int id) async {
    await _refPages.child(id.toString()).remove();
  }

  Future<void> addEvent(EventModel event) async {
    final eventJson = event.toMap();
    await _refMessages
        .child(event.pageId.toString())
        .child(event.id.toString())
        .set(eventJson);
  }

  Future<List<EventModel>> retrieveEvents(int pageId) async {
    final databaseEvent = await _refMessages.child(pageId.toString()).once();
    final value = databaseEvent.snapshot.value;
    print(value);
    var events = <EventModel>[];
    if (value != null) {
      try {
        final listOfMaps = (value as List<Object?>)
            .where((element) => element != null)
            .cast<Map<dynamic, dynamic>>();
        events = listOfMaps.map((e) => EventModel.fromMap(e)).toList();
      } catch (e) {
        log(e.toString());
      }
    }
    return events;
  }

  Future<void> toggleEventSelection(EventModel event) async {
    final eventJson = event.toMap();
    await _refMessages
        .child(event.pageId.toString())
        .child(event.id.toString())
        .set(eventJson);
  }

  Future<void> updateEvent(EventModel event) async {
    final eventJson = event.toMap();
    await _refMessages
        .child(event.pageId.toString())
        .child(event.id.toString())
        .set(eventJson);
  }

  Future<List<EventModel>> fetchSelectedEvents() async {}
}
