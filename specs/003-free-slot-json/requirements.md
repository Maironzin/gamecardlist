# Free slot no backup JSON

## Contexto
`CardListJsonMapper.encode` descarta os cards `editableTitle`. Um Free slot renomeado, com imagem e menções honrosas, some ao exportar e importar o JSON. O HTML exportado mantém esses cards, e nenhuma spec pede o descarte: é bug, não regra.

## Histórias
- Como usuário, quero que meus Free slots voltem do backup como eu os deixei e continuem renomeáveis.

## Critérios de aceite
- [ ] DADO um Free slot renomeado com imagem e menções honrosas QUANDO exporto e importo o JSON ENTÃO título, imagem, imagem base e menções voltam iguais.
- [ ] O Free slot importado continua `editableTitle`.
- [ ] Uma seção só com Free slot não some do JSON.
- [ ] O card "Adicionar categoria" continua fora do JSON, e a ida e volta não o duplica.
- [ ] Backups antigos (sem Free slot ou sem `cardType`) continuam abrindo como antes.
- [ ] DADO uma lista editável QUANDO importo um JSON ENTÃO a seção segue editável, com um único "Adicionar categoria" no fim, e dá para adicionar e excluir cards.
- [ ] DADO uma seção fixa do modelo atual QUANDO importo um JSON ENTÃO ela segue fixa e sem "Adicionar categoria".
- [ ] Um arquivo que traga "Adicionar categoria" não duplica o card.

## Fora de escopo
- Alterar `card_list_html_renderer.dart`.
- Recuperar Free slots de backups já exportados: esses dados não estão no arquivo.
- Guardar `isEditing` no JSON: o formato do arquivo não muda.
