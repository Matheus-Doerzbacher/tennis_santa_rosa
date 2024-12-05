import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/core/utils/db_print.dart';
import 'package:tennis_santa_rosa/modules/auth/controller/auth_controller.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';

class DetalhesIniciaisPage extends StatefulWidget {
  const DetalhesIniciaisPage({super.key});

  @override
  State<DetalhesIniciaisPage> createState() => _DetalhesIniciaisPageState();
}

class _DetalhesIniciaisPageState extends State<DetalhesIniciaisPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senha1Controller = TextEditingController();
  final _senha2Controller = TextEditingController();

  bool _isPassword1Visible = false;
  bool _isPassword2Visible = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _senha1Controller.dispose();
    _senha2Controller.dispose();
    super.dispose();
  }

  Future<void> onSubmit() async {
    try {
      if (_formKey.currentState!.validate()) {
        final controller = Modular.get<AuthController>();

        final usuario = UsuarioModel(
          uid: controller.usuario?.uid,
          nome: _nomeController.text,
          telefone: _telefoneController.text,
          senha: _senha1Controller.text,
          login: controller.usuario?.login ?? '',
          posicaoRankingAtual: controller.usuario?.posicaoRankingAtual ?? 0,
        );

        await controller.updateUsuario(usuario);

        Modular.to.navigate('/');
      }
    } catch (e) {
      dbPrint(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar usuário: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controller = context.read<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes Iniciais'),
        leading: IconButton(
          onPressed: () {
            Modular.get<AuthController>().logout();
            Modular.to.navigate('../login/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Por favor complete os seguintes dados para continuar',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: 24),
                  // NOME
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      label: Text('Nome'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório';
                      }

                      if (value.length <= 3) {
                        return 'Nome deve ter mais de 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  // TELEFONE
                  TextFormField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(
                      label: Text('Telefone'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Telefone é obrigatório';
                      }

                      if (value.length < 10) {
                        return 'Telefone deve ter pelo menos 10 caracteres';
                      }
                      return null;
                    },
                  ),
                  // SENHA1
                  TextFormField(
                    controller: _senha1Controller,
                    decoration: InputDecoration(
                      label: const Text('Senha'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPassword1Visible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPassword1Visible = !_isPassword1Visible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPassword1Visible,
                    validator: (value) {
                      if (value != null) {
                        if (value.length <= 3) {
                          return 'Senha deve ter mais de 3 caracteres';
                        }

                        if (value != _senha2Controller.text) {
                          return 'Senhas não conferem';
                        }
                        return null;
                      }
                      return null;
                    },
                  ),
                  // SENHA2
                  TextFormField(
                    controller: _senha2Controller,
                    decoration: InputDecoration(
                      label: const Text('Confirmar Senha'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPassword2Visible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPassword2Visible = !_isPassword2Visible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPassword2Visible,
                    validator: (value) {
                      if (value != null) {
                        if (value != _senha1Controller.text) {
                          return 'Senhas não conferem';
                        }
                        return null;
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onSubmit,
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
