import 'package:equatable/equatable.dart';

abstract class MemoryEvent extends Equatable {
  const MemoryEvent();

  @override
  List<Object> get props => [];
}

class LoadUserMemories extends MemoryEvent {
  final String uid;

  const LoadUserMemories(this.uid);

  @override
  List<Object> get props => [uid];
}
