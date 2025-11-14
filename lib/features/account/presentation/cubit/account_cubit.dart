import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountState {
  final User? user;
  final bool loading;
  final String? error;

  AccountState({this.user, this.loading = false, this.error});

  AccountState copyWith({User? user, bool? loading, String? error}) {
    return AccountState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class AccountCubit extends Cubit<AccountState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AccountCubit() : super(AccountState()) {
    loadProfile();
  }

  void loadProfile() {
    emit(state.copyWith(loading: true));
    final u = _auth.currentUser;
    emit(state.copyWith(user: u, loading: false));
  }
}
