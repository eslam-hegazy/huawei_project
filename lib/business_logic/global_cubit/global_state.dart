part of 'global_cubit.dart';

@immutable
abstract class GlobalState {}

class GlobalInitial extends GlobalState {}

class LanguageChangedState extends GlobalState {}
class ChangeScreenState extends GlobalState{}
class OpenDrawerState extends GlobalState{}
