import 'package:flutter/foundation.dart';

import 'package:gamecardlist/core/utils/image_utils.dart';
import 'package:gamecardlist/features/card_list/domain/entities/card_list_type.dart';
import 'package:gamecardlist/features/card_list/domain/entities/card_section.dart';
import 'package:gamecardlist/features/card_list/domain/entities/game_category.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/add_free_slot.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/export_card_list.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/get_card_list.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/import_card_list.dart';

/// Posição de um card na tela.
typedef CardRef = ({int section, int index});

/// Estado da tela de cards: lista atual, seleção múltipla e o fluxo de
/// copiar/colar imagem entre cards.
class CardListController extends ChangeNotifier {
  final GetCardList _getCardList;
  final AddFreeSlot _addFreeSlot;
  final ExportCardListJson _exportJson;
  final ExportCardListHtml _exportHtml;
  final ImportCardListJson _importJson;

  CardListController({
    required GetCardList getCardList,
    required AddFreeSlot addFreeSlot,
    required ExportCardListJson exportJson,
    required ExportCardListHtml exportHtml,
    required ImportCardListJson importJson,
    CardListType initialType = CardListType.gameCardList,
  }) : _getCardList = getCardList,
       _addFreeSlot = addFreeSlot,
       _exportJson = exportJson,
       _exportHtml = exportHtml,
       _importJson = importJson,
       _type = initialType,
       _sections = getCardList(initialType);

  CardListType _type;
  List<CardSection> _sections;
  bool _isSelectionMode = false;
  final Set<CardRef> _selected = {};
  CardRef? _pasteTarget;
  PastedImage? _copiedImage;

  CardListType get type => _type;
  List<CardSection> get sections => List.unmodifiable(_sections);
  bool get isSelectionMode => _isSelectionMode;
  int get selectedCount => _selected.length;
  bool isSelected(CardRef ref) => _selected.contains(ref);
  bool isPasteTarget(CardRef ref) => _pasteTarget == ref;
  bool get hasCopiedImage => _copiedImage != null;
  bool get hasPasteTarget => _pasteTarget != null;

  /// Há algum card selecionado numa seção que permite excluir?
  bool get canDeleteSelection =>
      _selected.any((ref) => _sections[ref.section].isEditing);

  GameCategory categoryAt(CardRef ref) =>
      _sections[ref.section].categories[ref.index];

  // ------------------------------------------------------------ lista

  void changeType(CardListType type) {
    _type = type;
    _setSections(_getCardList(type));
  }

  String exportJson() => _exportJson(_sections);

  String exportHtml(String exportedBy) => _exportHtml(_sections, exportedBy);

  /// Lança [FormatException] se o arquivo for inválido.
  void importJson(String json) {
    _setSections(_importJson(json, _type));
  }

  void _setSections(List<CardSection> sections) {
    _sections = sections;
    _selected.clear();
    _isSelectionMode = false;
    _clearPaste();
    notifyListeners();
  }

  // ------------------------------------------------------------ toque no card

  /// Clique simples. Fluxo de copiar/colar:
  /// 1º clique seleciona o card; 2º clique no mesmo card copia a imagem;
  /// clique em outro card cola a imagem copiada nele.
  void tapCard(CardRef ref) {
    if (_isSelectionMode) {
      toggleSelection(ref);
      return;
    }

    if (categoryAt(ref).isAddCard) {
      _sections[ref.section] = _addFreeSlot(_sections[ref.section], ref.index);
    }

    final copied = _copiedImage;
    if (copied != null && _pasteTarget != ref) {
      _replace(ref, categoryAt(ref).withPastedImage(copied));
      _clearPaste();
    } else if (_pasteTarget == ref) {
      _copiedImage = _imageOf(categoryAt(ref));
      if (_copiedImage == null) _clearPaste();
    } else {
      _pasteTarget = ref;
    }
    notifyListeners();
  }

