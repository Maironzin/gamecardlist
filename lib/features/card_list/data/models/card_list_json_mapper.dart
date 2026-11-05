import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' show Color;

import 'package:gamecardlist/features/card_list/domain/entities/card_section.dart';
import 'package:gamecardlist/features/card_list/domain/entities/game_category.dart';

/// Converte as seções de/para o JSON de backup.
///
/// Formato (compatível com os backups antigos): lista de seções, cada seção
/// uma lista de categorias com `localImageBase64` para imagens locais.
class CardListJsonMapper {
  const CardListJsonMapper();

  String encode(List<CardSection> sections) {
    final data = <List<Map<String, dynamic>>>[];
    for (final section in sections) {
      final categories = section.categories
          .where((c) => !c.isAddCard)
          .map(_categoryToJson)
          .toList();
      if (categories.isNotEmpty) data.add(categories);
    }
    return jsonEncode(data);
  }

  List<CardSection> decode(String json, List<String> sectionTitles) {
    final data = jsonDecode(json) as List<dynamic>;
    final sections = <CardSection>[];
    for (final rawSection in data) {
      final categories = (rawSection as List)
          .map((item) => _categoryFromJson(item as Map<String, dynamic>))
          .toList();
      if (categories.isEmpty) continue;
      final index = sections.length;
      sections.add(
        CardSection(
          title: index < sectionTitles.length
              ? sectionTitles[index]
              : 'Seção ${index + 1}',
          categories: categories,
        ),
      );
    }
    return sections;
  }

  Map<String, dynamic> _categoryToJson(GameCategory c) => {
    'title': c.title,
    'image': c.image,
    'baseImage': c.baseImage,
    'color': _colorToHex(c.color),
    'description': c.description,
    'cardType': c.cardType.toString(),
    'localImageBase64': _bytesToBase64(c.localImageBytes),
    'honorGames': c.honorGames
        .map(
          (hg) => {
            'title': hg.title,
            'image': hg.image,
            'localImageBase64': _bytesToBase64(hg.localImageBytes),
          },
        )
        .toList(),
  };

  GameCategory _categoryFromJson(Map<String, dynamic> json) {
    final image = json['image'] as String? ?? '';
    return GameCategory(
      title: json['title'] as String? ?? '',
      image: image,
      baseImage: json['baseImage'] as String? ?? image,
      color: _colorFromHex(json['color'] as String? ?? '#FF5722'),
      description: json['description'] as String? ?? '',
      cardType: _cardTypeFromString(json['cardType'] as String?),
      localImageBytes: _base64ToBytes(json['localImageBase64']),
      honorGames: [
        for (final hg in (json['honorGames'] as List? ?? const []))
          GameReference(
            title: (hg as Map<String, dynamic>)['title'] as String? ?? '',
            image: hg['image'] as String? ?? '',
            localImageBytes: _base64ToBytes(hg['localImageBase64']),
          ),
      ],
    );
  }

  GameCardType _cardTypeFromString(String? value) {
    for (final type in GameCardType.values) {
      if (type.toString() == value) return type;
    }
    return GameCardType.generic;
  }

  String _colorToHex(Color color) =>
      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

  Color _colorFromHex(String hex) {
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse(clean.length == 6 ? 'ff$clean' : clean, radix: 16));
  }

  String? _bytesToBase64(Uint8List? bytes) =>
      bytes == null ? null : base64Encode(bytes);

  Uint8List? _base64ToBytes(Object? value) =>
      value is String ? base64Decode(value) : null;
}
