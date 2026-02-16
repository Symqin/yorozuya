import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // Constructor
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 🔥 METHOD BARU: Wajib ada untuk Auto-Login
  // Dipanggil dari main.dart menggunakan (..checkAuthStatus())
  void checkAuthStatus() async {
    // Opsional: emit loading sebentar agar splash screen tampil
    // emit(AuthLoading());

    // Cek user langsung dari cache Firebase
    final user = _auth.currentUser;

    if (user != null) {
      // Jika user sudah pernah login sebelumnya
      emit(AuthSuccess(user));
    } else {
      // Jika belum ada user, kembali ke halaman login
      emit(AuthInitial());
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "An unknown error occurred"));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "An unknown error occurred"));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 🛠️ FIX BUG: Jika user cancel (batalkan) login google
      if (googleUser == null) {
        // Jangan biarkan loading terus, kembalikan ke state awal
        emit(AuthInitial());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "An unknown error occurred"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading()); // Biar kerasa proses logoutnya
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      emit(AuthInitial()); // Kembali ke login page
    } catch (e) {
      emit(AuthError("Gagal logout: ${e.toString()}"));
    }
  }
}