  /// Cola uma imagem do clipboard do sistema no card selecionado.
  bool pasteIntoTarget(PastedImage image) {
    final target = _pasteTarget;
    if (target == null || !_isValid(target)) return false;
    _replace(target, categoryAt(target).withPastedImage(image));
    _clearPaste();
    notifyListeners();
    return true;
  }

  void clearPasteTarget() {
    if (_pasteTarget == null && _copiedImage == null) return;
    _clearPaste();
    notifyListeners();
  }

  // ------------------------------------------------------------ edição

  void setImage(CardRef ref, Uint8List bytes) {
    _replace(ref, categoryAt(ref).withLocalImage(bytes));
    notifyListeners();
  }

  void setPastedImage(CardRef ref, PastedImage image) {
    _replace(ref, categoryAt(ref).withPastedImage(image));
    notifyListeners();
  }

  void resetImage(CardRef ref) {
    _replace(ref, categoryAt(ref).resetImage());
    notifyListeners();
  }

  void renameCard(CardRef ref, String title) {
    _replace(ref, categoryAt(ref).copyWith(title: title));
    notifyListeners();
  }

  void updateHonorGames(CardRef ref, List<GameReference> honorGames) {
    _replace(ref, categoryAt(ref).copyWith(honorGames: honorGames));
    notifyListeners();
  }

  void removeCard(CardRef ref) {
    final section = _sections[ref.section];
    if (!section.isEditing) return;
    _sections[ref.section] = section.withCategories(
      [...section.categories]..removeAt(ref.index),
    );
    _selected.clear();
    _clearPaste();
    notifyListeners();
  }

  // ------------------------------------------------------------ seleção múltipla

  void startSelection(CardRef ref) {
    _isSelectionMode = true;
    _clearPaste();
    toggleSelection(ref);
  }

  void toggleSelection(CardRef ref) {
    if (categoryAt(ref).isAddCard) return;
    if (!_selected.remove(ref)) _selected.add(ref);
    notifyListeners();
  }

  void selectAll() {
    for (var s = 0; s < _sections.length; s++) {
      final categories = _sections[s].categories;
      for (var i = 0; i < categories.length; i++) {
        if (!categories[i].isAddCard) _selected.add((section: s, index: i));
      }
    }
    notifyListeners();
  }

  void clearSelection() {
    _selected.clear();
    notifyListeners();
  }

  void exitSelectionMode() {
    _isSelectionMode = false;
    _selected.clear();
    notifyListeners();
  }

  void setImageForSelected(Uint8List bytes) {
    for (final ref in _selected) {
      _replace(ref, categoryAt(ref).withLocalImage(bytes));
    }
    exitSelectionMode();
  }

  void resetSelectedImages() {
    for (final ref in _selected) {
      _replace(ref, categoryAt(ref).resetImage());
    }
    exitSelectionMode();
  }

  void deleteSelected() {
    final bySection = <int, List<int>>{};
    for (final ref in _selected) {
      if (_sections[ref.section].isEditing) {
        bySection.putIfAbsent(ref.section, () => []).add(ref.index);
      }
    }
    bySection.forEach((s, indexes) {
      final categories = [..._sections[s].categories];
      indexes.sort((a, b) => b.compareTo(a));
      for (final i in indexes) {
        if (!categories[i].isAddCard) categories.removeAt(i);
      }
      _sections[s] = _sections[s].withCategories(categories);
    });
    exitSelectionMode();
  }

  // ------------------------------------------------------------ helpers

  void _replace(CardRef ref, GameCategory category) {
    final section = _sections[ref.section];
    final categories = [...section.categories];
    categories[ref.index] = category;
    _sections[ref.section] = section.withCategories(categories);
  }

  bool _isValid(CardRef ref) =>
      ref.section < _sections.length &&
      ref.index < _sections[ref.section].categories.length;

  PastedImage? _imageOf(GameCategory category) {
    final bytes = category.localImageBytes;
    if (bytes != null) return PastedImage.bytes(Uint8List.fromList(bytes));
    if (isNetworkImage(category.image)) return PastedImage.url(category.image);
    return null;
  }

  void _clearPaste() {
    _pasteTarget = null;
    _copiedImage = null;
  }
}
