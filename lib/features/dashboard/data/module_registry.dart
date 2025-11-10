
import '../../../core/interfaces/i_module.dart';
import '../../notes/presentation/notes_module.dart';
import '../../chats/presentation/chat_module.dart';
import '../../analytics/presentation/analytics_module.dart';

class ModuleRegistry {
  static final ModuleRegistry _instance = ModuleRegistry._internal();
  factory ModuleRegistry() => _instance;
  ModuleRegistry._internal();

  final List<IModule> _modules = [];

  void registerModules() {
    _modules.clear();
    _modules.addAll([
      NotesModule(),
      ChatModule(),
      AnalyticsModule(),
    ]);
    
    // Sort by priority
    _modules.sort((a, b) => a.priority.compareTo(b.priority));
  }

  List<IModule> get modules => List.unmodifiable(_modules);

  IModule? getModuleById(String id) {
    try {
      return _modules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }
}