import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini/Api/Firebase/Firestore/FirestoreService.dart';
import 'memory_event.dart';
import 'memory_state.dart';


class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final FirestoreService memoryRepository;

  MemoryBloc(this.memoryRepository) : super(MemoryInitial()) {
    on<LoadUserMemories>(_onLoadUserMemories);
  }

  void _onLoadUserMemories(LoadUserMemories event, Emitter<MemoryState> emit) async {
    emit(MemoryLoading());
    try {
      final memories = await memoryRepository.getUserMemories(event.uid);
      emit(MemoryLoaded(memories));
    } catch (e) {
      emit(MemoryError(e.toString()));
    }
  }
}
