# JFiK_zaliczenie

Repozytorium składa się z trzech folderów
- folder z61c dotyczy zadania 6.1c z listy zadań dr inż. Jankowskiej
- folder z61d dotyczy zadania 6.1d z listy zadań dr inż. Jankowskiej
- folder interpreter dotyczy zadania Intrepretera dr inż. Dutkiewicza

# Zadania teoretyczne
- zadanie 6.1a
```
Zbiór danych jest niepustym zbiorem wierszy, z których każdy składa się
z liczb nieujemnych bez znaku:
a) całkowitych zapisanych w układzie dziesiętnym, np. 3256,
b) całkowitych zapisanych w układzie szesnastkowym, np. 43C3,
c) rzeczywistych zapisanych w układzie dziesiętnym w formacie stałopozycyjnym, np.
12.93,
d) rzeczywistych zapisanych w układzie dziesiętnym w formacie
zmiennoprzecinkowym, z cechą koniecznie poprzedzoną znakiem, np. 23.64E+12.
Poszczególne wiersze są niepuste i mają jednorodną postać, tzn. znajdujące się w nich
liczby należą do tej samej kategorii (a, b, c lub d). Każda liczba w wierszu jest
poprzedzona dowolną (niezerową) liczbą spacji lub znaków tabulacji.
```
Rozwiązanie:
```
((([ \t]+[1-9]+[0-9]*)+\n)|
(([ \t]+0x[0-9A-F]+)+\n)|
(([ \t]+(([1-9]+[0-9]*)|0)\.[0-9]+)+\n)|
(([ \t]+(([1-9]+[0-9]*)|0)\.[0-9]+E(\+|\-)(([1-9]+[0-9]*)|0))+\n))+
```
Objaśnienia wyrażenia regularnego:
```
Liczby całkowite:
[ \t]+ oznacza niezerową ilość spacji lub tabulacji (\t)
[1-9]+ oznacza niezerową ilość znaków od 1 do 9 (pierwsza cyfra liczby całkowitej musi być różna od 0)
[0-9]* oznacza dowolną ilość znaków od 0-9 (dalsza część liczby całkowitej)
jeden element wiersza zamknięty jest w grupie, a ilość liczb w danym wierszu musi być większa od 0
\n oznacza znak nowej linii (ewentualnie w notacji Windowsowej nową linię można zapisać jako \r\n)

Liczby szesnastkowe:
Każda liczba szesnastkowa zaczyna się od 0x, po czym występuje dowolna ilość znaków od 0 do 9 lub od A do F (np liczba 0x0004 jest dopuszczalna)

Liczby stałoprzecinkowe:
(0|([1-9]+[0-9]*)) oznacza to, że przed przecinkiem może wystąpić 0 lub liczba całkowita ([1-9]+[0-9]*)
.[0-9]+ oznacza przecinek oraz rozwinięcie dziesiętne liczby

Liczby rzeczywiste w notacji naukowej
Wygląda tak jak liczba stałoprzecinkowa, z dodatkiem:
E(\+|\-) oznacza literę E oraz znak + lub -
(([1-9]+[0-9]*)|0) oznacza liczbę całkowitą lub zero
```
- zadanie 6.1b
```
Zdefiniuj gramatykę bezkontekstową generującą zbiór zbiorów danych
scharakteryzowanych w zadaniu 6.1a
```
Rozwiązanie:
```
Symbol startowy: PLIK

Symbole terminalne:
NL -> '\n' | '\r' '\n'
SP -> ' '
TAB -> '\t'
DOT -> '.'
MINUS -> '-'
PLUS -> '+'
ZERO -> '0'
OP -> 'x'
NUM -> '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
CHAR -> 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
E -> 'E'

Symbole nieterminalne:
NUMZERO -> NUM | ZERO
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

Przy pomocy połączenia narzędzi flex i bison można było rozdzielić analizę na część leksykalną i gramatyczną. Część leksykalna na podstawie wyrażeń regularnych podanych w zadaniu 6.1a analizuje tekst i wskazuje gramatyczne tokeny do narzędzia bison. Część gramatyczna opisuje w jaki sposób te tokeny powinny występować w składni. Opiera się ona na gramatyce wskazanej w zadaniu 6.1b.  Po rozpoznaniu całego wiersza sumowane są wartości poszczególnych elementów a wynik podawany jest na standardowe wyjście. Dodatkowo w podpunkcie 6.1c weryfikowany jest indeks wiersza w części leksykalnej. W przypadku rozpoznania prawidłowego indeksu (zgodnego z obecnym licznikiem wierszy) zwracany jest token INDEX, w przeciwnym razie token UNDEFINED, który wywołuje błąd składniowy i przerwanie analizy.

- zadanie interpreter

Podobnie jak w poprzednim zadaniu wykorzystane zostały narzędzia flex i bison, a cały program został napisany w języku C++ ze względu na dostęp do kontenerów takich jak np std::vector, które znacznie ułatwiały stworzenie interpretera. W trakcie analizy podanego kodu tworzone są tak zwane operacje (klasa OPERATION) zawierające informacje typie operacji (np printowanie tekstu na standardowe wyjście) oraz argumentach (struktura E_STRUCT). Budowa struktury E_STRUCT mocno czerpie inspirację z podanej w przykładowym kodzie dołączonym do treści zadania tokenie E. Token E zajmuje się obliczaniem wartości liczbowych całkowitych poprzez dodawanie, odejmowanie, mnożenie i dzielenie dosłownych wartości liczbowych lub zmiennych. Po zakończonej analizie wyżej opisane operacje są wykonywane. W przypadkach takich jak np. pętla WHILE wartości argumentów (E_STRUCT) są obliczane od nowa po każdym wykonaniu kroku, aby upewnić się, że warunek pętli wciąż jest spełniany. 

Funkcja int resolveE(E_STRUCT * e) zajmuje się rekurencyjnym rozwiązywaniem działań na liczbach i zmiennych. Na przykład działanie 5+a+3 zostanie rozbite na dwie struktury E_STRUCT, gdzie pierwsza będzie zawierała: pierwszy argument wartość liczbową 5 oraz drugi argument nazwę zmiennej a. Druga struktura E_STRUCT będzie w argumentach zawierała wskaźnik na pierwszą strukturę E_STRUCT oraz wartość liczbową 3. 

Do interpretera został też dodany mechanizm inkrementacji i dekrementacji, dzięki czemu możliwe jest stworzenie pętli while w postaci: 
```
i=5;
WHILE i>0 i-- PRINT i;
```

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
