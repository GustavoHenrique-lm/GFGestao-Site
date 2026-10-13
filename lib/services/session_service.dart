import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String chaveLogado = 'usuario_logado';
  static const String chaveId = 'usuario_id';
  static const String chaveNome = 'usuario_nome';
  static const String chaveEmail = 'usuario_email';
  static const String chavePerfil = 'usuario_perfil';
  static const String chaveToken = 'usuario_token';

  static Future<void> salvarUsuario(
    Map<String, dynamic> usuario,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(chaveLogado, true);
    await prefs.setInt(chaveId, usuario['id']);
    await prefs.setString(chaveNome, usuario['nome']);
    await prefs.setString(chaveEmail, usuario['email']);
    await prefs.setString(chavePerfil, usuario['perfil']);
    await prefs.setString(chaveToken, usuario['token']);
  }
  static Future<Map<String, dynamic>?> obterUsuario() async {
  final prefs = await SharedPreferences.getInstance();

  final logado = prefs.getBool(chaveLogado) ?? false;

  if (!logado) {
    return null;
  }

  return {
    'id': prefs.getInt(chaveId),
    'nome': prefs.getString(chaveNome),
    'email': prefs.getString(chaveEmail),
    'perfil': prefs.getString(chavePerfil),
  };
}

static Future<String?> obterToken() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString(chaveToken);
}

static Future<void> encerrarSessao() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove(chaveLogado);
  await prefs.remove(chaveId);
  await prefs.remove(chaveNome);
  await prefs.remove(chaveEmail);
  await prefs.remove(chavePerfil);
  await prefs.remove(chaveToken);
}
}