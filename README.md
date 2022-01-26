## Documentation

### Motions

- { and } are remapped to nop.
- Each motion are a combination of direction, type and its modifiers.
- ] is forward and [ is backward direction.
- i before the type moves it to the "inner".
- Capital letter uses opening of the type rather than the closing.
- Works with operators
- ; repeats previously used motions

#### Examples

- ]q moves the cursor to the end of the next encountered quote.
- ]iq moves the cursor to the end of the next quoted content.
- [b moves the cursor to the beginning of a previous block.
- [ + space moves the cursor to the end of a previous space.

### Text Objects

- { "shrinks" the selection to a smaller nested object.
- } "enlarges" the current selection.
- { and } only works in visual mode.
- No text objects with capital letters.
- No repeat bindings, but . can repeat previous operation.

#### Examples

- vib would select the block current cursor is in, when used in normal mode.
- }b would make selection to select a block that current selection is contained in.
- }iq would make the selection to select content of the quote that the current selection is in.
- { + space would shrink the selection to a smaller section of contained by 2 section of spaces.

### Types

- b - blocks
- q - quotes
- t - xml/html or other similar structure
- space - spaces
- w - words
- s - parts of a word

## Install

Install as you would any other vim plugin. No external dependencies, everything is written in VimL.

## Configuration

To prevent default bindings set g:TextObj_setMapping and g:TextObj_setRepeat.
