import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/usuario/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/usuario/controller/usuario_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AddUsuarioPage extends StatefulWidget {
  const AddUsuarioPage({super.key});

  @override
  State<AddUsuarioPage> createState() => _AddUsuarioPageState();
}

class _AddUsuarioPageState extends State<AddUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();

  void gerarSenha() {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = StringBuffer();

    for (var i = 0; i < 6; i++) {
      final randomIndex = random.nextInt(availableChars.codeUnits.length);
      randomString.write(availableChars[randomIndex]);
    }

    setState(() {
      _senhaController.text = randomString.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UsuarioController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Jogador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NOME
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (value.length <= 2) {
                    return 'Nome deve ter mais de 2 caracteres';
                  }

                  if (controller.usuarios.any(
                    (u) => u?.login.toLowerCase() == value.toLowerCase(),
                  )) {
                    return 'Login já existe';
                  }
                  return null;
                },
              ),
              // SENHA
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _senhaController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Senha é obrigatória';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: gerarSenha,
                    child: const Text('Gerar senha'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final usuario = UsuarioModel(
                      login: _loginController.text,
                      senha: _senhaController.text,
                      posicaoRankingAtual: controller.usuarios.length + 1,
                      posicaoRankingAnterior: controller.usuarios.length + 1,
                    );
                    final success = await controller.addUsuario(usuario);

                    if (success && context.mounted) {
                      _showPlayerInfoModal(
                        context,
                        _loginController.text,
                        _senhaController.text,
                      );
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao criar jogador'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Salvar novo Jogador'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlayerInfoModal(BuildContext context, String login, String senha) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Jogador criado com sucesso',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Login: $login'),
              Text('Senha: $senha'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => {
                Modular.to.pop(),
                Modular.to.pop(),
              },
              child: const Text('Voltar ao Início'),
            ),
            FilledButton(
              onPressed: () async {
                final whatsappUrl =
                    'https://wa.me/?text=Login: $login\nSenha: $senha';
                final uri = Uri.parse(whatsappUrl);

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                  Modular.to.pop();
                  Modular.to.pop();
                } else {
                  throw Exception('Could not launch $whatsappUrl');
                }
              },
              child: const Text('Enviar pelo WhatsApp'),
            ),
          ],
        );
      },
    );
  }
}
