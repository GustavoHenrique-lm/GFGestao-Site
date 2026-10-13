import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/session_service.dart';
import 'screens/cadastro_screen.dart';

void main() {

  runApp(const GFGestaoApp());

}

// ============================================================
// APLICAÇÃO
// ============================================================

class GFGestaoApp extends StatefulWidget {
  const GFGestaoApp({super.key});

  @override
  State<GFGestaoApp> createState() => _GFGestaoAppState();
}

class _GFGestaoAppState extends State<GFGestaoApp> {
  Map<String, dynamic>? usuario;
  bool verificandoSessao = true;
  
  @override
  void initState() {
    super.initState();
    verificarSessao();
}

  Future<void> verificarSessao() async {
    final usuarioSalvo = await SessionService.obterUsuario();

  if (!mounted) return;

  setState(() {
  usuario = usuarioSalvo;
  verificandoSessao = false;
});
}
 
  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'GF Gestões',

      theme: ThemeData(

        useMaterial3: true,

        fontFamily: 'Arial',

        colorScheme: ColorScheme.fromSeed(

          seedColor: AppColors.roxoPrincipal,

        ),

      ),

      home: verificandoSessao
        ? const Scaffold(
           body: Center(
            child: CircularProgressIndicator(),
        ),
      )
    : usuario != null
        ? HomeScreen(
            usuario: usuario!,
          )
        : const LoginScreen(),

    );

  }

}

// ============================================================

// CORES DA EMPRESA

// ============================================================

class AppColors {

  static const Color roxoPrincipal = Color(0xFF7B1FA2);

  static const Color roxoEscuro = Color(0xFF4A148C);

  static const Color roxoClaro = Color(0xFFF7F2F8);

  static const Color roxoMuitoClaro = Color(0xFFE9D7EF);

}

// ============================================================

// LOGIN

