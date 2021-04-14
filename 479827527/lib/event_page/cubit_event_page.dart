import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../event.dart';
import '../note.dart';
import '../utils/database.dart';
import '../utils/shared_preferences_provider.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage() : super(StatesEventPage());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init(Note note) async {
    setCurrentNote(note);
    setCurrentEventsList(<Event>[]);
    setSelectedIconIndex(-1);
    setTextEditState(false);
    setTextSearchState(false);
    setAddingPhotoState(false);
    setSendPhotoButtonState(true);
    setSortedByBookmarksState(false);
    setSelectedItemIndex(-1);
    setSelectedPageReplyIndex(0);
    setSelectedDate('');
    setSelectedTime('');
    initSharedPreferences();
    setCurrentEventsList(
        await _databaseProvider.fetchEventsList(state.note.noteId));
  }

  void setSortedByBookmarksState(bool isSorted) =>
      emit(state.copyWith(isSortedByBookmarks: isSorted));

  void setCurrentNote(Note note) => emit(state.copyWith(note: note));

  void setAddingPhotoState(bool isAddingPhoto) =>
      emit(state.copyWith(isAddingPhoto: isAddingPhoto));

  void setSendPhotoButtonState(bool isSendPhotoButton) =>
      emit(state.copyWith(isSendPhotoButton: isSendPhotoButton));

  void setTextEditState(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void setTextSearchState(bool isSearch) =>
      emit(state.copyWith(isSearch: isSearch));

  void setSelectedItemIndex(int selectedItemIndex) =>
      emit(state.copyWith(selectedItemIndex: selectedItemIndex));

  void setSelectedPageReplyIndex(int selectedPageReplyIndex) =>
      emit(state.copyWith(selectedPageReplyIndex: selectedPageReplyIndex));

  void setCurrentEventsList(List<Event> currentEventsList) =>
      emit(state.copyWith(currentEventsList: currentEventsList));

  void setSelectedIconIndex(int index) =>
      emit(state.copyWith(selectedIconIndex: index));

  void setSelectedDate(String selectedDate) =>
      emit(state.copyWith(selectedDate: selectedDate ?? selectedDate));

  void setSelectedTime(String selectedTime) =>
      emit(state.copyWith(selectedTime: selectedTime));

  void initSharedPreferences() {
    emit(state.copyWith(
      isDateTimeModification:
          SharedPreferencesProvider().fetchDateTimeModification(),
      isBubbleAlignment: SharedPreferencesProvider().fetchBubbleAlignment(),
      isCenterDateBubble: SharedPreferencesProvider().fetchCenterDateBubble(),
    ));
  }

  void resetDateTimeModifications() =>
      emit(state.copyWith(selectedTime: '', selectedDate: ''));

  void editText(int index, String text) {
    state.currentEventsList[index].text = text;
    state.currentEventsList[index].circleAvatarIndex = state.selectedIconIndex;
    setSelectedItemIndex(-1);
    setTextEditState(false);
  }

  void sortEventsByDate() {
    state.currentEventsList
      ..sort(
        (a, b) {
          final aDate = DateFormat().add_yMMMd().parse(a.date);
          final bDate = DateFormat().add_yMMMd().parse(b.date);
          return bDate.compareTo(aDate);
        },
      );
    setCurrentEventsList(state.currentEventsList);
  }

  void deleteEvent(int index) {
    _databaseProvider.deleteEvent(state.currentEventsList[index]);
    state.currentEventsList.removeAt(index);
    setCurrentEventsList(state.currentEventsList);
  }

  void removeSelectedIcon() => setSelectedIconIndex(-1);

  void updateNote() => _databaseProvider.updateNote(state.note);

  void addEvent(String text) async {
    final event = Event(
      date: state.selectedDate != ''
          ? state.selectedDate
          : DateFormat.yMMMd().format(
              DateTime.now(),
            ),
      imagePath: null,
      circleAvatarIndex: state.selectedIconIndex,
      text: text,
      bookmarkIndex: 0,
      currentNoteId: state.note.noteId,
      time: state.selectedTime != ''
          ? state.selectedTime
          : DateFormat('hh:mm a').format(
              DateTime.now(),
            ),
    );
    state.currentEventsList.insert(0, event);
    setCurrentEventsList(state.currentEventsList);
    event.eventId = await _databaseProvider.insertEvent(event);
  }

  void updateBookmark(int index) {
    state.currentEventsList[index].bookmarkIndex == 0
        ? state.currentEventsList[index].bookmarkIndex = 1
        : state.currentEventsList[index].bookmarkIndex = 0;
    setCurrentEventsList(state.currentEventsList);
    _databaseProvider.updateEvent(state.currentEventsList[index]);
  }

  Future<void> addImageEvent(File image) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await image.copy('${appDirectory.path}/$fileName');
    final event = Event(
      date: state.selectedDate != ''
          ? state.selectedDate
          : DateFormat.yMMMd().format(
              DateTime.now(),
            ),
      time: state.selectedTime != ''
          ? state.selectedTime
          : DateFormat('hh:mm a').format(
              DateTime.now(),
            ),
      text: '',
      bookmarkIndex: 0,
      imagePath: savedImage.path,
      currentNoteId: state.note.noteId,
    );
    event.circleAvatarIndex = -1;
    setAddingPhotoState(false);
    state.currentEventsList.insert(0, event);
    event.eventId = await _databaseProvider.insertEvent(event);
  }

  void transferEvent(List<Note> noteList, int index) async {
    final replySubtitle = state.currentEventsList[index].imagePath == null
        ? '${state.currentEventsList[index].text}  ${state.currentEventsList[index].time}'
        : 'Image';
    final event = Event(
      date: state.currentEventsList[index].date,
      text: state.currentEventsList[index].text,
      time: state.currentEventsList[index].time,
      bookmarkIndex: state.currentEventsList[index].bookmarkIndex,
      imagePath: state.currentEventsList[index].imagePath,
      currentNoteId: noteList[state.selectedPageReplyIndex].noteId,
      circleAvatarIndex: state.currentEventsList[index].circleAvatarIndex,
    );
    noteList[state.selectedPageReplyIndex].subtitle = replySubtitle;
    deleteEvent(index);
    event.eventId = await _databaseProvider.insertEvent(event);
  }
}
