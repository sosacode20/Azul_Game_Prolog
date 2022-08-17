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

### Funcionalidades

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
