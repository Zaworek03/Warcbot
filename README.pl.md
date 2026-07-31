# Warcabot — robot grający w warcaby

[🇬🇧 English](README.md) · **🇵🇱 Polski**

**Warcabot** to zautomatyzowane stanowisko, na którym sześcioosiowy robot **Comau Racer 3**
rozgrywa pełną partię warcabów przeciwko człowiekowi. Gracz deklaruje swoje ruchy wyłącznie
przez dotykową wizualizację **mapp View**, natomiast wszystkie czynności fizyczne na planszy —
przesuwanie pionków, bicie oraz odkładanie zbitych pionków do bufora obok planszy — wykonuje
robot. System **mapp Vision** na bieżąco weryfikuje położenie pionków i poprawność każdego ruchu.

Sterownik działa na platformie **B&R Automation Studio** z wykorzystaniem technologii mapp
(Motion, Vision, View oraz usługi mapp). Generowanie legalnych ruchów i przeciwnika komputerowego
zapewnia dedykowany **silnik warcabowy** (C + Python) połączony przez **OPC UA**.

---

## Spis treści

- [Silnik warcabowy](#silnik-warcabowy)
- [Funkcje](#funkcje)
- [Zasada działania](#zasada-działania)
- [Architektura oprogramowania](#architektura-oprogramowania)
- [Silnik warcabowy w szczegółach](#silnik-warcabowy-w-szczegółach)
- [Interfejs OPC UA](#interfejs-opc-ua)
- [Platforma sprzętowa](#platforma-sprzętowa)
- [Panel operatorski (mapp View)](#panel-operatorski-mapp-view)
- [Stos technologiczny](#stos-technologiczny)
- [Struktura repozytorium](#struktura-repozytorium)
- [Uruchomienie](#uruchomienie)
- [Dokumentacja](#dokumentacja)
- [Status projektu](#status-projektu)
- [Autorzy](#autorzy)
- [Licencja](#licencja)

---

## Silnik warcabowy

Logika gry — generowanie legalnych ruchów, reguły bicia oraz przeciwnik AI — realizowana jest
przez osobny silnik warcabowy:

**➡️ [Checkers-Engine-Warcbot](https://github.com/dashin2004/Checkers-Engine-Warcbot)**

Silnik podejmuje decyzje o ruchach maszyny i weryfikuje ruchy gracza; aplikacja sterująca w tym
repozytorium przekłada te decyzje na fizyczny ruch robota i utrzymuje logiczny stan planszy w
zgodzie z systemem wizyjnym. Kopia silnika znajduje się w katalogu `Checkers-Engine-Warcbot-main/`.

## Funkcje

- **Autonomiczna rozgrywka** — robot samodzielnie wykonuje każdy ruch na planszy, łącznie z
  biciami wielokrotnymi i odkładaniem zbitych pionków do bufora obok planszy.
- **System wizyjny** — inteligentna kamera mapp Vision rozpoznaje kolor i położenie pionków oraz
  weryfikuje poprawność wykonania każdego ruchu robota.
- **Silny przeciwnik AI** — silnik bitboardowy z przeszukiwaniem alfa-beta, tablicami
  transpozycji/killer/remisów, ręcznie strojoną funkcją oceny, opcjonalną siecią neuronową i
  księgą otwarć.
- **Wybór poziomu trudności** — od 1-ply początkującego po 15-ply eksperta, plus tryb „troll”
  (najgorszy ruch) i losowy.
- **Intuicyjny panel operatorski (mapp View)** — nowa gra, wybór koloru i trudności, deklaracja
  ruchów, historia ruchów, statystyki i alarmy; obsługa wielu języków i układów jednostek.
- **Tryb ręczny robota** — jog osiowy i kartezjański, sterowanie chwytakiem i powrót do bazy.
- **Bezpieczeństwo** — monitorowanie przestrzeni roboczej i osi, obsługa E-STOP oraz wznawianie
  gry po resecie Safety bez ponownego uruchamiania maszyny.
- **Usługi mapp** — alarmy (AlarmX), zapis/wczytanie gry (Recipe), rejestrowanie zdarzeń (Audit),
  zarządzanie użytkownikami (UserX) i raporty pomeczowe (Report).

## Zasada działania

Pojedynczy ruch przebiega w trzech krokach:

1. **Gracz wybiera ruch** na ekranie — podświetlane są wyłącznie ruchy zgodne z regułami
   (weryfikowane przez [silnik warcabowy](#silnik-warcabowy)).
2. **Kamera sprawdza planszę** — wykonuje zdjęcie i porównuje fizyczne pionki z logicznym stanem gry.
3. **Robot wykonuje ruch** — podnosi pionek, przenosi go na pole docelowe, a zbite pionki odkłada
   do bufora obok planszy.

## Architektura oprogramowania

Aplikacja jest modularna — każda funkcja to osobne zadanie, a dane wymieniane są przez zmienne
globalne i struktury interfejsowe (`gMotionInterface`, `gCameraCtrl`, `gRobotMoveVar`, `gAlarm`).

| Zadanie | Klasa | Rola |
|---------|-------|------|
| `MotionCtrl` | Cyclic #1 | Automat stanów robota: załączenie, bazowanie, tryb ręczny, wykonanie ruchu |
| `MainProgram` | Cyclic #4 | Główny automat gry (weryfikacja planszy, sterowanie krokami, sekwencja bicia) |
| `camera` | Cyclic #4 | Akwizycja obrazu i mapowanie pozycji pionków na pola planszy |
| `CheckVision` | Cyclic #4 | Porównanie planszy z kamery z logicznym stanem gry |
| `PositionInfo` | Cyclic #4 | Odczyt pozycji osi/TCP, monitorowanie przestrzeni roboczej |
| `GameStats` | Cyclic #4 | Wykrywanie ruchów, historia, liczniki zbitych pionków, audyt |
| `SaveGame` | Cyclic #4 | Zapis i wczytanie stanu gry (mapp Recipe) |
| `AlarmHistory` | Cyclic #4 | Historia alarmów i jej eksport (mapp AlarmX) |
| `FolderMng` | Cyclic #4 | Weryfikacja i tworzenie struktury katalogów na dysku USER |
| `VisVariable` | Cyclic #4 | Zmienne powiązane z wizualizacją |

Sekwencje ruchu robota napisano w **Structured Text (ST Motion)** — `move.st` (przeniesienie
pionka z bezpiecznym podejściem pionowym i chwytakiem magnetycznym) oraz `gohome.st` (powrót do
startowej pozycji osiowej). Pola planszy i miejsca w buforze adresowane są tablicami
`COORD_POSITION[x, y]` oraz `BUFOR_POSITION[kolor, slot]`.

## Silnik warcabowy w szczegółach

Silnik ma dwie warstwy: wydajny **rdzeń w C** skompilowany do rozszerzenia Pythona
(`search_engine`) oraz **warstwę sterującą w Pythonie**, zarządzającą grą i połączeniem OPC UA.

- **Reprezentacja bitboard** — plansza jako cztery liczby 64-bitowe (`p1`, `p2`, `p1k`, `p2k`)
  dla pionków i damek każdej ze stron, co umożliwia szybkie generowanie ruchów/bić operacjami bitowymi.
- **Przeszukiwanie** — `negamax` z obcinaniem alfa-beta (`board_search.c`), przyspieszany
  **tablicą transpozycji** Zobrista (`hash_table.c`), **tablicą ruchów zabójczych**
  (`killer_table.c`), **tablicą remisów** (`draw_table.c`) i sortowaniem ruchów. Ograniczany
  głębokością i budżetem czasu.
- **Ocena pozycji** (`board_eval.c`) — materiał (pionek = 50, damka = 70), tablice pozycyjne,
  dystans do promocji, bonus za przewagę materialną, wykrywanie tail-pins oraz rozpoznawane
  maskami bitowymi wzorce strategiczne (Right Lock, Triangle, Oreo, Bridge, Dog, kara za damkę w narożniku).
- **Sieć neuronowa** (`neural_net.c`) — opcjonalny ewaluator przyjmujący 128-neuronowe kodowanie
  planszy (32 pola × warstwy typu pionka) z warstwami ReLU/tanh; zawiera funkcje uczenia.
- **Księga otwarć** (`opening_book.c`, `book_moves.txt`) — zbudowana z dużej kolekcji partii PDN
  (`CheckersGames.pdn`), przechowuje statystyki wyników (wygrane/przegrane/remisy) dla pozycji.

**Poziomy trudności** (`gDifficultyLevel`):

| Poziom | Wartość | Zachowanie |
|--------|---------|------------|
| Łatwy | `0` | Przeszukiwanie na głębokość 1 |
| Średni | `1` | Przeszukiwanie na głębokość 5 |
| Trudny | `2` | Przeszukiwanie na głębokość 15 (budżet ~2 s) |
| Troll (najgorszy ruch) | `3` | Celowo wybiera ruch o najniższej ocenie |
| Losowy | `4` | Losowy legalny ruch (z respektowaniem obowiązku bicia) |

Skrypt Pythona (`PlcCheckers.py`) prowadzi automat gry — `WAITING_FOR_START`,
`HUMAN_SELECT_PIECE`, `HUMAN_SELECT_MOVE`, `BOT_TURN`, `ESTOP`, `GAME_OVER` — generując
podświetlenia legalnych ruchów gracza i czekając na potwierdzenie z kamery po każdym ruchu fizycznym.

## Interfejs OPC UA

Silnik łączy się ze sterownikiem jako klient OPC UA po trwałym, szyfrowanym TLS kanale
(certyfikat klienta `client_cert.der` / `client_key.pem`). Domyślny endpoint
`opc.tcp://192.168.0.11:4842`, konto `Admin`/`Admin`. Wybrane węzły:

| Zmienna | Node ID | Znaczenie |
|---------|---------|-----------|
| `gStart` | `::AsGlobalPV:gStart` | Start gry / wczytanie stanu |
| `gPlayerColor` | `::AsGlobalPV:gPlayerColor` | Kolor człowieka (TRUE = człowiek zaczyna) |
| `gDifficultyLevel` | `::AsGlobalPV:gDifficultyLevel` | Poziom trudności 0–4 |
| `gBoardActual` | `::AsGlobalPV:gBoardActual` | Logiczna plansza 8×8 |
| `gEnablePiece` / `gEnableMove` | `::AsGlobalPV:…` | Podświetlenia legalnych pionków / ruchów |
| `gPickPiece` / `gPickMove` | `::AsGlobalPV:…` | Wybór pionka / pola przez gracza |
| `GESTOP` | `::AsGlobalPV:GESTOP` | Zatrzymanie awaryjne |
| `BoardGit` | `::MainProgra:BoardGit` | Plansza z kamery zgodna ze stanem logicznym |
| `RobotMoveMarker` | `::MainProgra:RobotMoveMarker` | Wyzwolenie fizycznego ruchu robota |
| `WinOrLose` / `EndGame` | `::GameStats:…` | Wynik / koniec gry |

> Po restarcie sterownika sesja OPC UA wygasa — uruchom ponownie `PlcCheckers.py`, aby odtworzyć
> bezpieczny kanał.

## Platforma sprzętowa

| Moduł | Typ | Funkcja |
|-------|-----|---------|
| Komputer panelowy / PLC | `5APC3100.KBU1-000` | Jednostka centralna, runtime ARemb, serwer wizualizacji i OPC UA |
| Robot 6-osiowy | Comau Racer 3 | Fizyczna obsługa pionków (chwytak magnetyczny) |
| Kamera mapp Vision | `VSS112Q22.042P-000` | Rozpoznawanie pionków i weryfikacja ruchu |
| Interfejs POWERLINK | `5AC901.IPLK-00` | Komunikacja z napędami |
| Kontroler magistrali X20 | `X20BC0083` | Stacja I/O POWERLINK |
| I/O X20 | `X20DI9371`, `X20DO9322`, `X20PS9400`, `X20BB80`, `X20BM11`, `X20TB12` | Wejścia/wyjścia cyfrowe (Safety, chwytak), zasilanie, zaciski |
| Napędy | `8EI8X8MWT10.xxxx-1` | Falowniki ACOPOS dla osi robota |

## Panel operatorski (mapp View)

Wizualizacja jest jedynym interfejsem człowiek–maszyna. Ekrany: **Main** (opis projektu),
**Play** (interaktywna plansza 8×8, statystyki, nowa/wczytaj/zapisz grę), **Alarm** (lista aktywna
i historia), **Manual** (jog kartezjański/osiowy, pozycje, bazowanie) i **Settings**. Ekrany Manual
i Settings chronione są logowaniem (mapp UserX). Zrzuty ekranu znajdują się w dokumentacji technicznej.

## Stos technologiczny

- **Automation Studio** 6.7.0
- **mappMotion** 6.7.2 (XT) · **mappView** 6.7.0 · **mappVision** 6.7.0 · **mappServices** 6.7.1
- **OPC UA** (OpcUaCs) 6.7.0
- Automation Runtime embedded (ARemb)
- Silnik warcabowy: C (GCC) + Python — [Checkers-Engine-Warcbot](https://github.com/dashin2004/Checkers-Engine-Warcbot)

## Struktura repozytorium

```
Warcbot/
├── Logical/                        # Warstwa logiczna (programy, typy, biblioteki, mapp View)
│   ├── Programs/                   # Zadania ST: MainProgram, camera, CheckVision, Motion, ...
│   ├── Libraries/                  # Biblioteki mapp i systemowe
│   ├── mappView/                   # Zasoby wizualizacji (media, teksty, motywy)
│   ├── Global.typ / .var           # Typy i zmienne globalne
├── Physical/                       # Konfiguracja sprzętowa (HW, sieci, mappMotion/Vision)
├── Robot-programy/                 # Programy ST Motion (move.st, gohome.st, moveAB.st)
├── SceneViewer/                    # Model symulacyjny celi (Scene Viewer)
├── Checkers-Engine-Warcbot-main/   # Silnik warcabowy (rdzeń C + Python, OPC UA)
├── Documentation/                  # Dokumentacja techniczna (PL + EN, PDF)
├── warcabot.apj                    # Plik projektu Automation Studio
└── LICENSE                         # GNU GPL v3
```

## Uruchomienie

1. Zainstaluj **Automation Studio 6.7** z pakietami mapp (Motion 6.7 XT, View, Vision, Services).
2. Otwórz plik projektu `warcabot.apj`.
3. Zbuduj konfigurację i prześlij oprogramowanie do sterownika (lub uruchom w symulacji).
4. Przed testem na fizycznym robocie zweryfikuj ruchy na modelu w **Scene Viewer**.
5. Otwórz wizualizację mapp View w przeglądarce pod adresem sterownika (`192.168.0.11`).
6. Zbuduj i uruchom silnik warcabowy i podłącz go jako dostawcę logiki gry:

   ```bash
   git clone https://github.com/dashin2004/Checkers-Engine-Warcbot.git
   cd Checkers-Engine-Warcbot
   python3 -m venv .venv && source .venv/bin/activate
   pip install -r requirements.txt
   ./build.sh                       # kompilacja rdzenia C -> search_engine.so
   cd src/python && python3 PlcCheckers.py
   ```

> Uwaga: po zaniku zasilania robot wymaga zbazowania (Restore Position lub bazowanie serwisowe po
> markerach) — patrz dokumentacja techniczna.

## Dokumentacja

Pełny opis techniczny systemu — architektura, każde zadanie ST, silnik warcabowy, OPC UA, wizja,
HMI, sprzęt, bezpieczeństwo i uruchomienie — dostępny jest w dwóch językach:

- 🇵🇱 [`Documentation/Warcabot_Dokumentacja_Techniczna.pdf`](Documentation/Warcabot_Dokumentacja_Techniczna.pdf) — polski
- 🇬🇧 [`Documentation/Warcabot_Technical_Documentation.pdf`](Documentation/Warcabot_Technical_Documentation.pdf) — angielski

## Status projektu

Projekt jest rozwijany. Elementy planowane do dokończenia: pełna integracja logiki gry z ruchem
robota w stanach `GameMove`/`RobotMove`, aktywacja chwytaka magnetycznego w `move.st`, raporty
pomeczowe (mapp Report) oraz rozszerzenia cyberbezpieczeństwa.

## Autorzy

Bartosz Zawłocki · Andrzej Działak · Mateusz Skrzypiński · Szymon Markowski · Adam Witczak · Piotr Piechocki

## Licencja

Oprogramowanie udostępniono na licencji **GNU GPL v3** — szczegóły w pliku [LICENSE](LICENSE).
