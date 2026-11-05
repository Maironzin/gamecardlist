import 'package:gamecardlist/features/card_list/domain/entities/card_list_type.dart';
import 'package:gamecardlist/features/card_list/domain/entities/card_section.dart';
import 'package:gamecardlist/features/card_list/domain/repositories/card_list_repository.dart';

class ImportCardListJson {
  final CardListRepository _repository;
  const ImportCardListJson(this._repository);

  /// O JSON não guarda quais seções são editáveis: isso vem do modelo [type].
  ///
  /// Lança [FormatException] se o JSON for inválido ou vazio.
  List<CardSection> call(String json, CardListType type) {
    final sections = _repository.decodeJson(json, type.sectionTitles);
    if (sections.isEmpty) {
      throw const FormatException('O arquivo não tem nenhuma categoria.');
    }
    final preset = _repository.getPreset(type);
    return [
      for (var i = 0; i < sections.length; i++)
        _restoreEditing(sections[i], i < preset.length && preset[i].isEditing),
    ];
  }

  CardSection _restoreEditing(CardSection section, bool isEditing) {
    return CardSection(
      title: section.title,
      isEditing: isEditing,
      categories: [
        ...section.categories.where((c) => !c.isAddCard),
        if (isEditing) _repository.createAddCard(),
      ],
    );
  }
}
