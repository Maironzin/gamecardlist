import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:gamecardlist/core/utils/image_utils.dart';
import 'package:gamecardlist/features/card_list/data/repositories/card_list_repository_impl.dart';
import 'package:gamecardlist/features/card_list/domain/entities/card_list_type.dart';
import 'package:gamecardlist/features/card_list/domain/entities/game_category.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/add_free_slot.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/export_card_list.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/get_card_list.dart';
import 'package:gamecardlist/features/card_list/domain/usecases/import_card_list.dart';
import 'package:gamecardlist/features/card_list/presentation/controllers/card_list_controller.dart';

CardListController _controller([CardListType type = CardListType.gameCardList]) {
  const repo = CardListRepositoryImpl();
  return CardListController(
    getCardList: const GetCardList(repo),
    addFreeSlot: const AddFreeSlot(repo),
    exportJson: const ExportCardListJson(repo),
    exportHtml: const ExportCardListHtml(repo),
    importJson: const ImportCardListJson(repo),
    initialType: type,
  );
}

void main() {
  const a = (section: 0, index: 0);
  const b = (section: 0, index: 1);

  test('GameCardList começa com as 3 seções', () {
    expect(
      _controller().sections.map((s) => s.title),
      ['Especificos', 'Generos', 'Personagens'],
    );
  });

  test('menção honrosa com imagem própria pode ser colada em outra', () {
    const empty = GameReference(title: 'x', image: 'assets/images/x.png');
    expect(empty.customImage, isNull);

    final withBytes = empty.withLocalImage(Uint8List.fromList([7]));
    expect(empty.withPastedImage(withBytes.customImage!).localImageBytes, [7]);

    const withUrl = GameReference(image: 'https://exemplo.com/a.png');
    final pasted = withBytes.withPastedImage(withUrl.customImage!);
    expect(pasted.image, withUrl.image);
    expect(pasted.localImageBytes, isNull);
  });

  test('copiar imagem de um card e colar em outro', () {
    final c = _controller();
    c.setImage(a, Uint8List.fromList([9, 9]));

    c.tapCard(a); // seleciona
    expect(c.isPasteTarget(a), isTrue);
    c.tapCard(a); // copia
    expect(c.hasCopiedImage, isTrue);
    c.tapCard(b); // cola

    expect(c.categoryAt(b).localImageBytes, [9, 9]);
    expect(c.hasCopiedImage, isFalse);
  });

  test('Ctrl+V cola URL no card selecionado e reset volta ao padrão', () {
    final c = _controller();
    final base = c.categoryAt(a).image;
    c.tapCard(a);
    expect(c.pasteIntoTarget(const PastedImage.url('https://img/x.png')), isTrue);
    expect(c.categoryAt(a).image, 'https://img/x.png');

    c.resetImage(a);
    expect(c.categoryAt(a).image, base);
    expect(c.categoryAt(a).hasCustomImage, isFalse);
  });

  test('clicar em "Adicionar categoria" cria um Free slot', () {
    final c = _controller(CardListType.generic);
    final before = c.sections.single.categories.length;
    final addRef = (section: 0, index: before - 1);
    expect(c.categoryAt(addRef).isAddCard, isTrue);

    c.tapCard(addRef);

    final categories = c.sections.single.categories;
    expect(categories.length, before + 1);
    expect(categories[before - 1].title, 'Free slot');
    expect(categories.last.isAddCard, isTrue);
  });

  test('excluir selecionados só vale em seção editável', () {
    final fixed = _controller();
    fixed.startSelection(a);
    expect(fixed.canDeleteSelection, isFalse);

    final editable = _controller(CardListType.generic);
    final before = editable.sections.single.categories.length;
    editable.startSelection(a);
    editable.toggleSelection(b);
    editable.deleteSelected();
    expect(editable.sections.single.categories.length, before - 2);
    expect(editable.isSelectionMode, isFalse);
  });

  test('exportar e importar JSON mantém as seções', () {
    final c = _controller();
    c.renameCard(a, 'Meu jogo');
    final json = c.exportJson();

    final other = _controller();
    other.importJson(json);
    expect(other.categoryAt(a).title, 'Meu jogo');
    expect(other.sections.first.title, 'Especificos');
  });

  test('Free slot renomeado volta do JSON no mesmo lugar e renomeável', () {
    final c = _controller();
    final slot = (
      section: 1,
      index: c.sections[1].categories.indexWhere(
        (x) => x.cardType == GameCardType.editableTitle,
      ),
    );
    c.renameCard(slot, 'Roguelike');
    c.setImage(slot, Uint8List.fromList([3, 3]));

    final other = _controller();
    other.importJson(c.exportJson());

    expect(other.categoryAt(slot).title, 'Roguelike');
    expect(other.categoryAt(slot).localImageBytes, [3, 3]);
    other.renameCard(slot, 'Metroidvania');
    expect(other.categoryAt(slot).title, 'Metroidvania');
    expect(other.categoryAt(slot).cardType, GameCardType.editableTitle);
  });

  test('ida e volta com Free slot não duplica "Adicionar categoria"', () {
    final c = _controller(CardListType.generic);
    final addIndex = c.sections.single.categories.length - 1;
    c.tapCard((section: 0, index: addIndex)); // vira Free slot + novo card de adicionar
    expect(c.sections.single.categories.where((x) => x.isAddCard), hasLength(1));

    final other = _controller(CardListType.generic);
    other.importJson(c.exportJson());

    final imported = other.sections.single.categories;
    expect(imported.where((x) => x.isAddCard), hasLength(1));
    expect(imported.last.isAddCard, isTrue);
    expect(
      imported.where((x) => x.cardType == GameCardType.editableTitle),
      hasLength(1),
    );
  });

  test('lista editável importada continua permitindo adicionar e excluir', () {
    final source = _controller(CardListType.generic);
    final c = _controller(CardListType.generic);
    c.importJson(source.exportJson());
    expect(c.sections.single.isEditing, isTrue);

    final before = c.sections.single.categories.length;
    c.tapCard((section: 0, index: before - 1));
    expect(c.sections.single.categories.length, before + 1);
    expect(c.sections.single.categories.last.isAddCard, isTrue);

    c.clearPasteTarget();
    c.startSelection(a);
    expect(c.canDeleteSelection, isTrue);
    c.deleteSelected();
    expect(c.sections.single.categories.length, before);
  });

  test('seções fixas continuam fixas depois de importar', () {
    final c = _controller();
    c.importJson(_controller().exportJson());

    expect(c.sections.map((s) => s.isEditing), everyElement(isFalse));
    for (final section in c.sections) {
      expect(section.categories.where((x) => x.isAddCard), isEmpty);
    }
  });

  test('arquivo com "Adicionar categoria" não duplica o card', () {
    Map<String, dynamic> card(String title, GameCardType type) => {
      'title': title,
      'image': 'assets/images/freeSlot.png',
      'color': '#9e9e9e',
      'cardType': type.toString(),
    };
    final json = jsonEncode([
      [
        card('Adicionar categoria', GameCardType.addCategory),
        card('Story', GameCardType.generic),
      ],
    ]);

    final editable = _controller(CardListType.generic)..importJson(json);
    expect(editable.sections.single.categories.map((x) => x.title), [
      'Story',
      'Adicionar categoria',
    ]);

    final fixed = _controller()..importJson(json);
    expect(fixed.sections.single.categories.map((x) => x.title), ['Story']);
  });
}
