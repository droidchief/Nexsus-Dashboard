import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/sync_manager.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final LocalStorage _storage;
  final SyncManager _syncManager;

  NoteRepositoryImpl(this._storage, this._syncManager);

  @override
  Future<List<Note>> getNotes() async {
    final notesData = _storage.getAllNotes();
    return notesData.map((json) => NoteModel.fromJson(json)).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<Note?> getNoteById(String id) async {
    final noteData = _storage.getNote(id);
    return noteData != null ? NoteModel.fromJson(noteData) : null;
  }

  @override
  Future<void> saveNote(Note note) async {
    final model = NoteModel.fromEntity(note);
    await _storage.saveNote(note.id, model.toJson());
    
    // Queue for sync
    await _syncManager.queueAction('save_note', model.toJson());
  }

  @override
  Future<void> deleteNote(String id) async {
    await _storage.deleteNote(id);
    
    // Queue for sync
    await _syncManager.queueAction('delete_note', {'id': id});
  }
}