import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennis_santa_rosa/modules/jogador/_model/usuario_model.dart';
import 'package:tennis_santa_rosa/modules/ranking/_models/desafio_model.dart';

class CardDesafioComponent extends StatelessWidget {
  final DesafioModel desafio;
  final UsuarioModel desafiante;
  final UsuarioModel desafiado;
  const CardDesafioComponent({
    super.key,
    required this.desafio,
    required this.desafiante,
    required this.desafiado,
  });

  @override
  Widget build(BuildContext context) {
    String capitalize(String word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }

    String formatDate(DateTime date) {
      return DateFormat(
        "EEE dd 'de' MMM",
        'pt_BR',
      )
          .format(date)
          .split(' ')
          .map(
            (word) => word == 'de' ? word : capitalize(word),
          )
          .join(' ');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (desafio.status == StatusDesafio.pendente)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Data Desafio: ${formatDate(desafio.data)}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Vence: ${formatDate(
                        desafio.data.add(const Duration(days: 8)),
                      )}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            if (desafio.status == StatusDesafio.finalizado)
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Jogado: ${DateFormat(
                    "EEE dd 'de' MMM",
                    'pt_BR',
                  ).format(
                        desafio.dataJogo!,
                      ).split(' ').map(
                        (word) => word == 'de' ? word : capitalize(word),
                      ).join(' ')}',
                  textAlign: TextAlign.right,
                ),
              ),

            // DESAFIANTE
            _buildDesafioResultado(
              desafio: desafio,
              jogador: desafiante,
              context: context,
              isDesafiante: true,
            ),
            const SizedBox(height: 8),
            // DESAFIADO
            _buildDesafioResultado(
              desafio: desafio,
              jogador: desafiado,
              context: context,
              isDesafiante: false,
            ),
            const SizedBox(height: 8),
            Text('Status: ${desafio.status.name}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDesafioResultado({
    required DesafioModel desafio,
    required UsuarioModel jogador,
    required BuildContext context,
    required bool isDesafiante,
  }) {
    return Row(
      children: [
        CircleAvatar(
          foregroundImage:
              jogador.urlImage != null ? NetworkImage(jogador.urlImage!) : null,
          backgroundColor: Colors.grey,
          child: Text(jogador.nome![0]),
        ),
        const SizedBox(width: 8),
        Text(
          jogador.nome!,
          style: desafio.idUsuarioVencedor == jogador.uid
              ? Theme.of(context).textTheme.titleMedium
              : Theme.of(context).textTheme.bodyMedium,
        ),
        if (desafio.idUsuarioVencedor == jogador.uid)
          const Icon(Icons.check, color: Colors.green),
        const Spacer(),
        if (desafio.status == StatusDesafio.finalizado)
          Row(
            children: [
              Text(
                isDesafiante
                    ? '${desafio.game1Desafiante}'
                    : '${desafio.game1Desafiado}',
                style: desafio.game1Desafiante! > desafio.game1Desafiado!
                    ? isDesafiante
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodyMedium
                    : isDesafiante
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              Text(
                isDesafiante
                    ? '${desafio.game2Desafiante}'
                    : '${desafio.game2Desafiado}',
                style: desafio.game2Desafiante! > desafio.game2Desafiado!
                    ? isDesafiante
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodyMedium
                    : isDesafiante
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 16),
              if (desafio.tieBreakDesafiado != null &&
                  desafio.tieBreakDesafiante != null)
                Text(
                  isDesafiante
                      ? 'T${desafio.tieBreakDesafiante}'
                      : 'T${desafio.tieBreakDesafiado}',
                  style:
                      desafio.tieBreakDesafiante! > desafio.tieBreakDesafiado!
                          ? isDesafiante
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context).textTheme.bodyMedium
                          : isDesafiante
                              ? Theme.of(context).textTheme.bodyMedium
                              : Theme.of(context).textTheme.titleMedium,
                ),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
