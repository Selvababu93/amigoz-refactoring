class SetupState {
  final bool loading;
  const SetupState({this.loading = false});
  SetupState copyWith({bool? loading}) {
    return SetupState(loading: loading ?? this.loading);
  }
}
