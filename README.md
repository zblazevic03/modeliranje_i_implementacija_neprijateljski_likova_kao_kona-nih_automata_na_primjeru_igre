# 🎮 City Siege – 3D shooter s neprijateljima upravljanim konačnim automatima

**Završni rad:** Modeliranje i implementacija neprijateljskih likova kao konačnih automata na primjeru igre žanra 3D shooter

**Autor:** Zdravko Blažević  
**Ustanova:** Sveučilište u Zagrebu, Fakultet organizacije i informatike (FOI), Varaždin  
**Studij:** Informacijske tehnologije i digitalizacija poslovanja  
**Godina:** 2024.

## 📖 O završnom radu

**City Siege** je 3D pucačka igra iz prvog lica (FPS), izrađena kao praktični dio završnog rada. Glavni cilj projekta bio je pokazati kako se **konačni automati (Finite State Machines – FSM)** mogu primijeniti za upravljanje ponašanjem neprijateljskih likova u videoigrama.

Igrač istražuje urbano okruženje, prikuplja oružje i municiju te se bori protiv neprijatelja koji reagiraju na njegovu prisutnost. Ponašanje neprijatelja temelji se na jasno definiranim stanjima i uvjetima prijelaza između njih.

## 🛠️ Korištene tehnologije i alati

| Tehnologija / alat | Namjena |
|---|---|
| **Godot Engine** | Razvoj i implementacija 3D igre |
| **GDScript** | Programska logika, mehanike igre i FSM neprijatelja |
| **Blender** | Prilagodba animacija 3D likova |
| **Cyclops Level Builder** | Izrada urbanog okruženja i mape |
| **Mixamo** | Model i animacije neprijateljskog lika |
| **Kenney, Itch.io, Pixabay** | Dodatni grafički, 3D i zvučni resursi |

## ⚙️ Funkcionalnosti igre

- Slobodno kretanje u 3D okruženju iz perspektive prvog lica, uključujući trčanje i čučanje.
- Korištenje više vrsta oružja, njihova izmjena i odbacivanje.
- Pucanje, ponovno punjenje i upravljanje zalihama streljiva.
- Prikupljanje novih oružja i dodatne municije.
- Sustav zdravlja igrača i nanošenja štete.
- Neprijatelji koji otkrivaju igrača, kreću se okruženjem i napadaju projektilima.
- Prikaz trenutačnog oružja, dostupne municije, arsenala i zdravlja na korisničkom sučelju.

## 🧠 Umjetna inteligencija neprijatelja – FSM

Središnji dio projekta je implementacija **konačnog automata** koji određuje ponašanje neprijatelja kroz tri stanja:

| Stanje | Ponašanje |
|---|---|
| `IDLE` | Neprijatelj miruje i nakon određenog vremena prelazi u lutanje. |
| `ROAM` | Neprijatelj se kreće prema nasumično odabranoj lokaciji. Po dolasku do cilja vraća se u čekanje. |
| `ATTACK` | Nakon otkrivanja igrača neprijatelj se zaustavlja i ispaljuje projektile prema njemu. |

Kada neprijatelj tijekom čekanja ili lutanja otkrije igrača, prelazi u stanje `ATTACK`. Ako izgubi igrača iz vidokruga, vraća se u stanje `ROAM`.

Takva organizacija ponašanja omogućuje pregledno definiranje reakcija neprijateljskih likova na događaje u igri, bez potrebe za složenijim sustavom odlučivanja.

## 🎯 Kontrole

| Tipka / kontrola | Radnja |
|---|---|
| `W`, `A`, `S`, `D` | Kretanje |
| Miš | Usmjeravanje pogleda |
| Lijeva tipka miša | Pucanje |
| Kotačić miša | Promjena oružja |
| `R` | Ponovno punjenje |
| `Q` | Odbacivanje oružja |
| `Shift` | Trčanje |
| `Ctrl` | Čučanje / puzanje |
| `Esc` | Izlazak iz igre |

## 📂 Pokretanje projekta

Projekt je izrađen u **Godot Engineu**. Za pregled i pokretanje izvornog projekta potrebno je otvoriti njegovu datoteku `project.godot` u odgovarajućoj verziji Godota, ako je ta datoteka uključena u repozitorij.

> Napomena: točna verzija Godota i eventualne dodatne upute za pokretanje nisu navedene u završnom radu.

## 📄 Dokumentacija

Cjeloviti završni rad dostupan je u službenom repozitoriju Fakulteta organizacije i informatike:

**[Modeliranje i implementacija neprijateljskih likova kao konačnih automata na primjeru igre žanra 3D shooter (2024.)](https://urn.nsk.hr/urn:nbn:hr:211:187922)**

Rad obuhvaća teorijsku podlogu konačnih automata, razvoj umjetne inteligencije u igrama te implementaciju i prikaz funkcionalnosti igre *City Siege*.

## ℹ️ Napomena o resursima

Projekt koristi i resurse trećih strana (modele, teksture, animacije i zvukove). Prava i uvjeti korištenja tih resursa ovise o njihovim izvornim licencijama. Njihova prisutnost u projektu ne znači da su svi obuhvaćeni istom licencijom kao završni rad.