// ============================================================

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override

  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  bool esconderSenha = true;

  Future<void> entrar() async {

    final email = emailController.text.trim();

    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: const Text(

            'Preencha o e-mail e a senha.',

          ),

          backgroundColor: AppColors.roxoEscuro,

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(12),

          ),

        ),

      );

      return;

    }

    try {
  final usuario = await ApiService.fazerLogin(
    email,
    senha,
  );

  await SessionService.salvarUsuario(usuario);

  if (!context.mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
     builder: (context) => HomeScreen(
      usuario: usuario,
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Bem-vindo, ${usuario['nome']}!',
      ),
      backgroundColor: AppColors.roxoEscuro,
    ),
  );
} catch (e) {
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        e.toString().replaceFirst('Exception: ', ''),
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

  }

  @override

  void dispose() {

    emailController.dispose();

    senhaController.dispose();

    super.dispose();

  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: SafeArea(

        child: SingleChildScrollView(

          child: Center(

            child: Padding(

              padding: const EdgeInsets.symmetric(

                horizontal: 28,

                vertical: 30,

              ),

              child: ConstrainedBox(

                constraints: const BoxConstraints(

                  maxWidth: 420,

                ),

                child: Column(

                  children: [

                    const SizedBox(height: 20),

                    // LOGO

                    Image.asset(

                      'assets/logo.png',

                      width: 230,

                      fit: BoxFit.contain,

                    ),

                    const SizedBox(height: 8),

                    // NOME DA EMPRESA

                    const Text(

                      'GF GESTÕES',

                      style: TextStyle(

                        fontSize: 26,

                        fontWeight: FontWeight.bold,

                        color: AppColors.roxoEscuro,

                        letterSpacing: 1.2,

                      ),

                    ),

                    const SizedBox(height: 4),

                    const Text(

                      'Gestão empresarial integrada',

                      style: TextStyle(

                        fontSize: 14,

                        color: Colors.grey,

                      ),

                    ),

                    const SizedBox(height: 28),

                    const Text(

                      'Bem-vindo!',

                      style: TextStyle(

                        fontSize: 28,

                        fontWeight: FontWeight.bold,

                        color: AppColors.roxoEscuro,

                      ),

                    ),

                    const SizedBox(height: 8),

                    const Text(

                      'Acesse sua plataforma corporativa',

                      textAlign: TextAlign.center,

                      style: TextStyle(

                        fontSize: 15,

                        color: Colors.grey,

                      ),

                    ),

                    const SizedBox(height: 35),

                    // E-MAIL

                    TextField(

                      controller: emailController,

                      keyboardType: TextInputType.emailAddress,

                      decoration: InputDecoration(

                        labelText: 'E-mail',

                        hintText: 'Digite seu e-mail',

                        prefixIcon: const Icon(

                          Icons.email_outlined,

                          color: AppColors.roxoPrincipal,

                        ),

                        filled: true,

                        fillColor: AppColors.roxoClaro,

                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide.none,

                        ),

                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide.none,

                        ),

                        focusedBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(18),

                          borderSide: const BorderSide(

                            color: AppColors.roxoPrincipal,

                            width: 2,

                          ),

                        ),

                      ),

                    ),

                    const SizedBox(height: 18),

                    // SENHA

                    TextField(

                      controller: senhaController,

                      obscureText: esconderSenha,

                      decoration: InputDecoration(

                        labelText: 'Senha',

                        hintText: 'Digite sua senha',

                        prefixIcon: const Icon(

                          Icons.lock_outline,

                          color: AppColors.roxoPrincipal,

                        ),

                        suffixIcon: IconButton(

                          icon: Icon(

                            esconderSenha

                                ? Icons.visibility_outlined

                                : Icons.visibility_off_outlined,

                            color: AppColors.roxoPrincipal,

                          ),

                          onPressed: () {

                            setState(() {

                              esconderSenha = !esconderSenha;

                            });

                          },

                        ),

                        filled: true,

                        fillColor: AppColors.roxoClaro,

                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide.none,

                        ),

                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(18),

                          borderSide: BorderSide.none,

                        ),

                        focusedBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(18),

                          borderSide: const BorderSide(

                            color: AppColors.roxoPrincipal,

                            width: 2,

                          ),

                        ),

                      ),

                    ),

                    const SizedBox(height: 12),

                    // ESQUECI SENHA

                    Align(

                      alignment: Alignment.centerRight,

                      child: TextButton(

                        onPressed: () {},

                        child: const Text(

                          'Esqueci minha senha',

                          style: TextStyle(

                            color: AppColors.roxoPrincipal,

                            fontWeight: FontWeight.w600,

                          ),

                        ),

                      ),

                    ),

                    const SizedBox(height: 15),

                    // BOTÃO ENTRAR

                    SizedBox(

                      width: double.infinity,

                      height: 54,

                      child: ElevatedButton(

                        onPressed: entrar,

                        style: ElevatedButton.styleFrom(

                          backgroundColor:

                          AppColors.roxoPrincipal,

                          foregroundColor: Colors.white,

                          elevation: 3,

                          shape: RoundedRectangleBorder(

                            borderRadius:

                            BorderRadius.circular(18),

                          ),

                        ),

                        child: const Text(

                          'ENTRAR',

                          style: TextStyle(

                            fontSize: 16,

                            fontWeight: FontWeight.bold,

                            letterSpacing: 0.5,

                          ),

                        ),

                      ),

                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CadastroScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.roxoPrincipal,
                          side: BorderSide(
                            color: AppColors.roxoPrincipal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'CRIAR CONTA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(

                      'GF Gestões',

                      style: TextStyle(

                        fontSize: 13,

                        fontWeight: FontWeight.bold,

                        color: AppColors.roxoEscuro,

                      ),

                    ),

                    const SizedBox(height: 4),

                    const Text(

                      'Plataforma Corporativa',

                      style: TextStyle(

                        fontSize: 12,

                        color: Colors.grey,

                      ),

                    ),

                    const SizedBox(height: 20),

                  ],

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}

// ============================================================

// HOME / NAVEGAÇÃO

// ============================================================

  class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const HomeScreen({
    super.key,
    required this.usuario,
  });
  
  @override

  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  int paginaAtual = 0;
  
  List<Map<String, dynamic>> tarefas = [];

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
  try {
    final dados = await ApiService.buscarTarefas();

    if (!mounted) return;

    setState(() {
      tarefas = dados
          .map<Map<String, dynamic>>(
            (tarefa) => Map<String, dynamic>.from(tarefa),
          )
          .toList();
    });
  } catch (e) {
    // Se ocorrer algum erro, mantém a lista vazia.
  }
}

  List<Widget> get paginas => [
    DashboardPage(
      usuario: widget.usuario,
      tarefas: tarefas,
    ),
    const TarefasPage(),
    PerfilPage(
      usuario: widget.usuario,
  ),
];

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: paginas[paginaAtual],

      bottomNavigationBar: NavigationBar(

        selectedIndex: paginaAtual,

        
        onDestinationSelected: (index) {
          setState(() {
            paginaAtual = index;
          });

          if (index == 0) {
            carregarTarefas();
          }
        },

        backgroundColor: AppColors.roxoClaro,

        indicatorColor: AppColors.roxoMuitoClaro,

        destinations: const [

          NavigationDestination(

            icon: Icon(Icons.home_outlined),

            selectedIcon: Icon(

              Icons.home,

              color: AppColors.roxoPrincipal,

            ),

            label: 'Início',

          ),

          NavigationDestination(

            icon: Icon(Icons.view_kanban_outlined),

            selectedIcon: Icon(

              Icons.view_kanban,

              color: AppColors.roxoPrincipal,

            ),

            label: 'Tarefas',

          ),

          NavigationDestination(

            icon: Icon(Icons.person_outline),

            selectedIcon: Icon(

              Icons.person,

              color: AppColors.roxoPrincipal,

            ),

            label: 'Perfil',

          ),

        ],

      ),

    );

  }

}

// ============================================================

// DASHBOARD

// ============================================================

