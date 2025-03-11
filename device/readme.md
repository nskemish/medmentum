# Projektna dokumentacija za uređaj

Ovaj folder sadrži sve fajlove i dokumentaciju vezanu za razvoj uređaja, uključujući hardverske komponente, mehanički dizajn i firmware.

## Struktura foldera

- **/hw**: Sadrži sve fajlove vezane za hardverski dizajn uređaja.
	- `$d/` - Folder sa simbolima, otiscima i 3D modelima.
	- `$bk/` - Folder sa rezervnim kopijama fajlova.
	- `$ds/` - Folder sa tehničkim dokumentacijama komponenti.
	- `$pr/` - Folder sa projektnim fajlovima.

- **/mh**: Sadrži fajlove vezane za mehanički dizajn uređaja.
  - `step/` - Modeli mehaničkih dijelova.
  - `elev/` - Kote dimenzija modela
  - `stl/` - STL fajlovi za 3D štampu.

- **/fw**: Sadrži izvorni kod i dokumentaciju za firmware uređaja.
  - `src/` - Izvorni kod firmware-a.
    - `main.c` - Glavni programski kod.
    - `drivers/` - Drajveri za periferije.
  - `README.md` - Dokumentacija specifična za firmware.
  - `build/` - Kompajlirani fajlovi (opciono).

## Kako koristiti ovaj folder

1. **Hardver**: Za pregled shematskih dijagrama i PCB dizajna, otvorite odgovarajuće fajlove u **`/hw`** folderu. Gerber fajlovi se mogu koristiti za naručivanje PCB-a.
> ![NOTE]
>Za otvaranje ovih fajlova potrebno je imati najnoviju verziju [KiCad-a](https://www.kicad.org/).

3. **Mehanika**: 3D modeli i 2D crteži se nalaze u **`/mh`** folderu. STL fajlovi su spremni za 3D štampu.

4. **Firmware**: Izvorni kod firmware-a se nalazi u **`/fw/src`** folderu. Pratite uputstva u `readme.md` za kompilaciju i upload firmware-a na uređaj.

## Kontakt

Za sva pitanja ili dodatne informacije, kontaktirajte:

- **Ime Prezime**  
  Email: heyognjen@icloud.com  
  Telefon: +381 63 532178

---
>![WARNING]
>Ova dokumentacija je u razvoju i može biti ažurirana tokom projekta.
