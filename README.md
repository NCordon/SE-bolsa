# Stock market expert system

## Description

Expert System implemented in CLIPS that makes proposals about Ibex35 market investments. Made for the subject 'Ingeniería del conocimiento', UGR, Granada. The system needs closing values of the market ([Analisis.txt](./data/Noticias.txt), [AnalisisSectores.txt](./data/AnalisisSectores.txt)), the user's stock portfolio ([Cartera.txt](./data/Cartera.txt)) and a relation of news relative to the enterprises of Ibex35 ([Noticias.txt](./data/Noticias.txt))

## Requirements

* CLIPS to use the system
* Latex to compile `memoria.tex`
* Python2 to execute `bin` files.

## License

GPL licensed.

## Usage

The data from the Ibex35 market can be obtained with `scrapeo.py` available in [bin](./bin) folder. This program scraps data from several webs to the file `Analisis.txt` and `AnalisisSectores.txt` in [data](./data) folder. Further documentation about the values scraped and format of the input files to the system can be consulted in [memoria](./memoria.tex), available only in Spanish.

To launch the system, make, in [clp](./clp):

```
clips
(load main.clp)
(reset)
(run)
```

[old](./old) contains previous files that correspond to exercises to get knowledge of CLIPS syntax.
