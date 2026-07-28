# Warcabot – robot grający w warcaby

Warcabot to zautomatyzowane stanowisko, na którym sześcioosiowy robot **Comau Racer 3**
rozgrywa pełną partię warcabów z człowiekiem. Gracz deklaruje swoje ruchy wyłącznie
przez dotykową wizualizację **mapp View**, a wszystkie pionki na planszy – łącznie z biciem
i odkładaniem zbitych warcabów do bufora – przenosi robot. System wizyjny na bieżąco
weryfikuje ułożenie pionków.

Projekt zrealizowano na platformie **B&R Automation Studio** z wykorzystaniem technologii
mapp (Motion, Vision, View oraz usług mapp).

---

## Spis treści

- [Główne funkcje](#główne-funkcje)
- [Jak to działa](#jak-to-działa)
- [Architektura oprogramowania](#architektura-oprogramowania)
- [Platforma sprzętowa](#platforma-sprzętowa)
- [Stos technologiczny](#stos-technologiczny)
- [Struktura repozytorium](#struktura-repozytorium)
- [Uruchomienie](#uruchomienie)
- [Dokumentacja](#dokumentacja)
- [Status projektu](#status-projektu)
- [Licencja](#licencja)

---

## Główne funkcje

- **Automatyczna rozgrywka** – robot samodzielnie wykonuje wszystkie ruchy na planszy.
- **System wizyjny** – kamera rozpoznaje kolor i położenie pionków oraz weryfikuje
  poprawność każdego ruchu robota.
- **Intuicyjny panel operatora (mapp View)** – nowa gra, wybór koloru i poziomu
  trudności, deklarowanie ruchów, historia, alarmy; obsługa wielu języków i jednostek.
- **Tryb ręczny robota** – sterowanie osiami (Jog osiowy i kartezjański) oraz powrót do
  pozycji domowej.
- **Bezpieczeństwo** – monitoring przestrzeni roboczej (Workspace/Safespace), obsługa
  E-STOP i wznowienie gry po zresetowaniu układu Safety bez restartu maszyny.
- **Usługi mapp** – alarmy (AlarmX), zapis/wczytanie rozgrywki (Recipe), rejestr zdarzeń
  (Audit), zarządzanie użytkownikami (UserX).

## Jak to działa

Jeden ruch przebiega w trzech krokach:

1. **Gracz wybiera ruch** na ekranie – system dopuszcza tylko ruchy zgodne z zasadami.
2. **Kamera sprawdza** planszę – wykonuje zdjęcie i porównuje ułożenie pionków z modelem gry.
3. **Robot wykonuje ruch** – podnosi pionek, przenosi go na nowe pole, a zbite pionki
   odkłada do bufora obok planszy.

## Architektura oprogramowania

Aplikacja jest modularna – każda funkcjonalność to osobny task, a wymiana danych odbywa
się przez zmienne globalne oraz struktury interfejsowe (`gMotionInterface`, `gCameraCtrl`).

| Task | Klasa zadań | Rola |
|------|-------------|------|
| `MotionCtrl` | Cyclic #1 | Maszyna stanów robota: bazowanie, tryb ręczny, wykonywanie ruchów |
| `MainProgram` | Cyclic #4 | Główna maszyna stanów rozgrywki (weryfikacja planszy, sterowanie krokami) |
| `camera` | Cyclic #4 | Akwizycja obrazu i mapowanie pozycji pionków na pola szachownicy |
| `CheckVision` | Cyclic #4 | Porównanie planszy z kamery z logicznym stanem gry |
| `PositionInfo` | Cyclic #4 | Odczyt pozycji osi/TCP, monitoring przestrzeni roboczej |
| `GameStats` | Cyclic #4 | Detekcja ruchów, historia, liczniki zbitych pionków, audyt |
| `SaveGame` | Cyclic #4 | Zapis i wczytanie stanu gry (mapp Recipe) |
| `AlarmHistory` | Cyclic #4 | Historia alarmów i jej eksport (mapp AlarmX) |
| `FolderMng` | Cyclic #4 | Weryfikacja i tworzenie struktury katalogów na dysku USER |
| `VisVariable` | Cyclic #4 | Zmienne powiązane z wizualizacją |

Sekwencje ruchu robota napisano w języku **Structured Text (ST Motion)** – `move.st`
(przeniesienie pionka z bezpiecznym najazdem pionowym) oraz `gohome.st` (powrót do
pozycji startowej).

## Platforma sprzętowa

| Moduł | Typ | Funkcja |
|-------|-----|---------|
| 5APC3100.KBU1-000 | PC panelowy / PLC | Jednostka centralna, runtime ARemb, serwer wizualizacji |
| Comau Racer 3 | Robot 6-osiowy | Fizyczne przenoszenie pionków |
| VSS112Q22.042P-000 | Kamera mappVision | Rozpoznawanie pionków |
| 5AC901.IPLK-00 | Interfejs POWERLINK | Komunikacja z napędami |
| X20 (BC0083, DI9371, DO9322, PS9400, …) | Moduły I/O | Sygnały cyfrowe (Safety, chwytak magnetyczny) |

## Stos technologiczny

- **Automation Studio** 6.7.0
- **mappMotion** 6.7.2 (XT) · **mappView** 6.7.0 · **mappVision** 6.7.0 · **mappServices** 6.7.1
- **OPC UA** (OpcUaCs) 6.7.0
- Automation Runtime embedded (ARemb)

## Struktura repozytorium

```
Warcbot/
├── Logical/                 # Warstwa logiczna (programy, typy, biblioteki, mapp View)
│   ├── Programs/            # Taski ST: MainProgram, camera, CheckVision, Motion, GameStats, SaveGame, ...
│   ├── Libraries/           # Biblioteki mapp i systemowe
│   ├── mappView/            # Zasoby wizualizacji (media, teksty, motywy)
│   ├── Global.typ / .var    # Globalne typy i zmienne
├── Physical/                # Konfiguracja sprzętowa (HW, sieci, mappMotion, mappVision, role)
├── Robot-programy/          # Programy ST Motion (move.st, gohome.st)
├── SceneViewer/             # Model symulacyjny stanowiska (Scene Viewer)
├── warcabot.apj             # Plik projektu Automation Studio
└── LICENSE
```

## Uruchomienie

1. Zainstaluj **Automation Studio 6.7** wraz z pakietami mapp (Motion 6.7 XT, View, Vision, Services).
2. Otwórz plik projektu `warcabot.apj`.
3. Zbuduj konfigurację i wgraj oprogramowanie na sterownik (lub uruchom w symulacji).
4. Przed testami na robocie fizycznym zweryfikuj ruchy na modelu w **Scene Viewer**.
5. Wizualizacja mapp View dostępna jest w przeglądarce pod adresem sterownika.

> Uwaga: po restarcie zasilania robot wymaga bazowania (Restore Position lub bazowanie
> serwisowe wg markerów) – patrz dokumentacja techniczna.

## Dokumentacja

- `Warcabot_Dokumentacja_Techniczna.docx` – pełny opis techniczny oprogramowania.
- `Warcabot_Prezentacja.pptx` – ogólna prezentacja projektu.

## Status projektu

Projekt w rozwoju. Elementy przewidziane do dokończenia: integracja logiki gry z ruchem
robota w stanach `GameMove`/`RobotMove`, aktywacja chwytaka magnetycznego w `move.st`,
raporty po rozgrywce (mapp Report) oraz rozszerzenia cyberbezpieczeństwa.

## Licencja

Projekt udostępniony na licencji **GNU GPL v3** – szczegóły w pliku [LICENSE](LICENSE).
