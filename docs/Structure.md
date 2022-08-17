# Entidades del Juego de Azul

En este documento se mostrara la arquitectura general del proyecto de Azul, es decir, cuales son los archivos creados y que se contendrá en cada archivo.

## Entidad Bolsa

- Contiene 100 azulejos, 20 de cada color
- Los colores de los azulejos son:
  - azul
  - amarillo
  - rojo
  - negro
  - blanco

### Funcionalidades de la Bolsa

#### Crearse

```Prolog
new_bag(Bag).
```

#### Extraer

Extrae de la *Bolsa* una cantidad de azulejos dado.

```Prolog
extract_from_bag(Bag, Number_of_tiles, Extracted_tiles, Updated_bag).
```

#### Agregar

Agrega a la Bolsa una lista de azulejos. Los azulejos dados deben estar en una lista de azulejos

```Prolog
add_to_bag(Bag, List_of_tiles, Updated_bag).
```

#### Imprimirse

Imprime la Bolsa de una forma amena.

```Prolog
print_bag(Bag).
```

---

## Entidad Centro

- El centro de mesa es junto a las factorías otra de las zonas de donde el jugador puede seleccionar azulejos.
- La mayor diferencia con respecto a las factorías es que puede tener mas de 4 azulejos y que ademas puede tener la ficha de jugador inicial

### Elementos a tener en cuenta para entender el Centro y posteriormente las factorías

El Centro y las Factorías en el código de prolog se consideraran un caso especial de 'Grupos', estos grupos no tienen nada que ver con la Teoría de Grupos que se da en Algebra, es simplemente un concepto propio de este proyecto y no es mas que una lista donde sus elementos tienen la siguiente forma: `Element:Amount`. Los grupos se crean en este proyecto por el hecho de que de las Factorías y el Centro uno extrae un 'grupo' de azulejos del mismo color (realmente son todos los del mismo color).

Si uno quiere agregarle a un grupo un elemento extra y en el grupo ese elemento ya se encuentra pues solamente se aumenta su contador.

### Funcionalidades del Centro

#### Crear Centro

El centro se crea como un 'grupo' que contiene inicialmente la ficha de jugador inicial.
Esto se realiza con el predicado

```Prolog
new_center(Center) :-
    Center = [first:1].
```

#### Agregar al Centro

Agrega una colección de azulejos al Centro, es decir, recibe un 'grupo' de azulejos extraídos de alguna factoría y los agrega al Centro

```Prolog
% New_tiles_to_add es un grupo, es decir, una lista donde sus elementos
% tienen el formato: Element:Amount
add_to_center(Center, New_tiles_to_add, New_center) :-
    merge_groups(New_tiles_to_add, Center, New_center).

```

#### Extraer del Centro o de una Factoría

Esto lo que hace es extraer todos los Azulejos de un color que estén en el Centro o en alguna Factoría.

Este predicado es común a el Centro y a las Factorías, por ser común se devuelve algunas veces un elemento de más que no tiene sentido alguno para las Factorías por ejemplo, y es que puede agregar a lo extraído la ficha del jugador inicial.

```Prolog
% Aquí se debe Notar que Tile_to_extract tiene que ser un Tile valido, por ende
% no se puede pedir extraer la ficha del jugador inicial, en cuyo caso fallara
extract_from_tile_collection(Collection, Tile_to_extract, Extracted_tiles, New_collection) :-
    tiles(Tile_to_extract),
    extract_first_(Collection, Extracted_first, New_collection_0), % Extracted_first puede ser lista vacía
    list_index(New_collection_0, Index, Tile_to_extract:Amount),!,
    split_at(Index, New_collection_0, First_part, [_ | Tail]),
    append(Extracted_first, [Tile_to_extract:Amount], Extracted_tiles),
    append(First_part, Tail, New_collection).

```
