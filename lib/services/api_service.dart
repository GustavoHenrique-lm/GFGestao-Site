import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5092/api';

  static Future<List<dynamic>> buscarTarefas() async {
  final token = await SessionService.obterToken();

  final response = await http.get(
    Uri.parse('$baseUrl/tarefas'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Erro ao buscar tarefas: ${response.statusCode}',
      );
    }
  }
  static Future<Map<String, dynamic>> atualizarTarefa(
  Map<String, dynamic> tarefa,
) async {
  final id = tarefa['id'];
  final token = await SessionService.obterToken();

  final response = await http.put(
    Uri.parse('$baseUrl/tarefas/$id'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'id': tarefa['id'],
      'titulo': tarefa['titulo'],
      'descricao': tarefa['descricao'],
      'tipo': tarefa['tipo'],
      'responsavel': tarefa['responsavel'],
      'data': tarefa['data'],
      'status': tarefa['status'],
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
      'Erro ao atualizar tarefa: ${response.statusCode}',
    );
  }
}
  static Future<Map<String, dynamic>> criarTarefa(
  Map<String, dynamic> tarefa,
) async {
  final token = await SessionService.obterToken();


  final response = await http.post(
    Uri.parse('$baseUrl/tarefas'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'titulo': tarefa['titulo'],
      'descricao': tarefa['descricao'],
      'tipo': tarefa['tipo'],
      'responsavel': tarefa['responsavel'],
      'data': tarefa['data'],
      'status': tarefa['status'],
    }),
  );

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception(
      'Erro ao criar tarefa: ${response.statusCode}',
    );
  }
    }

  static Future<void> excluirTarefa(int id) async {
    final token = await SessionService.obterToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/tarefas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception(
        'Erro ao excluir tarefa: ${response.statusCode}',
      );
    }
  }
  static Future<Map<String, dynamic>> fazerLogin(
  String email,
  String senha,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/usuarios/login'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode({
      'email': email,
      'senha': senha,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 401) {
    throw Exception('Email ou senha inválidos.');
  } else {
    throw Exception(
      'Erro ao fazer login: ${response.statusCode}',
    );
  }
}
  static Future<Map<String, dynamic>> cadastrarUsuario(
  String nome,
  String email,
  String senha,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/usuarios'),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode({
      'nome': nome,
      'email': email,
      'senha': senha,
      'perfil': 'Usuario',
    }),
  );

  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    throw Exception('Não foi possível cadastrar o usuário.');
  } else {
    throw Exception(
      'Erro ao cadastrar usuário: ${response.statusCode}',
    );
  }
}
}


