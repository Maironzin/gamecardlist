# Design

## Export
- `encode` passa a descartar só `GameCardType.addCategory` (`!c.isAddCard`).

## Import
- O mapper não muda: `_cardTypeFromString` já reconhece `GameCardType.editableTitle`, e `_categoryFromJson` já lê todos os campos do Free slot.
- `ImportCardListJson` passa a receber o `CardListType` atual, no lugar dos títulos. Cada seção importada herda o `isEditing` da seção de mesmo índice no preset desse tipo; seção além do preset fica fixa.
- O use case remove qualquer "Adicionar categoria" vindo do arquivo e, se a seção for editável, coloca um novo no fim. Assim sempre há no máximo um.

## Formato do arquivo
- Mesma estrutura e mesmos campos; o arquivo só passa a ter mais entradas, com um `cardType` que já existe no enum.
- Backups antigos seguem abrindo: `cardType` ausente vira `generic`, e quem não tem Free slot continua sem ele.

## Testes
- Mapper: ida e volta de um Free slot com imagem e menções, em seção sem outros cards.
- Controller: Free slot no preset GameCardList volta na mesma posição e renomeável; a lista genérica volta com um único "Adicionar categoria", que funciona, e permite excluir; seções fixas continuam fixas; arquivo com "Adicionar categoria" não duplica o card.