IconData iconePorTipo(String tipo) {
  switch (tipo) {
    case 'Backlog':
      return Icons.description_outlined;

    case 'Sprint':
      return Icons.groups_outlined;

    case 'Daily':
      return Icons.groups_outlined;

    default:
      return Icons.task_alt_outlined;
  }
}

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> usuario;
  final List<Map<String, dynamic>> tarefas;

  const DashboardPage({
  super.key,
  required this.usuario,
  required this.tarefas,
});

  @override

  Widget build(BuildContext context) {

    return SafeArea(

      child: SingleChildScrollView(

        padding: const EdgeInsets.all(22),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 10),

            // CABEÇALHO

            Row(

              mainAxisAlignment:

              MainAxisAlignment.spaceBetween,

              children: [

               Column(

                  crossAxisAlignment:

                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      'Olá, ${usuario['nome']}! 👋',

                      style: TextStyle(

                        fontSize: 24,

                        fontWeight: FontWeight.bold,

                        color: AppColors.roxoEscuro,

                      ),

                    ),

                    SizedBox(height: 5),

                    Text(

                      'Bem-vindo à GF Gestões',

                      style: TextStyle(

                        color: Colors.grey,

                        fontSize: 14,

                      ),

                    ),

                  ],

                ),

                CircleAvatar(

                  radius: 25,

                  backgroundColor:

                  AppColors.roxoMuitoClaro,

                  child: Icon(

                    Icons.person,

                    color: AppColors.roxoPrincipal,

                  ),

                ),

              ],

            ),

            const SizedBox(height: 30),

            const Text(

              'Resumo da Sprint',

              style: TextStyle(

                fontSize: 20,

                fontWeight: FontWeight.bold,

                color: AppColors.roxoEscuro,

              ),

            ),

            const SizedBox(height: 15),

            Row(

              children: [

                Expanded(

                  child: InfoCard(

                    titulo: 'Atividades',

                    valor: tarefas.length.toString(),

                    icone:Icons.assignment_outlined,
                  ),

                ),

                const SizedBox(width: 14),

                Expanded(

                  child: InfoCard(

                    titulo: 'Concluídas',

                    valor: tarefas
                      .where((tarefa) => tarefa['status'] == 'Concluída')
                      .length
                      .toString(),

                    icone:Icons.check_circle_outline,
                  ),

                ),

              ],

            ),

            const SizedBox(height: 14),

            Row(

              children: [

                Expanded(

                  child: InfoCard(

                    titulo: 'Em andamento',

                    valor: tarefas
                      .where((tarefa) => tarefa['status'] == 'Em andamento')
                      .length
                      .toString(),

                    icone:Icons.pending_actions_outlined,
                  ),

                ),

                const SizedBox(width: 14),

                Expanded(

                  child: InfoCard(

                    titulo: 'Pendentes',

                    valor: tarefas
                      .where((tarefa) => tarefa['status'] == 'Pendente')
                      .length
                      .toString(),

                    icone:Icons.hourglass_empty,
                  ),

                ),

              ],

            ),

            const SizedBox(height: 30),

            const Text(

              'Atividades da Sprint',

              style: TextStyle(

                fontSize: 20,

                fontWeight: FontWeight.bold,

                color: AppColors.roxoEscuro,

              ),

            ),

            const SizedBox(height: 15),

            ...tarefas.take(4).map(
              (tarefa) => ActivityCard(
                titulo: tarefa['titulo'],
                status: tarefa['status'],
                icone: iconePorTipo(tarefa['tipo']),
              ),
            ),
          ],

        ),

      ),

    );

  }

}

// ============================================================

// CARD DE INFORMAÇÃO

// ============================================================

class InfoCard extends StatelessWidget {

  final String titulo;

  final String valor;

  final IconData icone;

  const InfoCard({

    super.key,

    required this.titulo,

    required this.valor,

    required this.icone,

  });

  @override

  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: AppColors.roxoClaro,

        borderRadius:

        BorderRadius.circular(20),

        border: Border.all(

          color: AppColors.roxoMuitoClaro,

        ),

      ),

      child: Column(

        crossAxisAlignment:

        CrossAxisAlignment.start,

        children: [

          Icon(

            icone,

            color: AppColors.roxoPrincipal,

            size: 30,

          ),

          const SizedBox(height: 12),

          Text(

            valor,

            style: const TextStyle(

              fontSize: 27,

              fontWeight: FontWeight.bold,

              color: AppColors.roxoEscuro,

            ),

          ),

          Text(

            titulo,

            style: const TextStyle(

              color: Colors.grey,

              fontSize: 13,

            ),

          ),

        ],

      ),

    );

  }

}

// ============================================================

// CARD DE ATIVIDADE

// ============================================================

class ActivityCard extends StatelessWidget {

  final String titulo;

  final String status;

  final IconData icone;

  const ActivityCard({

    super.key,

    required this.titulo,

    required this.status,

    required this.icone,

  });

