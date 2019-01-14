# JFiK_zaliczenie

Repozytorium składa się z trzech folderów
- folder z61c dotyczy zadania 6.1c z listy zadań dr inż. Jankowskiej
- folder z61d dotyczy zadania 6.1d z listy zadań dr inż. Jankowskiej
- folder interpreter dotyczy zadania Intrepretera dr inż. Dutkiewicza

# Kompilacja
Każdy folder posiada skrypt Makefile kompilujący projekty na systemach Linux i Macos, jednakże można je skompilować ręcznie przy użyciu następujących komend:
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
