import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';

import 'package:gamecardlist/features/card_list/data/models/card_list_json_mapper.dart';
import 'package:gamecardlist/features/card_list/domain/entities/card_section.dart';
import 'package:gamecardlist/features/card_list/domain/entities/game_category.dart';

void main() {
  const mapper = CardListJsonMapper();

  test('ida e volta mantém título, cor, imagem local e menções honrosas', () {
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    final sections = [
      CardSection(
        title: 'Especificos',
        categories: [
          GameCategory(
            title: 'Best Game',
            image: 'assets/images/bestGame.png',
            color: const Color(0xFF673AB7),
            description: 'Seu jogo favorito',
            localImageBytes: bytes,
            honorGames: const [
              GameReference(title: 'Best Game', image: 'https://x.com/a.png'),
            ],
          ),
          GameCategory(
            title: 'Adicionar categoria',
            image: '',
            color: const Color(0xFF9E9E9E),
            description: '',
            cardType: GameCardType.addCategory,
          ),
        ],
      ),
    ];

    final decoded = mapper.decode(mapper.encode(sections), ['Especificos']);

    expect(decoded, hasLength(1));
    expect(decoded.first.title, 'Especificos');
    expect(decoded.first.categories, hasLength(1), reason: 'card de adicionar não é exportado');
    final c = decoded.first.categories.first;
    expect(c.title, 'Best Game');
    expect(c.color.toARGB32(), 0xFF673AB7);
    expect(c.localImageBytes, bytes);
    expect(c.baseImage, 'assets/images/bestGame.png');
    expect(c.honorGames.single.image, 'https://x.com/a.png');
  });

  test('lê backups antigos (sem cardType)', () {
    final json = jsonEncode([
      [
        {'title': 'Story', 'image': 'assets/images/story.png', 'color': '#2196f3'},
      ],
    ]);
    final decoded = mapper.decode(json, const []);
    expect(decoded.single.title, 'Seção 1');
    expect(decoded.single.categories.single.cardType, GameCardType.generic);
  });

  test('Free slot renomeado com imagem sobrevive à ida e volta como editável', () {
    final bytes = Uint8List.fromList([5, 6, 7]);
    final sections = [
      CardSection(
        title: 'Generos',
        categories: [
          GameCategory(
            title: 'Roguelike',
            image: 'assets/images/freeSlot.png',
            color: const Color(0xFF9E9E9E),
            description: 'Espaço livre',
            cardType: GameCardType.editableTitle,
            localImageBytes: bytes,
            honorGames: const [
              GameReference(title: 'Roguelike', image: 'https://x.com/b.png'),
            ],
          ),
          GameCategory(
            title: 'Adicionar categoria',
            image: 'assets/images/freeSlot.png',
            color: const Color(0xFF9E9E9E),
            description: '',
            cardType: GameCardType.addCategory,
          ),
        ],
      ),
    ];

    final decoded = mapper.decode(mapper.encode(sections), ['Generos']);

    expect(decoded, hasLength(1), reason: 'seção só com Free slot não some');
    final c = decoded.single.categories.single;
    expect(c.title, 'Roguelike');
    expect(c.cardType, GameCardType.editableTitle);
    expect(c.localImageBytes, bytes);
    expect(c.baseImage, 'assets/images/freeSlot.png');
    expect(c.honorGames.single.image, 'https://x.com/b.png');
  });
}