  Color corStatus() {

    switch (status) {

      case 'Concluída':

        return Colors.green;

      case 'Em andamento':

        return AppColors.roxoPrincipal;

      default:

        return Colors.orange;

    }

  }

  @override

  Widget build(BuildContext context) {

    final cor = corStatus();

    return Container(

      margin:

      const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:

        BorderRadius.circular(18),

        border: Border.all(

          color: AppColors.roxoMuitoClaro,

        ),

      ),

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(

              color: AppColors.roxoClaro,

              borderRadius:

              BorderRadius.circular(12),

            ),

            child: Icon(

              icone,

              color: AppColors.roxoPrincipal,

            ),

          ),

          const SizedBox(width: 14),

          Expanded(

            child: Column(

              crossAxisAlignment:

              CrossAxisAlignment.start,

              children: [

                Text(

                  titulo,

                  style: const TextStyle(

                    fontWeight:

                    FontWeight.bold,

                    fontSize: 15,

                  ),

                ),

                const SizedBox(height: 4),

                Text(

                  status,

                  style: TextStyle(

                    color: cor,

                    fontSize: 13,

                    fontWeight:

                    FontWeight.w600,

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }

}

// ============================================================

// GESTÃO DE TAREFAS / SCRUM

// ============================================================

class TarefasPage extends StatefulWidget {

  const TarefasPage({super.key});

  @override

  State<TarefasPage> createState() =>

      _TarefasPageState();

}

class _TarefasPageState

    extends State<TarefasPage> {

  String filtroAtual = 'Todas';

  List<Map<String, dynamic>> tarefas = [];

  bool carregando = true;

  String? erro;

  @override

  void initState() {

  super.initState();

  carregarTarefas();

}

Future<void> carregarTarefas() async {

  try {

    final dados = await ApiService.buscarTarefas();

    setState(() {

      tarefas = dados.map<Map<String, dynamic>>((tarefa) {

        return {

          'id': tarefa['id'],

          'titulo': tarefa['titulo'],

          'descricao': tarefa['descricao'],

          'tipo': tarefa['tipo'],

          'responsavel': tarefa['responsavel'],

          'data': tarefa['data'],

          'status': tarefa['status'],

          'icone': iconePorTipo(tarefa['tipo']),

        };

      }).toList();

      carregando = false;

    });

  } catch (e) {

    setState(() {

      erro = e.toString();

      carregando = false;

    });

  }

}

IconData iconePorTipo(String tipo) {

  switch (tipo) {

    case 'Backlog':

      return Icons.description_outlined;

    case 'Sprint':

      return Icons.groups_outlined;

    case 'Daily':

      return Icons.groups_outlined;

    default:

      return Icons.task_alt_outlined;

  }

}

  Color corStatus(String status) {

    switch (status) {

      case 'Concluída':

        return Colors.green;

      case 'Em andamento':

        return AppColors.roxoPrincipal;

      case 'Pendente':

        return Colors.orange;

      default:

        return Colors.grey;

    }

  }

  List<Map<String, dynamic>>

  get tarefasFiltradas {

    if (filtroAtual == 'Todas') {

      return tarefas;

    }

    return tarefas

        .where(

          (tarefa) =>

      tarefa['status'] ==

          filtroAtual,

    )

        .toList();

  }

  void abrirDetalhes(

      Map<String, dynamic> tarefa) {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.white,

      shape:

      const RoundedRectangleBorder(

        borderRadius:

        BorderRadius.vertical(

          top: Radius.circular(28),

        ),

      ),

      builder: (context) {

        return Padding(

          padding:

          const EdgeInsets.fromLTRB(

            24,

            20,

            24,

            30,

          ),

          child: Column(

            mainAxisSize:

            MainAxisSize.min,

            crossAxisAlignment:

            CrossAxisAlignment.start,

            children: [

              Center(

                child: Container(

                  width: 45,

                  height: 5,

                  decoration:

                  BoxDecoration(

                    color:

                    Colors.grey.shade300,

                    borderRadius:

                    BorderRadius.circular(

                      10,

                    ),

                  ),

                ),

              ),

              const SizedBox(height: 25),

              Row(

                children: [

                  Container(

                    padding:

                    const EdgeInsets.all(

                      14,

                    ),

                    decoration:

                    BoxDecoration(

                      color:

                      AppColors.roxoClaro,

                      borderRadius:

                      BorderRadius.circular(

                        15,

                      ),

                    ),

                    child: Icon(

                      tarefa['icone'],

                      color:

                      AppColors.roxoPrincipal,

                      size: 28,

                    ),

                  ),

                  const SizedBox(width: 15),

                  Expanded(

                    child: Text(

                      tarefa['titulo'],

                      style:

                      const TextStyle(

                        fontSize: 20,

                        fontWeight:

                        FontWeight.bold,

                        color:

                        AppColors.roxoEscuro,

                      ),

                    ),

                  ),

                ],

              ),

              const SizedBox(height: 25),

              const Text(

                'Descrição',

                style: TextStyle(

                  fontSize: 14,

                  fontWeight:

                  FontWeight.bold,

                  color: Colors.grey,

                ),

              ),

              const SizedBox(height: 7),

              Text(

                tarefa['descricao'],

                style:

                const TextStyle(

                  fontSize: 16,

                  height: 1.4,

                ),

              ),

              const SizedBox(height: 20),

              _detalhe(

                Icons.person_outline,

                'Responsável',

                tarefa['responsavel'],

              ),

              const SizedBox(height: 12),

              _detalhe(

                Icons.calendar_today_outlined,

                'Data',

                tarefa['data'],

              ),

              const SizedBox(height: 12),

              _detalhe(

                Icons.label_outline,

                'Tipo',

                tarefa['tipo'],

              ),

              const SizedBox(height: 12),

              _detalhe(

                Icons.info_outline,

                'Status',

                tarefa['status'],

              ),

              const SizedBox(height: 25),

              SizedBox(

                width: double.infinity,

                height: 50,

                child:

                ElevatedButton(

                  onPressed: () async {

                    final indice = tarefas.indexOf(tarefa);

                    if (indice == -1) return;

                    final novoStatus = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text('Alterar status'),
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Pendente');
                              },
                              child: const Text('Pendente'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Em andamento');
                              },
                              child: const Text('Em andamento'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Concluída');
                              },
                              child: const Text('Concluída'),
                            ),
                          ],
                        );
                      },
                    );

                    if (novoStatus == null) return;

                    final tarefaAtualizada =

                        Map<String, dynamic>.from(tarefas[indice]);

                    tarefaAtualizada['status'] = novoStatus;

                    try {

                      final resultado =

                          await ApiService.atualizarTarefa(

                        tarefaAtualizada,

                      );

                      if (!context.mounted) return;

                      setState(() {

                        tarefas[indice]['status'] =

                            resultado['status'];

                      });

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(

                        SnackBar(

                          content: Text(

                            'Status alterado para ${resultado['status']}',

                          ),

                        ),

                      );

                    } catch (e) {

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(

                        SnackBar(

                          content: Text(

                            'Erro ao atualizar tarefa: $e',

                          ),

                        ),

                      );

                    }

                  },

                  style:

                  ElevatedButton.styleFrom(

                    backgroundColor:

                    AppColors

                        .roxoPrincipal,

                    foregroundColor:

                    Colors.white,

                    shape:

                    RoundedRectangleBorder(

                      borderRadius:

                      BorderRadius.circular(

                        16,

                      ),

                    ),

                  ),

                  child:

                  const Text(

                    'Alterar status',

                    style: TextStyle(

                      fontWeight:

                      FontWeight.bold,

                    ),

                  ),

                ),

              ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Excluir tarefa'),
                            content: const Text(
                              'Tem certeza que deseja excluir esta tarefa?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmar != true) return;

                      try {
                        await ApiService.excluirTarefa(
                          tarefa['id'],
                        );

                        if (!context.mounted) return;

                        setState(() {
                          tarefas.remove(tarefa);
                        });

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Tarefa excluída com sucesso!',
                            ),
                          ),
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Erro ao excluir tarefa: $e',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Excluir tarefa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],

          ),

        );

      },

    );

  }

  void abrirNovaTarefa() {

  final tituloController = TextEditingController();

  final descricaoController = TextEditingController();

  final responsavelController = TextEditingController();

  String tipoSelecionado = 'Backlog';

  String statusSelecionado = 'Pendente';

  showModalBottomSheet(

    context: context,

    isScrollControlled: true,

    backgroundColor: Colors.white,

    shape: const RoundedRectangleBorder(

      borderRadius: BorderRadius.vertical(

        top: Radius.circular(28),

      ),

    ),

    builder: (context) {

      return StatefulBuilder(

        builder: (context, setModalState) {

          return Padding(

            padding: EdgeInsets.fromLTRB(

              24,

              20,

              24,

              MediaQuery.of(context).viewInsets.bottom + 30,

            ),

            child: SingleChildScrollView(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Center(

                    child: Container(

                      width: 45,

                      height: 5,

                      decoration: BoxDecoration(

                        color: Colors.grey.shade300,

                        borderRadius: BorderRadius.circular(10),

                      ),

                    ),

                  ),

                  const SizedBox(height: 25),

                  const Text(

                    'Nova tarefa',

                    style: TextStyle(

                      fontSize: 24,

                      fontWeight: FontWeight.bold,

                      color: AppColors.roxoEscuro,

                    ),

                  ),

                  const SizedBox(height: 20),

                  TextField(

                    controller: tituloController,

                    decoration: InputDecoration(

                      labelText: 'Título',

                      prefixIcon: const Icon(Icons.title),

                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(14),

                      ),

                    ),

                  ),

                  const SizedBox(height: 15),

                  TextField(

                    controller: descricaoController,

                    maxLines: 3,

                    decoration: InputDecoration(

                      labelText: 'Descrição',

                      prefixIcon: const Icon(Icons.description_outlined),

                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(14),

                      ),

                    ),

                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(

                    value: tipoSelecionado,

                    decoration: InputDecoration(

                      labelText: 'Tipo',

                      prefixIcon: const Icon(Icons.label_outline),

                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(14),

                      ),

                    ),

                    items: const [

                      DropdownMenuItem(

                        value: 'Backlog',

                        child: Text('Backlog'),

                      ),

                      DropdownMenuItem(

                        value: 'Sprint',

                        child: Text('Sprint'),

                      ),

                      DropdownMenuItem(

                        value: 'Daily',

                        child: Text('Daily'),

                      ),

                    ],

                    onChanged: (valor) {

                      if (valor != null) {

                        setModalState(() {

                          tipoSelecionado = valor;

                        });

                      }

                    },

                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: statusSelecionado,

                    decoration: InputDecoration(
                      labelText: 'Status',
                      prefixIcon: const Icon(Icons.info_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'Pendente',
                        child: Text('Pendente'),
                      ),
                      DropdownMenuItem(
                        value: 'Em andamento',
                        child: Text('Em andamento'),
                      ),
                      DropdownMenuItem(
                        value: 'Concluída',
                        child: Text('Concluída'),
                      ),
                    ],

                    onChanged: (valor) {
                      if (valor != null) {
                        setModalState(() {
                          statusSelecionado = valor;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  TextField(

                    controller: responsavelController,

                    decoration: InputDecoration(

                      labelText: 'Responsável',

                      prefixIcon: const Icon(Icons.person_outline),

                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(14),

                      ),

                    ),

                  ),

                  const SizedBox(height: 25),

                  SizedBox(

                    width: double.infinity,

                    height: 50,

                    child: ElevatedButton(

                      onPressed: () async {

                        if (tituloController.text.trim().isEmpty ||

                            descricaoController.text.trim().isEmpty ||

                            responsavelController.text.trim().isEmpty) {

                          ScaffoldMessenger.of(context).showSnackBar(

                            const SnackBar(

                              content: Text(

                                'Preencha todos os campos.',

                              ),

                            ),

                          );

                          return;

                        }

                        final novaTarefa = {

                          'titulo': tituloController.text.trim(),

                          'descricao': descricaoController.text.trim(),

                          'tipo': tipoSelecionado,

                          'responsavel':responsavelController.text.trim(),

                          'data': DateTime.now().toIso8601String(),

                          'status': statusSelecionado,

                        };

                        try {

                          final resultado =

                              await ApiService.criarTarefa(novaTarefa);

                          if (!context.mounted) return;

                          setState(() {

                            tarefas.add({

                              'id': resultado['id'],

                              'titulo': resultado['titulo'],

                              'descricao': resultado['descricao'],

                              'tipo': resultado['tipo'],

                              'responsavel': resultado['responsavel'],

                              'data': resultado['data'],

                              'status': resultado['status'],

                              'icone': iconePorTipo(

                                resultado['tipo'],

                              ),

                            });

                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(

                            const SnackBar(

                              content: Text(

                                'Tarefa criada com sucesso!',

                              ),

                            ),

                          );

                        } catch (e) {

                          ScaffoldMessenger.of(context).showSnackBar(

                            SnackBar(

                              content: Text(

                                'Erro ao criar tarefa: $e',

                              ),

                            ),

                          );

                        }

                      },

                      style: ElevatedButton.styleFrom(

                        backgroundColor: AppColors.roxoPrincipal,

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(16),

                        ),

                      ),

                      child: const Text(

                        'Criar tarefa',

                        style: TextStyle(

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                    ),

                  ),

                ],

              ),

            ),

          );

        },

      );

    },

  );

}

  Widget _detalhe(

      IconData icone,

      String titulo,

      String valor,

      ) {

    return Row(

      children: [

        Icon(

          icone,

          color:

          AppColors.roxoPrincipal,

          size: 21,

        ),

        const SizedBox(width: 10),

        Text(

          '$titulo: ',

          style:

          const TextStyle(

            fontWeight:

            FontWeight.bold,

          ),

        ),

        Expanded(

          child: Text(

            valor,

            overflow:

            TextOverflow.ellipsis,

          ),

        ),

      ],

    );

  }

  Widget filtro(String nome) {

    final bool selecionado =

        filtroAtual == nome;

    return Padding(

      padding:

      const EdgeInsets.only(

        right: 8,

      ),

      child: ChoiceChip(

        label: Text(nome),

        selected:

        selecionado,

        onSelected: (_) {

          setState(() {

            filtroAtual =

                nome;

          });

        },

        selectedColor:

        AppColors.roxoMuitoClaro,

        labelStyle:

        TextStyle(

          color: selecionado

              ? AppColors.roxoEscuro

              : Colors.grey.shade700,

          fontWeight: selecionado

              ? FontWeight.bold

              : FontWeight.normal,

        ),

        side: BorderSide(

          color: selecionado

              ? AppColors.roxoMuitoClaro

              : Colors.grey.shade300,

        ),

      ),

    );

  }

  @override

  Widget build(

      BuildContext context) {

    final lista =

        tarefasFiltradas;

      return Scaffold(

        backgroundColor: Colors.white,

        floatingActionButton: FloatingActionButton(

          onPressed: abrirNovaTarefa,

          backgroundColor: AppColors.roxoPrincipal,

          foregroundColor: Colors.white,

          child: const Icon(Icons.add),

      ),

      body: SafeArea(

        child: Column(

          children: [

          // CABEÇALHO

          Padding(

            padding:

            const EdgeInsets.fromLTRB(

              22,

              20,

              22,

              10,

            ),

            child: Row(

              mainAxisAlignment:

              MainAxisAlignment

                  .spaceBetween,

              children: [

                const Column(

                  crossAxisAlignment:

                  CrossAxisAlignment

                      .start,

                  children: [

                    Text(

                      'Gestão de tarefas',

                      style:

                      TextStyle(

                        fontSize: 25,

                        fontWeight:

                        FontWeight.bold,

                        color:

                        AppColors

                            .roxoEscuro,

                      ),

                    ),

                    SizedBox(height: 5),

                    Text(

                      'Acompanhe o andamento da Sprint',

                      style:

                      TextStyle(

                        color: Colors.grey,

                        fontSize: 14,

                      ),

                    ),

                  ],

                ),

                Container(

                  padding:

                  const EdgeInsets.all(

                    12,

                  ),

                  decoration:

                  BoxDecoration(

                    color:

                    AppColors.roxoClaro,

                    borderRadius:

                    BorderRadius.circular(

                      15,

                    ),

                  ),

                  child: const Icon(

                    Icons

                        .view_kanban_outlined,

                    color:

                    AppColors

                        .roxoPrincipal,

                    size: 27,

                  ),

                ),

              ],

            ),

          ),

          // RESUMO DA SPRINT

          Padding(

            padding:

            const EdgeInsets.symmetric(

              horizontal: 22,

            ),

            child: Container(

              width: double.infinity,

              padding:

              const EdgeInsets.all(

                18,

              ),

              decoration:

              BoxDecoration(

                gradient:

                const LinearGradient(

                  colors: [

                    AppColors

                        .roxoPrincipal,

                    AppColors

                        .roxoEscuro,

                  ],

                ),

                borderRadius:

                BorderRadius.circular(

                  20,

                ),

              ),

              child: Row(

                children: [

                  const Icon(

                    Icons.speed_outlined,

                    color:

                    Colors.white,

                    size: 32,

                  ),

                  const SizedBox(

                    width: 15,

                  ),

                  Column(

                    crossAxisAlignment:

                    CrossAxisAlignment

                        .start,

                    children: [

                      const Text(

                        'Sprint atual',

                        style:

                        TextStyle(

                          color:

                          Colors.white70,

                          fontSize: 13,

                        ),

                      ),

                      Text(

                        '${tarefas.length} atividades',

                        style:

                        const TextStyle(

                          color:

                          Colors.white,

                          fontSize: 20,

                          fontWeight:

                          FontWeight.bold,

                        ),

                      ),

                    ],

                  ),

                ],

              ),

            ),

          ),

          const SizedBox(height: 18),

          // FILTROS

          SizedBox(

            height: 42,

            child: ListView(

              padding:

              const EdgeInsets.symmetric(

                horizontal: 22,

              ),

              scrollDirection:

              Axis.horizontal,

              children: [

                filtro('Todas'),

                filtro('Pendente'),

                filtro('Em andamento'),

                filtro('Concluída'),

              ],

            ),

          ),

          const SizedBox(height: 12),

          // LISTA

          Expanded(

           child: erro != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Não foi possível carregar as tarefas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton.icon(
                          onPressed: carregarTarefas,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Tentar novamente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.roxoPrincipal,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : lista.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma tarefa encontrada.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : ListView.builder(

              padding:

              const EdgeInsets

                  .symmetric(

                horizontal: 22,

              ),

              itemCount:

              lista.length,

              itemBuilder:

                  (context, index) {

                final tarefa =

                lista[index];

                final cor =

                corStatus(

                  tarefa['status'],

                );

                return GestureDetector(

                  onTap: () =>

                      abrirDetalhes(

                        tarefa,

                      ),

                  child:

                  Container(

                    margin:

                    const EdgeInsets

                        .only(

                      bottom: 14,

                    ),

                    padding:

                    const EdgeInsets

                        .all(

                      16,

                    ),

                    decoration:

                    BoxDecoration(

                      color:

                      Colors.white,

                      borderRadius:

                      BorderRadius

                          .circular(

                        20,

                      ),

                      border:

                      Border.all(

                        color: AppColors

                            .roxoMuitoClaro,

                      ),

                    ),

                    child: Row(

                      children: [

                        Container(

                          padding:

                          const EdgeInsets

                              .all(

                            12,

                          ),

                          decoration:

                          BoxDecoration(

                            color:

                            AppColors

                                .roxoClaro,

                            borderRadius:

                            BorderRadius

                                .circular(

                              15,

                            ),

                          ),

                          child: Icon(

                            tarefa[

                            'icone'],

                            color:

                            AppColors

                                .roxoPrincipal,

                          ),

                        ),

                        const SizedBox(

                          width: 14,

                        ),

                        Expanded(

                          child:

                          Column(

                            crossAxisAlignment:

                            CrossAxisAlignment

                                .start,

                            children: [

                              Text(

                                tarefa[

                                'titulo'],

                                style:

                                const TextStyle(

                                  fontSize:

                                  16,

                                  fontWeight:

                                  FontWeight

                                      .bold,

                                ),

                              ),

                              const SizedBox(

                                height: 5,

                              ),

                              Text(

                                tarefa[

                                'tipo'],

                                style:

                                const TextStyle(

                                  color:

                                  Colors.grey,

                                  fontSize:

                                  13,

                                ),

                              ),

                              const SizedBox(

                                height: 8,

                              ),

                              Row(

                                children: [

                                  Container(

                                    padding:

                                    const EdgeInsets

                                        .symmetric(

                                      horizontal:

                                      10,

                                      vertical:

                                      5,

                                    ),

                                    decoration:

                                    BoxDecoration(

                                      color: cor

                                          .withOpacity(

                                        0.1,

                                      ),

                                      borderRadius:

                                      BorderRadius

                                          .circular(

                                        20,

                                      ),

                                    ),

                                    child:

                                    Text(

                                      tarefa[

                                      'status'],

                                      style:

                                      TextStyle(

                                        color:

                                        cor,

                                        fontSize:

                                        12,

                                        fontWeight:

                                        FontWeight

                                            .bold,

                                      ),

                                    ),

                                  ),

                                  const SizedBox(

                                    width: 8,

                                  ),

                                  Flexible(

                                    child:

                                    Text(

                                      tarefa[

                                      'responsavel'],

                                      overflow:

                                      TextOverflow

                                          .ellipsis,

                                      style:

                                      const TextStyle(

                                        color:

                                        Colors.grey,

                                        fontSize:

                                        12,

                                      ),

                                    ),

                                  ),

                                ],

                              ),

                            ],

                          ),

                        ),

                        const Icon(

                          Icons

                              .chevron_right,

                          color:

                          Colors.grey,

                        ),

                      ],

                    ),

                  ),

                );

              },

            ),

          ),

        ],

      ),
      ),
    );
    
  }

}

// ============================================================

// PERFIL

// ============================================================

class PerfilPage extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const PerfilPage({
    super.key,
    required this.usuario,
  });

  @override

  Widget build(BuildContext context) {

    return SafeArea(

      child: Padding(

        padding: const EdgeInsets.all(22),

        child: Column(

          children: [

            const SizedBox(height: 20),

            const CircleAvatar(

              radius: 45,

              backgroundColor:

              AppColors.roxoMuitoClaro,

              child: Icon(

                Icons.person,

                size: 50,

                color:

                AppColors.roxoPrincipal,

              ),

            ),

            const SizedBox(height: 15),

              Text(
                usuario['nome'] ?? 'Usuário',

              style:

              TextStyle(

                fontSize: 24,

                fontWeight:

                FontWeight.bold,

                color:

                AppColors.roxoEscuro,

              ),

            ),

            const SizedBox(height: 5),

              Text(
                usuario['email'] ?? '',
              style:

              TextStyle(

                color: Colors.grey,

              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Perfil: ${usuario['perfil'] ?? 'Usuário'}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            _opcao(
              Icons.person_outline,
              'Dados pessoais',

            ),

            _opcao(
              Icons.notifications_outlined,
              'Notificações',
            ),

            _opcao(
              Icons.lock_outline,
              'Segurança',
            ),

            _opcao(
              Icons.settings_outlined,
              'Configurações',
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await SessionService.encerrarSessao();

                  if (!context.mounted) return;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Sair',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],

        ),

      ),

    );

  }

  Widget _opcao(

      IconData icone,

      String titulo,

      ) {

    return Container(

      margin:

      const EdgeInsets.only(

        bottom: 12,

      ),

      padding:

      const EdgeInsets.all(

        16,

      ),

      decoration:

      BoxDecoration(

        color: AppColors.roxoClaro,

        borderRadius:

        BorderRadius.circular(

          16,

        ),

      ),

      child: Row(

        children: [

          Icon(

            icone,

            color:

            AppColors.roxoPrincipal,

          ),

          const SizedBox(width: 15),

          Expanded(

            child: Text(

              titulo,

              style:

              const TextStyle(

                fontSize: 15,

                fontWeight:

                FontWeight.w600,

              ),

            ),

          ),

          const Icon(

            Icons.chevron_right,

            color: Colors.grey,

          ),

        ],

      ),

    );

  }

}