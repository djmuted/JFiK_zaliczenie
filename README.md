# JFiK_zaliczenie

Repozytorium składa się z trzech folderów
- folder z61c dotyczy zadania 6.1c z listy zadań dr inż. Jankowskiej
- folder z61d dotyczy zadania 6.1d z listy zadań dr inż. Jankowskiej
- folder interpreter dotyczy zadania Intrepretera dr inż. Dutkiewicza

# Zadania teoretyczne
- zadanie 6.1a
```
((([ \t]+[1-9]+[0-9]*)+\n)|(([ \t]+0x[0-9A-F]+)+\n)|(([ \t]+[0-9]+\.[0-9]+)+\n)|(([ \t]+[0-9]+\.[0-9]+E(\+|\-)[0-9]+)+\n))+
```
- zadanie 6.1b
```
NL -> '\n' | '\r' '\n'
SP -> ' '
TAB -> '\t'
DOT -> '.'
MINUS -> '-'
PLUS -> '+'
ZERO -> '0'
OP -> 'x'
NUM -> '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
NUMZERO -> NUM | ZERO
CHAR -> 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
E -> 'E'

PRZERWA -> SP | TAB | PRZERWA SP | PRZERWA TAB
PLUSMINUS -> PLUS | MINUS
DEC -> NUM | DEC NUM | DEC ZERO
AFTERDOT -> NUM | ZERO | AFTERDOT NUM | AFTERDOT ZERO
FRACTION -> DEC | ZERO
HEXNUM -> NUM | CHAR | HEXNUM NUMZERO | HEXNUM CHAR
HEX -> ZERO OP HEXNUM
FIXED -> FRACTION DOT AFTERDOT
FLOAT -> FRACTION DOT AFTERDOT E PLUSMINUS FRACTION

PLIK -> WIERSZ | PLIK NL WIERSZ
WIERSZDEC -> PRZERWA DEC | WIERSZDEC PRZERWA DEC
WIERSZHEX -> PRZERWA HEX | WIERSZHEX PRZERWA HEX
WIERSZFIXED -> PRZERWA FIXED | WIERSZFIXED PRZERWA FIXED
WIERSZFLOAT -> PRZERWA FLOAT | WIERSZFLOAT PRZERWA FLOAT
WIERSZ -> WIERSZDEC | WIERSZHEX | WIERSZFIXED | WIERSZFLOAT
```

# Działanie poszczególnych programów
- zadania 6.1c/6.1d
Przy pomocy połączenia narzędzi flex i bison można było rozdzielić analizę na część leksykalną i gramatyczną. Część leksykalna na podstawie wyrażeń regularnych analizuje tekst i wskazuje gramatyczne tokeny do narzędzia bison. Część gramatyczna opisuje w jaki sposób te tokeny powinny występować w składni. Po rozpoznaniu całego wiersza sumowane są wartości poszczególnych elementów a wynik podawany jest na standardowe wyjście.  

- zadanie interpreter
Podobnie jak w poprzednim zadaniu wykorzystane zostały narzędzia flex i bison, a cały program został napisany w języku C++ ze względu na dostęp do kontenerów takich jak np std::vector, które znacznie ułatwiały stworzenie interpretera. W trakcie analizy podanego kodu tworzone są tak zwane operacje (klasa OPERATION) zawierające informacje typie operacji (np printowanie tekstu na standardowe wyjście) oraz argumentach (struktura E_STRUCT). Budowa struktury E_STRUCT mocno czerpie inspirację z podanej w przykładowym kodzie dołączonym do treści zadania tokenie E. Token E zajmuje się obliczaniem wartości liczbowych całkowitych poprzez dodawanie, odejmowanie, mnożenie i dzielenie dosłownych wartości liczbowych lub zmiennych. Po zakończonej analizie wyżej opisane operacje są wykonywane. W przypadkach takich jak np. pętla WHILE wartości argumentów (E_STRUCT) są obliczane od nowa po każdym wykonaniu kroku, aby upewnić się, że warunek pętli wciąż jest spełniany. 

# Kompilacja
Każdy folder posiada skrypt Makefile kompilujący projekty na systemach Linux i MacOS, jednakże można je skompilować ręcznie przy użyciu następujących komend:
- zadania z61c i z61d:

```
bison grammar.y
flex lex.l
gcc lex.yy.c
```

- zadanie interpreter
```
bison grammar.y
flex lex.l
g++ lex.yy.c -DYY_SKIP_YYWRAP
```

Do interpretera należy na wejściu podać cały plik np:
- dla systemów Linux/MacOS: `./a.out < program.txt `
- dla systemów Windows: `a.exe < program.txt`

# Użycie
- zadania 6.1c i 6.1d można sprawdzić poprzez przekazanie na wejście pliku testowego (przykładowe dane testowe są podane w pliku dane.txt)

Dla systemów Linux/MacOS (skrypt Makefile zajmuje się kompilacją i wykonuje program dla testowego wejścia dane.txt)
```
make testdane
```

Dla systemów Windows
```
a.exe < dane.txt
```
- zadanie z interpreterem można sprawdzić w analogiczny sposób podając na wejściu program (przykładowy program jest podany w pliku program.txt)

Dla systemów Linux/MacOS (skrypt Makefile zajmuje się kompilacją i wykonuje program dla testowego wejścia program.txt)
```
make testdane
```

Dla systemów Windows
```
a.exe < program.txt
```
