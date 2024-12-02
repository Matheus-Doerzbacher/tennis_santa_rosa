import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

class UpsertUsuarioPage extends StatefulWidget {
  const UpsertUsuarioPage({super.key});

  @override
  State<UpsertUsuarioPage> createState() => _UpsertUsuarioPageState();
}

class _UpsertUsuarioPageState extends State<UpsertUsuarioPage> {
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
              onPressed: () => Modular.to.navigate('/'),
              child: const Text('Voltar ao Início'),
            ),
            FilledButton(
              onPressed: () async {
                final whatsappUrl =
                    'https://wa.me/?text=Login: $login\nSenha: $senha';
                final uri = Uri.parse(whatsappUrl);

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                  Modular.to.navigate('/');
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

  @override
  Widget build(BuildContext context) {
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

                  if (value.length < 3) {
                    return 'Nome deve ter mais de 3 caracteres';
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showPlayerInfoModal(
                      context,
                      _loginController.text,
                      _senhaController.text,
                    );
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
}
