import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc(this._repository) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ClearChat>(_onClearChat);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await _repository.getMessages();
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final currentMessages = (state as ChatLoaded).messages;
      emit(ChatLoaded(currentMessages, isSending: true));
      
      try {
        await _repository.sendMessage(event.content);
        add(LoadMessages());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    }
  }

  Future<void> _onClearChat(ClearChat event, Emitter<ChatState> emit) async {
    try {
      await _repository.clearHistory();
      emit(const ChatLoaded([]));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
