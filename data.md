# Data, Preprocessing, and Sources

## Data Sources
The data for the stars, their locations, their spectral types, and other information comes from [the Augmented Tycho - HYG (AT-HYG) dataset](https://github.com/astronexus/ATHYG-Database/tree/main/data/subsets). The majority of the stars seen in this visualization are from the HIPPARCOS dataset specifically. 

Constellation shapes and skycultures are from [Stellarium](https://github.com/Stellarium/stellarium/tree/master/skycultures/modern).

Exoplanet data was taken from [NASA's Exoplanet Archive](https://exoplanetarchive.ipac.caltech.edu/cgi-bin/TblView/nph-tblView?app=ExoTbls&config=PS)

## Pre-Processing 
Preprocessing for the data was done in R. You can access the R scripts [here](https://github.com/halBRY/CS528-Docs/tree/main/DataPreprocessing). Generally, the following processing was done:
* Remove unnessecary rows so that only (hip, dist, absmag, mag, x0, y0, z0, spect, vx, vy, vz) are used. 
* Drop stars without a spectral type, (x,y,z) coordinate, or (vx,vy,vz), as these values are necessary for the visualization
* Add the exoplanet data, joining by hip ID. 

* Create a "constellations.txt" file that replaces the hip IDs in from Stellarium's constalltion data with the (x,y,z) coordinates and (vx,vy,vz) values. 
    * In these files, each row is a constellation, and each star in that constellation is separated by a space. 

The processed data files are placed in the Unity project in the `/Assets/Resources` folder. 
* The full set of stars is foud in the `athyg_v31_cleaned_exo_all_stars.csv` file
* Each constellation set has a `constellationship_<set_name>.txt` and `names\<set_name>_constellation_names.txt` file associated to the get the links and names of each constellation in that set. 

## Processing
There are several operations performed in the Unity application for data handling. 

1. Scale
    * The (x,y,z) and (vx,vy,vz) are initially given in parsecs. These are read into Unity 1:1. Unity units default to meters, so, in the shader program, all vertex values are multiplied by a scaling factor of `0.30479999024` to convert from meters/parsecs to feet. 
    * The velocity of each star is given in km/sec. This value is converted in the shader program to parsec/year by multiplying by `0.00000102269`.

2. Color
    * The spectral type color scale mostly follows the [Harvard spectral classification]( https://en.wikipedia.org/wiki/Stellar_classification), with some notable expections. 
        * White Dwarfs, noted in the HIPPARCOS dataset as "D", are drawn in the same color as type O stars, but with a solar radius of `0.1`.
        * Subdwarfs, noted in the HIPPARCOS dataset as "s", are grouped with spectral type G.
        * Cool Giants are, noted in the HIPPARCOS dataset as "R", "N", and "S", are grouped with spectral type M.
        * Carbon stars and red giants are given the new classifcation "C". 
        * Wolf-Rayet stars, noted in the HIPPARCOS dataset as "W", are grouped with spectral type O.
        * Peculiar objects, including unique stars, some nebulae, and some galaxies, are given the spectal type P. 
    * All stars are given a static size based on this spectral classification. 

![Spectral Type Color Scale](data_2_spect.png)

3. Constellations
    * Some constellations are made of stars that are missing data in the HIPPARCOS dataset. In these cases, the line from the constellation that is missing one or more stars is omitted. 

4. Exoplanet colors
    * Stars without exoplanets in the archive are shown in dark gray. 
    * The number of discovered exoplanets for each star is shown with an increasingly bright color, with the maximum number, 6, shown in bright yellow. 

![Exoplanet Color Scale](data_1_exo.png)

## Other Sources

### Big Dipper Highlight 
* Korean 
    * [The Big Dipper from KBS World](https://world.kbs.co.kr/service/contents_view.htm?lang=e&menu_cate=culture&id=&board_seq=43574)
    * [Historical Astronomy of Korea from the Korea Astronomy Olympiad](https://www.kasolym.org:449/english/sub05/01_1.asp)
    * [Archived World Beat: Astronomy in Bloom](https://web.archive.org/web/20060521052817/http://www.astrosociety.org/pubs/mercury/9903/korea.html)
* Arabic
    * [Our Arabic Heritage in the Celestial Vault](https://muslimheritage.com/our-arabic-heritage-in-the-celestial-vault/)
* Chinese 
    * [Mandarin Mansion Antiques](https://www.mandarinmansion.com/glossary/beidou-beidou)
* Sami
    * [THE STARRY SKY IN SÁPMI](https://www.beneathnorthernlights.com/the-starry-sky-in-sapmi/)

### Art and Sound
* The background skybox is adapted from [Blender Space Skybox 11](https://www.deviantart.com/cosmicspark/art/Blender-Space-Skybox-11-865291182) created by DeviantArt user cosmicspark
* The music is from user kevp888 on [freesound.org](https://freesound.org/people/kevp888/sounds/512054/)
* The font, Century Gothic, was provided by [this github repo](https://github.com/localizator/ukrainian-fonts-pack/blob/master/CenturyGothic%20-%20Century%20Gothic%20-%20Regular.ttf)

### Code
* Though not used, the [PCX package](https://github.com/keijiro/Pcx) for Unity was referenced to understand shaders.

[App Features](app_usage.md) • [Data, Processing, and Sources](data.md) • [Code](code_and_build_instructions.md) • [Development Details](dev_details.md) • [Optimization Details](optimizations.md)
