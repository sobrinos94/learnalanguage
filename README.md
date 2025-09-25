# learnalanguage

🧭 Hoog-over stappenplan: van lege repo tot APK op je mobiel

Hieronder zie je het volledige proces, logisch opgeknipt in 6 duidelijke fasen.

🚀 Fase 1 — Setup & Structuur

Doel: Repo opzetten met juiste mappen, bestanden en Flutter config.

Maak de repo leanralanguage ✅

Genereer de mappenstructuur via bash (zoals we net deden) ✅

Voeg pubspec.yaml toe (Flutter configbestand)

Zet basisdependencies erin (zoals flutter, evt. google_fonts, hive, etc.)

Run lokaal flutter pub get om alles te installeren

🧪 Fase 2 — Testen op één scherm (zoals Streamlit)

Doel: Eén werkend testscherm maken om de logica te valideren

Bouw een simpel HomeScreen met 1 woord op het scherm

Voeg een dropdown toe om modus te kiezen (in je hoofd / meerkeuze / typen)

Voeg testknoppen toe om interactie te simuleren (bijv. goed/fout)

Toon "antwoord" nadat je interactie hebt gehad

Vergelijkbaar met een Streamlit MVP-pagina.
Dit is je eerste echte testbare scherm.

🧠 Fase 3 — Woordlogica bouwen (model + service)

Doel: Je 2000 woorden klaarzetten in de app en kunnen ophalen

Maak word.dart model aan

Maak word_service.dart die woorden leest uit woordenlijst.csv (bijv. met csv-package of hardcoded json voor nu)

Toon een random woord uit lijst op het scherm

Bouw filters op thema / niveau / type woord

🎮 Fase 4 — Drie oefenmodi bouwen

Doel: Functionaliteit bouwen van de drie leermethoden

✳️ Modus 1: In je hoofd

Toon woord → druk op knop “Ik weet het” → toon antwoord → kies goed/fout

🅰️ Modus 2: Meerkeuze

Toon vraag met 6 foute antwoorden + 1 juiste → aanklikken → feedback

🔡 Modus 3: Typen

Toon vraag → gebruiker typt → controleer antwoord → feedback

⚠️ Tip: bouw 1 per keer, test ze als losse widget

📊 Fase 5 — Scores, herhaling en instellingen

Doel: Basis van gamification en reviewlogica

Houd score bij (aantal goed/fout)

Sla per woord de performance op (bijv. in hive of shared_preferences)

Bouw een eindscherm met feedback en een optie om "foute woorden te herhalen"

Voeg begininstellingen toe: moduskeuze, niveau, type woorden

📱 Fase 6 — APK bouwen en downloaden

Doel: De app draaien op jouw mobiel

Zorg dat je flutter lokaal goed geïnstalleerd hebt (met Android SDK)

Run:

flutter build apk


→ Je krijgt dan een .apk in build/app/outputs/flutter-apk/app-release.apk

Zet APK op je mobiel via Google Drive, AirDrop, of mail

Installeer via "onbekende bronnen toestaan"

⚡️ BONUS: Lokaal testen als MVP (zoals bij Streamlit)

Je kunt via Flutter snel testen op je laptop of mobiel, vergelijkbaar met hoe je bij Streamlit in de browser testte:

flutter run


Start de app direct op simulator/emulator/verbonden device

Elke keer als je opslaat, zie je Hot Reload — wijzigingen direct zichtbaar