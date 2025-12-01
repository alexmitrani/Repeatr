# Attendance data

Attendance data

## Usage

``` r
attendancedata
```

## Format

dataframe with one row for each show for which attendance was recorded
in the Fugazi Live Series data.

- year:

  Year of the show

- date:

  Date of the show

- venue:

  Venue of the show

- attendance:

  Estimated attendance

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  attendancedata
#>     year       date                                             venue
#> 1   1987 1987-09-03                                     Wilson Center
#> 2   1987 1987-09-26                    St. Stephen's Church Cafeteria
#> 3   1987 1987-09-27                                      Cat's Cradle
#> 4   1987 1987-10-07                                      New Horizons
#> 5   1987 1987-10-16                                          dc space
#> 6   1987 1987-12-02                                   BCC High School
#> 7   1987 1987-12-03                                     Wilson Center
#> 8   1987 1987-12-04                Wesleyan University Eclectic House
#> 9   1987 1987-12-05                                           Anthrax
#> 10  1987 1987-12-28                                          dc space
#> 11  1988 1988-02-06                                  Unitarian Church
#> 12  1988 1988-02-20                       Merrifield Community Center
#> 13  1988 1988-03-03                                     Wilson Center
#> 14  1988 1988-03-25                               Columbia University
#> 15  1988 1988-03-30                                          dc space
#> 16  1988 1988-04-09             Montgomery College Fine Arts Building
#> 17  1988 1988-04-15                Wesleyan University Eclectic House
#> 18  1988 1988-04-16                              Green Street Station
#> 19  1988 1988-04-17                                            Rocket
#> 20  1988 1988-04-28                                      New Horizons
#> 21  1988 1988-05-05           Oberlin University Student Union Tavern
#> 22  1988 1988-05-06                                         Dry House
#> 23  1988 1988-05-07                       Thunderdrone Sports Complex
#> 24  1988 1988-05-08                                     Club Dreamerz
#> 25  1988 1988-05-12                                   Sundance Saloon
#> 26  1988 1988-05-13                                          123 Arts
#> 27  1988 1988-05-15                    Tacoma Community World Theater
#> 28  1988 1988-05-16                              Evergreen University
#> 29  1988 1988-05-21                                       Zed Records
#> 30  1988 1988-05-24                                    Park Place BBQ
#> 31  1988 1988-05-28                                     Liberty Lunch
#> 32  1988 1988-05-29                                      Honest Place
#> 33  1988 1988-06-03                                           40 Watt
#> 34  1988 1988-06-04                       First Existentialist Church
#> 35  1988 1988-06-05                                      Cat's Cradle
#> 36  1988 1988-06-15                                         9:30 Club
#> 37  1988 1988-06-30                                         Maxwell's
#> 38  1988 1988-07-16                                     Beach Theater
#> 39  1988 1988-07-28                                     Wilson Center
#> 40  1988 1988-08-01                                          dc space
#> 41  1988 1988-08-07                                              YMCA
#> 42  1988 1988-10-06                                         9:30 Club
#> 43  1988 1988-11-08                                  Provitreff House
#> 44  1988 1988-12-29                                     Wilson Center
#> 45  1989 1989-01-26                                         9:30 Club
#> 46  1989 1989-03-24                                     Wilson Center
#> 47  1989 1989-04-05                                 NYU Student Union
#> 48  1989 1989-04-06            Princeton University Terrace Food Club
#> 49  1989 1989-04-07                                           Anthrax
#> 50  1989 1989-04-09                                         Maxwell's
#> 51  1989 1989-04-28                                         Dry House
#> 52  1989 1989-04-30                                      New Horizons
#> 53  1989 1989-05-01                                      Cat's Cradle
#> 54  1989 1989-05-02                                    Dance Graphics
#> 55  1989 1989-05-03                                           40 Watt
#> 56  1989 1989-05-05                                    Excelsior Mill
#> 57  1989 1989-05-06                              American Legion Hall
#> 58  1989 1989-05-09                                      Haricots BBQ
#> 59  1989 1989-05-11                                              Axis
#> 60  1989 1989-05-12                                             Axiom
#> 61  1989 1989-05-13                                     Liberty Lunch
#> 62  1989 1989-05-16                                  Time Out of Mind
#> 63  1989 1989-05-18                                         Anti-Club
#> 64  1989 1989-05-20                                     Gilman Street
#> 65  1989 1989-05-21                                  Women's Building
#> 66  1989 1989-05-26                                      Rignall Hall
#> 67  1989 1989-05-27                       Washington Performance Hall
#> 68  1989 1989-06-01                                          Speedway
#> 69  1989 1989-06-03                                Radial Social Hall
#> 70  1989 1989-06-04                                          Outhouse
#> 71  1989 1989-06-05                                     Bernard's Pub
#> 72  1989 1989-06-07                                  Latzer Hall YMCA
#> 73  1989 1989-06-08                                          VFW Hall
#> 74  1989 1989-06-09                                    Crystal Palace
#> 75  1989 1989-06-10                                     Club Dreamerz
#> 76  1989 1989-06-11                                  7th Street Entry
#> 77  1989 1989-06-12                                       Kutska Hall
#> 78  1989 1989-06-14                            Tam O'Shanter Ice Rink
#> 79  1989 1989-06-15                                Phantasy Nightclub
#> 80  1989 1989-06-16                                      Sonic Temple
#> 81  1989 1989-06-22                                     Wilson Center
#> 82  1989 1989-07-19                                         9:30 Club
#> 83  1989 1989-07-20                                         9:30 Club
#> 84  1989 1989-08-28                                         Fort Reno
#> 85  1989 1989-09-22                      All Souls Church Pierce Hall
#> 86  1989 1989-09-23                                 Drexel University
#> 87  1989 1989-09-24                                         Chameleon
#> 88  1989 1989-09-25                                Rutgers University
#> 89  1989 1989-09-26                                      Eagles Lodge
#> 90  1989 1989-09-29                            Glebe Community Center
#> 91  1989 1989-09-30                                              Loft
#> 92  1989 1989-10-01                                    Rivoli Theater
#> 93  1989 1989-10-02                                       Backstreets
#> 94  1989 1989-10-04                                          242 Main
#> 95  1989 1989-10-05                                       Living Room
#> 96  1989 1989-10-06                       First Congregational Church
#> 97  1989 1989-10-07                                           Anthrax
#> 98  1989 1989-10-08                                         Maxwell's
#> 99  1989 1989-10-09                         Barnard College Cafeteria
#> 100 1989 1989-11-03                                        Vranckrijk
#> 101 1989 1989-11-13                                      Arts College
#> 102 1989 1989-11-14                                          Zap Club
#> 103 1989 1989-11-15                            Portsmouth Polytechnic
#> 104 1989 1989-11-16                                 Exeter University
#> 105 1989 1989-11-19                                       Edward's #8
#> 106 1989 1989-11-20                                 Leeds Polytechnic
#> 107 1989 1989-11-21                              Marcus Garvey Centre
#> 108 1989 1989-11-22                                        Bierkeller
#> 109 1989 1989-11-23                                        McGonagles
#> 110 1989 1989-11-24                                       Arts Centre
#> 111 1989 1989-11-25                                  Bluecoat Chamber
#> 112 1989 1989-11-26                                         Riverside
#> 113 1989 1989-11-27                                           Mayfair
#> 114 1989 1989-11-28                                         Boardwalk
#> 115 1989 1989-11-29                                       Boston Arms
#> 116 1989 1989-12-02                                        Markthalle
#> 117 1989 1989-12-03                                             Menza
#> 118 1989 1989-12-04                                             Mensa
#> 119 1989 1989-12-05                                     Theaterfabrik
#> 120 1989 1989-12-06                                               AJZ
#> 121 1990 1990-01-27                       St. Augustine's Church Hall
#> 122 1990 1990-02-11                                         Studio 10
#> 123 1990 1990-02-16                                   Weinberg Center
#> 124 1990 1990-02-25                                             Metro
#> 125 1990 1990-03-08                                    Citadel Center
#> 126 1990 1990-03-10                               Atlantic Beach Club
#> 127 1990 1990-03-11                          James Madison University
#> 128 1990 1990-03-12                Sternberger Hall, Guilford College
#> 129 1990 1990-03-13                                 Forefounders Hall
#> 130 1990 1990-03-14                                           40 Watt
#> 131 1990 1990-03-15                                        Masquerade
#> 132 1990 1990-03-16                              American Legion Hall
#> 133 1990 1990-03-17                                   Beacham Theater
#> 134 1990 1990-03-19                                          Nite Owl
#> 135 1990 1990-03-20                 Univ. of S. MS Bennett Auditorium
#> 136 1990 1990-03-21                                        Storyville
#> 137 1990 1990-03-23                                   Elliston Square
#> 138 1990 1990-03-24                          Backstage at the Library
#> 139 1990 1990-03-25                                      Cat's Cradle
#> 140 1990 1990-04-13                                    Vassar College
#> 141 1990 1990-04-14                             Pearl Street Ballroom
#> 142 1990 1990-04-20                                Mass Art Gymnasium
#> 143 1990 1990-04-21                     Rhode Island School of Design
#> 144 1990 1990-04-27                          Atholton High School Gym
#> 145 1990 1990-05-02                                     Antennae Club
#> 146 1990 1990-05-03                                        Mandrake's
#> 147 1990 1990-05-04                             2301 Canton Warehouse
#> 148 1990 1990-05-05                                     Liberty Lunch
#> 149 1990 1990-05-06                                             Axiom
#> 150 1990 1990-05-07                                     Cameo Theater
#> 151 1990 1990-05-11                                    Dodiak Gallery
#> 152 1990 1990-05-12                      U.A. Local Pipefitter's Hall
#> 153 1990 1990-05-15                                 La Paloma Theater
#> 154 1990 1990-05-16                                      Country Club
#> 155 1990 1990-05-17                                      Country Club
#> 156 1990 1990-05-18                              UC Santa Barbara Pub
#> 157 1990 1990-05-19                                   Russian Theater
#> 158 1990 1990-05-20                                     Gilman Street
#> 159 1990 1990-05-24                                        Burro Room
#> 160 1990 1990-05-25                             National Guard Armory
#> 161 1990 1990-05-26                                       W.O.W. Hall
#> 162 1990 1990-05-30                       Underground / 1414 Cornwell
#> 163 1990 1990-05-31                               Pine Street Theater
#> 164 1990 1990-06-01                            Lake City Concert Hall
#> 165 1990 1990-06-02                              Chambers Grange Hall
#> 166 1990 1990-06-04                                       Moose Lodge
#> 167 1990 1990-06-06                                          Speedway
#> 168 1990 1990-06-08                                    Atzlan Theater
#> 169 1990 1990-06-10                                        Sokol Hall
#> 170 1990 1990-06-11                                          Outhouse
#> 171 1990 1990-06-12                                        Studio 225
#> 172 1990 1990-06-13                                              1227
#> 173 1990 1990-06-14                                            Medusa
#> 174 1990 1990-06-15                              Waukesha Expo Center
#> 175 1990 1990-06-16                                    Avalon Theater
#> 176 1990 1990-06-18                                       Howard Haus
#> 177 1990 1990-06-19                                Neighborhood House
#> 178 1990 1990-06-21                                   Capitol Theater
#> 179 1990 1990-06-22                             St. Dominick's Church
#> 180 1990 1990-06-23                  University of Michigan Ballrooom
#> 181 1990 1990-06-24                                         Club Soda
#> 182 1990 1990-06-25                                Masonic Auditorium
#> 183 1990 1990-06-26                                  Kentucky Theater
#> 184 1990 1990-06-27                                Electrician's Hall
#> 185 1990 1990-06-28        Jackie Lee's Scooterz Entertainment Center
#> 186 1990 1990-06-29                                    Upstage Lounge
#> 187 1990 1990-06-30                                      Machine Shop
#> 188 1990 1990-07-06                       St. Augustine's Church Hall
#> 189 1990 1990-09-01                                             Troll
#> 190 1990 1990-09-03                                              Vera
#> 191 1990 1990-09-04                                          Paradiso
#> 192 1990 1990-09-05                                          Effenaar
#> 193 1990 1990-09-06                                 Agoara University
#> 194 1990 1990-09-10                                        Bierkellar
#> 195 1990 1990-09-11                     Liverpool Polytechnic Canteen
#> 196 1990 1990-09-12                                      Irish Centre
#> 197 1990 1990-09-13                              Marcus Garvey Centre
#> 198 1990 1990-09-14                                         Riverside
#> 199 1990 1990-09-15                                    Calton Studios
#> 200 1990 1990-09-16                               Belfast Art College
#> 201 1990 1990-09-17                                        McGonagles
#> 202 1990 1990-09-18                                          Goldwyns
#> 203 1990 1990-09-19                                  Kilburn National
#> 204 1990 1990-09-20                                       King's Hall
#> 205 1990 1990-09-22                                        De Bogaerd
#> 206 1990 1990-09-23                                           Netwerk
#> 207 1990 1990-09-25                                       Schlachthof
#> 208 1990 1990-09-26                                            Fabrik
#> 209 1990 1990-09-27                                      Ungdomshuset
#> 210 1990 1990-09-28                                             Blitz
#> 211 1990 1990-09-29                               Brigga Lillero Cafe
#> 212 1990 1990-09-30                                              UFFA
#> 213 1990 1990-10-01                                            Cafe Q
#> 214 1990 1990-10-02                                       Rock Lamour
#> 215 1990 1990-10-04                                        Sports Gym
#> 216 1990 1990-10-05                               Karuzela University
#> 217 1990 1990-10-06                 Cultural Center / Military Museum
#> 218 1990 1990-10-07                                         Neue Welt
#> 219 1990 1990-10-08                                             PC 69
#> 220 1990 1990-10-09                                          Glocksee
#> 221 1990 1990-10-10                                      Music Circus
#> 222 1990 1990-10-11                                       Rock Palace
#> 223 1990 1990-10-12                                         Eltzerhof
#> 224 1990 1990-10-13                               Altes Feuerwehrhaus
#> 225 1990 1990-10-14                                     Theaterfabrik
#> 226 1990 1990-10-16                                              Roxy
#> 227 1990 1990-10-17                                       Rote Fabrik
#> 228 1990 1990-10-18                                       Stadt Halle
#> 229 1990 1990-10-19                                       Schlachthof
#> 230 1990 1990-10-20                                             Arena
#> 231 1990 1990-10-21                         University Student Center
#> 232 1990 1990-10-22                                          Galleria
#> 233 1990 1990-10-24                                          Ala Rock
#> 234 1990 1990-10-25                                       Leoncavallo
#> 235 1990 1990-10-26                                          Fabrikka
#> 236 1990 1990-10-28                                      Macchia Nera
#> 237 1990 1990-10-29                                         Hiroshima
#> 238 1990 1990-10-30                                   Salle des Fetes
#> 239 1990 1990-11-01                                               KGB
#> 240 1990 1990-11-02                                        Club Jimmy
#> 241 1990 1990-11-03                                Le Confort Moderne
#> 242 1990 1990-11-04                                      Kergon Forte
#> 243 1990 1990-11-05                                     Espace Ornano
#> 244 1990 1990-11-07                                          Paradiso
#> 245 1990 1990-12-26                      Lorton Correctional Facility
#> 246 1991 1991-01-02                                         9:30 Club
#> 247 1991 1991-01-03                                         9:30 Club
#> 248 1991 1991-01-12                                    Lafayette Park
#> 249 1991 1991-02-15                          Sacred Heart Church Hall
#> 250 1991 1991-02-20                                          Twisters
#> 251 1991 1991-03-02                                 Drexel University
#> 252 1991 1991-03-03                                         Chameleon
#> 253 1991 1991-03-04                                           Marquee
#> 254 1991 1991-03-05                                           Marquee
#> 255 1991 1991-03-06                                         Maxwell's
#> 256 1991 1991-03-07                         University of Connecticut
#> 257 1991 1991-03-09                       University of Massachusetts
#> 258 1991 1991-03-10                                  Saratoga Winners
#> 259 1991 1991-03-11                             Buffalo State College
#> 260 1991 1991-03-12                               Syracuse University
#> 261 1991 1991-03-14                                        The Border
#> 262 1991 1991-03-15                                             Zootz
#> 263 1991 1991-03-16                                               WAG
#> 264 1991 1991-03-17                                           Channel
#> 265 1991 1991-03-18                                  Church House Inn
#> 266 1991 1991-03-19                                      City Gardens
#> 267 1991 1991-04-12                          Sacred Heart Church Hall
#> 268 1991 1991-04-20                               Columbia University
#> 269 1991 1991-05-01                             Peppermint Beach Club
#> 270 1991 1991-05-02                                     Miracle House
#> 271 1991 1991-05-03                                      Cat's Cradle
#> 272 1991 1991-05-04                                         Milestone
#> 273 1991 1991-05-05                                          Flamingo
#> 274 1991 1991-05-07                                           Cannery
#> 275 1991 1991-05-08                                Carriage House Inn
#> 276 1991 1991-05-10                                      Rockefella's
#> 277 1991 1991-05-11                                           40 Watt
#> 278 1991 1991-05-12                                        Masquerade
#> 279 1991 1991-05-13                                               Sun
#> 280 1991 1991-05-14                                          Milk Bar
#> 281 1991 1991-05-15                                              Ritz
#> 282 1991 1991-05-16                                     Cameo Theater
#> 283 1991 1991-05-17                                   Beacham Theater
#> 284 1991 1991-05-18                                   Club Demolition
#> 285 1991 1991-05-20                                          Nite Owl
#> 286 1991 1991-05-21                                   Tuxedo Junction
#> 287 1991 1991-05-22                                     Antennae Club
#> 288 1991 1991-05-23                                            Vino's
#> 289 1991 1991-05-24                                   Deep Ellum Live
#> 290 1991 1991-05-25                                     Liberty Lunch
#> 291 1991 1991-05-26                                            Homage
#> 292 1991 1991-05-30       Edmond Historical Society Preservation Hall
#> 293 1991 1991-05-31                     University of Kansas Ballroom
#> 294 1991 1991-06-01                                        Studio 225
#> 295 1991 1991-06-02                                     Chestnut Hall
#> 296 1991 1991-06-03                                         Blue Note
#> 297 1991 1991-06-04                                Mississippi Nights
#> 298 1991 1991-06-06                                  Latzer Hall YMCA
#> 299 1991 1991-06-07                                   Ritz Music Hall
#> 300 1991 1991-06-08                                         Tewligans
#> 301 1991 1991-06-09                                         Wrocklage
#> 302 1991 1991-06-10                                          Bogart's
#> 303 1991 1991-06-11                                Electrician's Hall
#> 304 1991 1991-06-12                                           Newport
#> 305 1991 1991-06-13                                           Flash's
#> 306 1991 1991-06-14                                          Metropol
#> 307 1991 1991-06-17                          Sacred Heart Church Hall
#> 308 1991 1991-08-02                                    Rialto Theatre
#> 309 1991 1991-08-03                                       Barrymore's
#> 310 1991 1991-08-04                                       Opera House
#> 311 1991 1991-08-05                                  Majestic Theater
#> 312 1991 1991-08-06                                     State Theater
#> 313 1991 1991-08-08                                       Vic Theater
#> 314 1991 1991-08-09                                       Turner Hall
#> 315 1991 1991-08-10                                      Central Park
#> 316 1991 1991-08-11                                        Wherehouse
#> 317 1991 1991-08-12                                      First Avenue
#> 318 1991 1991-08-13                                        Elks Lodge
#> 319 1991 1991-08-14                                      Duncan Arena
#> 320 1991 1991-08-15                                      College West
#> 321 1991 1991-08-17                                      MacEwan Hall
#> 322 1991 1991-08-19                  N. Van. Sports Arena Hockey Rink
#> 323 1991 1991-08-25                                   Capitol Theater
#> 324 1991 1991-08-26                                                OZ
#> 325 1991 1991-08-27                                   Melody Ballroom
#> 326 1991 1991-08-30                                   Phoenix Theater
#> 327 1991 1991-08-31                             Scottish Rites Temple
#> 328 1991 1991-09-01                                     Gilman Street
#> 329 1991 1991-09-03                                       One Edge Up
#> 330 1991 1991-09-04                          Knights of Columbus Hall
#> 331 1991 1991-09-05                                          Anaconda
#> 332 1991 1991-09-06                             Jawbone Canyon Desert
#> 333 1991 1991-09-08                               Hollywood Palladium
#> 334 1991 1991-09-09                                     Silver Dollar
#> 335 1991 1991-09-11                               Sunshine Music Hall
#> 336 1991 1991-09-13                                    Gothic Theater
#> 337 1991 1991-09-14            University of Nebraska Centennial Hall
#> 338 1991 1991-10-17                                Ukranian Town Hall
#> 339 1991 1991-10-18                                     Melbourne Uni
#> 340 1991 1991-10-19                                          The Hull
#> 341 1991 1991-10-20                                     Melbourne Uni
#> 342 1991 1991-10-22                                      Le Rox Hotel
#> 343 1991 1991-10-23                                        Youth Cafe
#> 344 1991 1991-10-25                                        Sydney Uni
#> 345 1991 1991-10-26                                Manly Youth Center
#> 346 1991 1991-10-27                                    Burland Centre
#> 347 1991 1991-11-01                                          Playroom
#> 348 1991 1991-11-02                                          Funkyard
#> 349 1991 1991-11-03                                      Arts Factory
#> 350 1991 1991-11-08                                      Powerstation
#> 351 1991 1991-11-11                                        Anti Knock
#> 352 1991 1991-11-12                                        Anti Knock
#> 353 1991 1991-11-14                                          Sun Hall
#> 354 1991 1991-11-18                              University of Hawaii
#> 355 1992 1992-01-24                               Hollywood Palladium
#> 356 1992 1992-01-25                               Hollywood Palladium
#> 357 1992 1992-04-06                                         Trocadero
#> 358 1992 1992-04-07                                         Maxwell's
#> 359 1992 1992-04-08                                              Ritz
#> 360 1992 1992-04-10                                Bennington College
#> 361 1992 1992-04-11                 Heart of the Commonwealth Theater
#> 362 1992 1992-04-12                              Father Hayes Gym Bar
#> 363 1992 1992-04-13                                           Rockbar
#> 364 1992 1992-04-14                                      City Gardens
#> 365 1992 1992-05-01                                          Paradiso
#> 366 1992 1992-05-04                                    Assembly Rooms
#> 367 1992 1992-05-05                                     Gayety Lounge
#> 368 1992 1992-05-06                                          Junction
#> 369 1992 1992-05-07                                        Waterfront
#> 370 1992 1992-05-08                            Nottingham Polytechnic
#> 371 1992 1992-05-09                                   Brixton Academy
#> 372 1992 1992-05-11                                               SFX
#> 373 1992 1992-05-12                   Queen's University Mandela Hall
#> 374 1992 1992-05-14                           Irish Centre Ardri Hall
#> 375 1992 1992-05-15                                         Riverside
#> 376 1992 1992-05-16                               Barrowland Ballroom
#> 377 1992 1992-05-17                                      Queen's Hall
#> 378 1992 1992-05-20                                              Vera
#> 379 1992 1992-05-21                                        William II
#> 380 1992 1992-05-22                                         Concordia
#> 381 1992 1992-05-23                                         Perron 55
#> 382 1992 1992-05-24                                             Paard
#> 383 1992 1992-05-26                                        Boterhalle
#> 384 1992 1992-05-27                                 Elysee Montmartre
#> 385 1992 1992-05-28                                      La Blaiserie
#> 386 1992 1992-05-29                                    Theatre Barbey
#> 387 1992 1992-05-30                                         Le Bikini
#> 388 1992 1992-05-31                                         Zeleste 2
#> 389 1992 1992-06-02                                          Revolver
#> 390 1992 1992-06-03                                          En Bruto
#> 391 1992 1992-06-05                                           Murazzi
#> 392 1992 1992-06-06                                      Macchia Nera
#> 393 1992 1992-06-07                                  Forte Prenestino
#> 394 1992 1992-06-08                                    Dancing Condor
#> 395 1992 1992-06-09                                       C.S.O Pedro
#> 396 1992 1992-06-10                            University Student Bar
#> 397 1992 1992-06-11                            Black Hole/Fekete Lyuk
#> 398 1992 1992-06-13                                              Roxy
#> 399 1992 1992-06-14                                             Arena
#> 400 1992 1992-06-15                                       Schlachthof
#> 401 1992 1992-06-16                                     Theaterfabrik
#> 402 1992 1992-06-17                              Transmitter Festival
#> 403 1992 1992-06-18                                       Rote Fabrik
#> 404 1992 1992-06-19                                  Hugenotten Halle
#> 405 1992 1992-06-20                               Stadthalle Langenau
#> 406 1992 1992-06-22                                              Komm
#> 407 1992 1992-06-23                                      Egelseehalle
#> 408 1992 1992-06-24                                            Canape
#> 409 1992 1992-06-25                                          Glocksee
#> 410 1992 1992-06-26                                           Eskulap
#> 411 1992 1992-06-28                                        Tempodrome
#> 412 1992 1992-06-29                                         Hyde Park
#> 413 1992 1992-06-30                                      Music Circus
#> 414 1992 1992-07-01                                          Rhenania
#> 415 1992 1992-07-02                                            Fabrik
#> 416 1992 1992-07-03                                       Schlachthof
#> 417 1992 1992-07-04                                      Ungdomshuset
#> 418 1992 1992-07-06                            Rockefeller Music Hall
#> 419 1992 1992-07-08                                            Cafe Q
#> 420 1992 1992-07-11                                       Doornroosje
#> 421 1992 1992-07-25                    US Capitol Plaza Supreme Court
#> 422 1993 1993-02-04                             Peppermint Beach Club
#> 423 1993 1993-02-05                                      Cat's Cradle
#> 424 1993 1993-02-06                                       Jacob's Run
#> 425 1993 1993-02-07                             National Guard Armory
#> 426 1993 1993-02-08                                 Thirteen Thirteen
#> 427 1993 1993-02-09                                        Masquerade
#> 428 1993 1993-02-10                                        Masquerade
#> 429 1993 1993-02-11                          Knights of Columbus Hall
#> 430 1993 1993-02-12                                            Club 5
#> 431 1993 1993-02-13                                              Edge
#> 432 1993 1993-02-14                                              Edge
#> 433 1993 1993-02-16                                              Ritz
#> 434 1993 1993-02-17                                   Florida Theater
#> 435 1993 1993-02-18                                           40 Watt
#> 436 1993 1993-02-19                                           40 Watt
#> 437 1993 1993-02-20                                         Trim Shop
#> 438 1993 1993-02-21                                         Floodzone
#> 439 1993 1993-04-02           University of Maryland Ritchie Coliseum
#> 440 1993 1993-04-04                                              Trax
#> 441 1993 1993-04-05                                 Electric Ballroom
#> 442 1993 1993-04-06                                   328 Performance
#> 443 1993 1993-04-07                                    Omni New Daisy
#> 444 1993 1993-04-08                                      Midnight Sun
#> 445 1993 1993-04-09                            New Orleans Music Hall
#> 446 1993 1993-04-10                                  Phoenix Ballroom
#> 447 1993 1993-04-11                              Stafford Opera House
#> 448 1993 1993-04-12                                     Liberty Lunch
#> 449 1993 1993-04-13                                     Liberty Lunch
#> 450 1993 1993-04-14                           Showcase Special Events
#> 451 1993 1993-04-16                                      Bomb Factory
#> 452 1993 1993-04-17                                 Hollywood Theater
#> 453 1993 1993-04-18                          19th st. Depot Warehouse
#> 454 1993 1993-04-19                                          Club 101
#> 455 1993 1993-04-20                                          Coyote's
#> 456 1993 1993-04-22                                 Huntridge Theater
#> 457 1993 1993-04-23                               Hollywood Palladium
#> 458 1993 1993-04-24                               Hollywood Palladium
#> 459 1993 1993-04-25                               Hollywood Palladium
#> 460 1993 1993-04-26                                              SOMA
#> 461 1993 1993-04-27                                          Anaconda
#> 462 1993 1993-04-28                           Veteran's Memorial Hall
#> 463 1993 1993-04-30                          UC Berkeley Sproul Plaza
#> 464 1993 1993-05-01                                 Fort Mason Pier C
#> 465 1993 1993-05-02                                     Crest Theater
#> 466 1993 1993-05-04                                       W.O.W. Hall
#> 467 1993 1993-05-05                                   Melody Ballroom
#> 468 1993 1993-05-06                                                Oz
#> 469 1993 1993-05-07                                  Plaza of Nations
#> 470 1993 1993-05-08                                   Capitol Theater
#> 471 1993 1993-05-09                                              YMCA
#> 472 1993 1993-05-14                                       Fairgrounds
#> 473 1993 1993-05-15            Boise State University Jordan Ballroom
#> 474 1993 1993-05-16                      Utah State Fairpark Coliseum
#> 475 1993 1993-05-18                             Mammoth Events Center
#> 476 1993 1993-05-19                    University of Wyoming Ballroom
#> 477 1993 1993-05-21                            Peony Park Royal Grove
#> 478 1993 1993-05-22                                      Hairy Mary's
#> 479 1993 1993-05-23                                      First Avenue
#> 480 1993 1993-05-24                                      First Avenue
#> 481 1993 1993-05-25                                      First Avenue
#> 482 1993 1993-05-26                                   Orpheum Theater
#> 483 1993 1993-05-28                                       Oak Theatre
#> 484 1993 1993-05-29                                       Oak Theatre
#> 485 1993 1993-05-30                                       City Lights
#> 486 1993 1993-05-31                                           Newport
#> 487 1993 1993-08-07                                    Sylvan Theater
#> 488 1993 1993-08-16                                         Maxwell's
#> 489 1993 1993-08-17                                      City Gardens
#> 490 1993 1993-08-18                                      City Gardens
#> 491 1993 1993-08-19                                          Decibels
#> 492 1993 1993-08-20                                          Metropol
#> 493 1993 1993-08-21                    Dayton Fest / Brookwood Island
#> 494 1993 1993-08-22                                          Bogart's
#> 495 1993 1993-08-24                      Southern Illinois University
#> 496 1993 1993-08-25                                Mississippi Nights
#> 497 1993 1993-08-26                                Mississippi Nights
#> 498 1993 1993-08-27                                         Blue Note
#> 499 1993 1993-08-28                                     Memorial Hall
#> 500 1993 1993-08-29                I.M.U. Lounge / University of Iowa
#> 501 1993 1993-09-01 Illinois State University Student Center Ballroom
#> 502 1993 1993-09-02                                  Eagle's Ballroom
#> 503 1993 1993-09-03                                   Aragon Ballroom
#> 504 1993 1993-09-04                         Phoenix Plaza Ampitheater
#> 505 1993 1993-09-05                                     Nautica Stage
#> 506 1993 1993-09-06                                     Blind Mellons
#> 507 1993 1993-09-08             Peter Clark Hall University of Guelph
#> 508 1993 1993-09-09                                     RPM Warehouse
#> 509 1993 1993-09-10                                     RPM Warehouse
#> 510 1993 1993-09-11                   Carleton University Porter Hall
#> 511 1993 1993-09-12                                        Metropolis
#> 512 1993 1993-09-13                                      Cook Commons
#> 513 1993 1993-09-14                                       58 Fore St.
#> 514 1993 1993-09-16                                Bennington College
#> 515 1993 1993-09-17                              Wallace Civic Center
#> 516 1993 1993-09-18              University of Connecticut Fieldhouse
#> 517 1993 1993-09-19                           Lupo's Heartbreak Hotel
#> 518 1993 1993-09-20                                   S.U.N.Y. Albany
#> 519 1993 1993-09-21                                      Lost Horizon
#> 520 1993 1993-09-22                               S.U.N.Y. Binghamton
#> 521 1993 1993-09-24                                 Roseland Ballroom
#> 522 1993 1993-09-25                                 Roseland Ballroom
#> 523 1993 1993-09-26                                    Penn State Hub
#> 524 1993 1993-09-27                                         Trocadero
#> 525 1993 1993-09-28                                         Trocadero
#> 526 1993 1993-09-29                                            Strand
#> 527 1993 1993-10-31                                           AM Hall
#> 528 1993 1993-11-01                                         Muse Hall
#> 529 1993 1993-11-03                                      Club Quattro
#> 530 1993 1993-11-05                                      Club Quattro
#> 531 1993 1993-11-06                                      Club Quattro
#> 532 1993 1993-11-08                      Bukit Batok Community Center
#> 533 1993 1993-11-10                                            Club O
#> 534 1993 1993-11-11                                   Dom Polski Hall
#> 535 1993 1993-11-12                                              EV's
#> 536 1993 1993-11-13                                          Wall St.
#> 537 1993 1993-11-14                             Collingwood Town Hall
#> 538 1993 1993-11-17                                        A.N.U. Bar
#> 539 1993 1993-11-18                                      Youth Centre
#> 540 1993 1993-11-19                                 Manly High School
#> 541 1993 1993-11-20                                  Sydney Town hall
#> 542 1993 1993-11-24                            Morrow Park Bowls Club
#> 543 1993 1993-11-26                                        Italo Club
#> 544 1993 1993-11-27                                   Boulder Gallery
#> 545 1993 1993-12-01                                   Uni Manning Bar
#> 546 1993 1993-12-03                                     Hellenic Hall
#> 547 1993 1993-12-04                        Windmill Hill War Memorial
#> 548 1993 1993-12-08                                   Caledonian Hall
#> 549 1993 1993-12-09                                           Sammy's
#> 550 1993 1993-12-10                                     Student Union
#> 551 1993 1993-12-11                                      Powerstation
#> 552 1993 1993-12-12                                      Powerstation
#> 553 1993 1993-12-14                                        After Dark
#> 554 1994 1994-06-03         Pirate House / Brendan's Going Away Party
#> 555 1994 1994-08-04                                         Fort Reno
#> 556 1994 1994-08-15         Belo Horizonte Independent Music Festival
#> 557 1994 1994-08-18                                      Circo Voador
#> 558 1994 1994-08-19                               Col. Leao XIII Hall
#> 559 1994 1994-08-20                                          Aeroanta
#> 560 1994 1994-08-21                                          Aeroanta
#> 561 1994 1994-08-25                                          92 Graus
#> 562 1994 1994-08-26                                          92 Graus
#> 563 1994 1994-08-27                                          92 Graus
#> 564 1994 1994-11-20                      Long Branch Community Center
#> 565 1994 1994-11-27                                         9:30 Club
#> 566 1994 1994-11-29                                         Black Cat
#> 567 1995 1995-03-02                  University of Maryland Baltimore
#> 568 1995 1995-04-01                                         Trocadero
#> 569 1995 1995-04-02                                         Trocadero
#> 570 1995 1995-04-03                                      Irving Plaza
#> 571 1995 1995-04-04                                      Irving Plaza
#> 572 1995 1995-04-05                                      Irving Plaza
#> 573 1995 1995-04-06                  Vassar College Walker Fieldhouse
#> 574 1995 1995-04-07                           West Indian Social Club
#> 575 1995 1995-04-08                      Sullivan Gym, U. of S. Maine
#> 576 1995 1995-04-11                           Lupo's Heartbreak Hotel
#> 577 1995 1995-04-12                           Lupo's Heartbreak Hotel
#> 578 1995 1995-04-13                                         Maxwell's
#> 579 1995 1995-04-14             University of Delaware Carpenter Hall
#> 580 1995 1995-05-04                                          Effenaar
#> 581 1995 1995-05-06             Sussex University Nelson Mandela Hall
#> 582 1995 1995-05-07                                           Academy
#> 583 1995 1995-05-08                               Barrowland Ballroom
#> 584 1995 1995-05-09                                      Queen's Hall
#> 585 1995 1995-05-10                                     Ormond Center
#> 586 1995 1995-05-12                                  Trent University
#> 587 1995 1995-05-13                                   Brixton Academy
#> 588 1995 1995-05-14                                      Wulfrun Hall
#> 589 1995 1995-05-15                           Metropolitan University
#> 590 1995 1995-05-17                                          Paradiso
#> 591 1995 1995-05-18                                              Lido
#> 592 1995 1995-05-19                                      Zaal Vooruit
#> 593 1995 1995-05-20                                         Le Pharos
#> 594 1995 1995-05-26                                    Theatre Barbey
#> 595 1995 1995-05-27                                      Sala Matraka
#> 596 1995 1995-05-28                                      Sala Antiquo
#> 597 1995 1995-05-29                                     Sala Numero K
#> 598 1995 1995-06-02                                          Revolver
#> 599 1995 1995-06-06                                         Le Bikini
#> 600 1995 1995-06-07                                          Mirabeau
#> 601 1995 1995-06-08                               Espace Jean Bargoin
#> 602 1995 1995-06-09                                       Rote Fabrik
#> 603 1995 1995-06-10                                   Salle Des Fetes
#> 604 1995 1995-06-12                                    Cascina Monlue
#> 605 1995 1995-06-13                                       C.S.O Pedro
#> 606 1995 1995-06-14                                               CPA
#> 607 1995 1995-06-15                    Parco Ex Ospedale Psichiatrico
#> 608 1995 1995-06-16             Kactus Radio Festival Castel Maggiore
#> 609 1995 1995-06-17                               Covo Dei Nottambuli
#> 610 1995 1995-06-18                        Porto Catania Outdoor Show
#> 611 1995 1995-06-20                                  Forte Prenestino
#> 612 1995 1995-06-21                                  Forte Del Chievo
#> 613 1995 1995-06-22                                           Rototom
#> 614 1995 1995-06-23                                       Sports Hall
#> 615 1995 1995-06-24                                             Arena
#> 616 1995 1995-06-25                                       Schlachthof
#> 617 1995 1995-06-26                                         Nachtwerk
#> 618 1995 1995-06-27                                              Roxy
#> 619 1995 1995-06-29                                              Roxy
#> 620 1995 1995-06-30                                     Hallschlag JZ
#> 621 1995 1995-07-01                                              Kuze
#> 622 1995 1995-07-02                                          TU Mensa
#> 623 1995 1995-07-03                                       Soundgarden
#> 624 1995 1995-07-04                                            Fabrik
#> 625 1995 1995-07-05                                       Doornroosje
#> 626 1995 1995-07-07                                              Vera
#> 627 1995 1995-07-08                                           JZ Kamp
#> 628 1995 1995-07-09                                       Schlachthof
#> 629 1995 1995-07-10                                      Ungdomshuset
#> 630 1995 1995-07-12                                        Pakkahuone
#> 631 1995 1995-07-14                                     Sentrum Scene
#> 632 1995 1995-09-16                                    Sylvan Theater
#> 633 1995 1995-09-21                                              PWAC
#> 634 1995 1995-09-22                             Pearl Street Ballroom
#> 635 1995 1995-09-23                                        Metropolis
#> 636 1995 1995-09-24                                     Cepec Limouli
#> 637 1995 1995-09-26                   Carleton University Porter Hall
#> 638 1995 1995-09-27                                     RPM Warehouse
#> 639 1995 1995-09-28                               Harro East Ballroom
#> 640 1995 1995-09-29                                          Metropol
#> 641 1995 1995-10-01                                     State Theater
#> 642 1995 1995-10-02                                     Agora Theater
#> 643 1995 1995-10-03                                           Newport
#> 644 1995 1995-10-04                                         1470 West
#> 645 1995 1995-10-05                                          Bogart's
#> 646 1995 1995-10-06                     Eastwood Entertainment Center
#> 647 1995 1995-10-07                                           Brewery
#> 648 1995 1995-10-08                                Mississippi Nights
#> 649 1995 1995-10-09                                      Expo Gardens
#> 650 1995 1995-10-10                                Rainbo Roller Rink
#> 651 1995 1995-10-12                                Riverside Ballroom
#> 652 1995 1995-10-13                                              Rave
#> 653 1995 1995-10-14                                      First Avenue
#> 654 1995 1995-10-15                                      First Avenue
#> 655 1995 1995-10-17                                      Hunky Dory's
#> 656 1995 1995-10-18               State Fairgrounds Agricultural Hall
#> 657 1995 1995-10-19                                         Pomp Room
#> 658 1995 1995-10-20       Surbeck City School of Mines and Technology
#> 659 1995 1995-10-22                             Mammoth Events Center
#> 660 1995 1995-10-24                              Fairgrounds Coliseum
#> 661 1995 1995-10-25                                           Bogie's
#> 662 1995 1995-10-26                                  Twilight Terrace
#> 663 1995 1995-10-27                                               DV8
#> 664 1995 1995-10-29                                   Capitol Theater
#> 665 1995 1995-11-01                                       Egan Center
#> 666 1995 1995-11-02                                           La Luna
#> 667 1995 1995-11-04                                             Grind
#> 668 1995 1995-11-05                                Trocadero Transfer
#> 669 1995 1995-11-06                                Trocadero Transfer
#> 670 1995 1995-11-07                                     Tejon Theater
#> 671 1995 1995-11-08                                 Shrine Auditorium
#> 672 1995 1995-11-09                                 Shrine Auditorium
#> 673 1995 1995-11-10                                              Soma
#> 674 1995 1995-11-11                                     Party Gardens
#> 675 1995 1995-11-13                                  Five Points Hall
#> 676 1995 1995-11-14                                        Metropolis
#> 677 1995 1995-11-16                                     Liberty Lunch
#> 678 1995 1995-11-17                                     Liberty Lunch
#> 679 1995 1995-11-18                           Showcase Special Events
#> 680 1995 1995-11-19                                      Bomb Factory
#> 681 1995 1995-11-20                                  Diamond Ballroom
#> 682 1996 1996-01-30                                         Black Cat
#> 683 1996 1996-01-31                                         9:30 Club
#> 684 1996 1996-03-19                                         Baitshack
#> 685 1996 1996-03-20                                          Mad Monk
#> 686 1996 1996-03-21                                           Ziggy's
#> 687 1996 1996-03-22                                              Ritz
#> 688 1996 1996-03-23                                Tremont Music Hall
#> 689 1996 1996-03-24                                           Clyde's
#> 690 1996 1996-03-26                                           40 Watt
#> 691 1996 1996-03-27           University of Alabama Spragins Hall Gym
#> 692 1996 1996-03-28                                        Masquerade
#> 693 1996 1996-03-29                                        Masquerade
#> 694 1996 1996-03-30                                               Zoo
#> 695 1996 1996-03-31                                          Milk Bar
#> 696 1996 1996-04-01                                         Firestone
#> 697 1996 1996-04-02                                              Edge
#> 698 1996 1996-04-03                                        Masquerade
#> 699 1996 1996-04-05                                        Tipitina's
#> 700 1996 1996-04-07                   Heymann Performance Arts Center
#> 701 1996 1996-04-08                                 D&I Colonial Hall
#> 702 1996 1996-04-10                                        Lafayettes
#> 703 1996 1996-04-11                                   328 Performance
#> 704 1996 1996-04-12                                 Electric Ballroom
#> 705 1996 1996-04-13                                       Alternative
#> 706 1996 1996-04-14     Virginia Commonwealth University Shafer Court
#> 707 1996 1996-04-19                              First Baptist Church
#> 708 1996 1996-10-16                                            Groove
#> 709 1996 1996-10-17                              Maui Cultural Center
#> 710 1996 1996-10-18                              Maui Cultural Center
#> 711 1996 1996-10-21                                        Viure Hall
#> 712 1996 1996-10-22                                        Pepperland
#> 713 1996 1996-10-23                                          Sun Hall
#> 714 1996 1996-10-25                                         Heartland
#> 715 1996 1996-10-26                                            Guilty
#> 716 1996 1996-10-27                                            Guilty
#> 717 1996 1996-10-28                                            Guilty
#> 718 1996 1996-10-30                                     Counteraction
#> 719 1996 1996-10-31                                            Bessie
#> 720 1996 1996-11-02                          South Island School Hall
#> 721 1996 1996-11-03                                      Kowloon Park
#> 722 1996 1996-11-06                                         Fire Club
#> 723 1996 1996-11-08                                         Fire Club
#> 724 1996 1996-11-13                                 Sapphire Ballroom
#> 725 1996 1996-11-15                                 Sydney University
#> 726 1996 1996-11-16                                   Cambridge Hotel
#> 727 1997 1997-04-29                  University of Maryland Baltimore
#> 728 1997 1997-05-01                                         Palladium
#> 729 1997 1997-05-02                                   NYU Loeb Center
#> 730 1997 1997-05-03                                  Electric Factory
#> 731 1997 1997-05-04                University of New Hampshire M.U.B.
#> 732 1997 1997-05-05                                    St. John's Gym
#> 733 1997 1997-05-06                           Lupo's Heartbreak Hotel
#> 734 1997 1997-08-05                                      Blue Galeria
#> 735 1997 1997-08-06                                           Brodway
#> 736 1997 1997-08-07                                     Camburi Clube
#> 737 1997 1997-08-09                            Teatro Garagem Do Sesc
#> 738 1997 1997-08-10                            Teatro Garagem Do Sesc
#> 739 1997 1997-08-13                                            Kawale
#> 740 1997 1997-08-14                                          92 Graus
#> 741 1997 1997-08-15                                 Liga De Socierade
#> 742 1997 1997-08-19                                    A.S.S.A.M.P.I.
#> 743 1997 1997-08-20                                       Bar De Tres
#> 744 1997 1997-08-22                                         Superclub
#> 745 1997 1997-08-23                                         Laberinto
#> 746 1997 1997-08-29                                         Fort Reno
#> 747 1998 1998-05-01                                          180 Club
#> 748 1998 1998-05-02                        Carnegie Mellon University
#> 749 1998 1998-05-03                                           Newport
#> 750 1998 1998-05-04                             Kent State University
#> 751 1998 1998-05-05                                     Agora Theater
#> 752 1998 1998-05-06                                          Bogart's
#> 753 1998 1998-05-07                                  Congress Theater
#> 754 1998 1998-05-08                                  Congress Theater
#> 755 1998 1998-05-09                                     State Theater
#> 756 1998 1998-05-12                                    Teamsters Hall
#> 757 1998 1998-07-16                                            Chance
#> 758 1998 1998-07-17                                      Lost Horizon
#> 759 1998 1998-07-18                               Harro East Ballroom
#> 760 1998 1998-07-19                                   Phoenix Theater
#> 761 1998 1998-07-20                                       Barrymore's
#> 762 1998 1998-07-21                                          Spectrum
#> 763 1998 1998-07-22                                  Centre De Losire
#> 764 1998 1998-07-24                    New Maryland Recreation Center
#> 765 1998 1998-07-25                                     Olympic Bingo
#> 766 1998 1998-07-26                                            Asylum
#> 767 1998 1998-07-27                                         Maxwell's
#> 768 1998 1998-07-30                                         Fort Reno
#> 769 1998 1998-11-13                                              Rave
#> 770 1998 1998-11-14                University of Wisconsin, Fire Room
#> 771 1998 1998-11-15                                      First Avenue
#> 772 1998 1998-11-16                                       Safari Club
#> 773 1998 1998-11-17                                        Sokol Hall
#> 774 1998 1998-11-18                                        Gee Coffee
#> 775 1998 1998-11-19                                  Will Rogers Hall
#> 776 1998 1998-11-21                                      Fitzgerald's
#> 777 1998 1998-11-22                                     Liberty Lunch
#> 778 1998 1998-11-23                                            Galaxy
#> 779 1998 1998-11-24                Hendrix University, Hulen Ballroom
#> 780 1998 1998-11-25                                 New Daisy Theater
#> 781 1998 1998-11-26                                            Galaxy
#> 782 1998 1998-11-27                                     Highland Hall
#> 783 1998 1998-11-28                                    Common Grounds
#> 784 1998 1998-11-29                                  123 Pleasant St.
#> 785 1998 1998-12-03                                 Sanctuary Theater
#> 786 1998 1998-12-04            George Mason University Johnson Center
#> 787 1999 1999-02-18                                              Soma
#> 788 1999 1999-02-19                                   Ventura Theater
#> 789 1999 1999-02-20                           Veteran's Memorial Hall
#> 790 1999 1999-02-21                                              Edge
#> 791 1999 1999-02-22                                          Maritime
#> 792 1999 1999-02-23                                   Del Mar Station
#> 793 1999 1999-02-24                                     Crest Theater
#> 794 1999 1999-02-26                                  Crystal Ballroom
#> 795 1999 1999-02-27                                   Capitol Theater
#> 796 1999 1999-02-28                                               DV8
#> 797 1999 1999-03-02                                 McKensie Ballroom
#> 798 1999 1999-03-03                  Cal State University Shurmer Gym
#> 799 1999 1999-03-04                                       Juarez Hall
#> 800 1999 1999-03-05                                 Huntridge Theater
#> 801 1999 1999-03-07                                        Glasshouse
#> 802 1999 1999-04-27                           National Radio Building
#> 803 1999 1999-04-29                                  Metro University
#> 804 1999 1999-04-30                                      Wulfrun Hall
#> 805 1999 1999-05-02                                         Riverside
#> 806 1999 1999-05-03                                       Liquid Room
#> 807 1999 1999-05-04                                        Lemon Tree
#> 808 1999 1999-05-05                             Glasgow School of Art
#> 809 1999 1999-05-07                                       Friary Hall
#> 810 1999 1999-05-08                                      Nancy Spains
#> 811 1999 1999-05-09                           Temple Bar Music Center
#> 812 1999 1999-05-11                                              TJ's
#> 813 1999 1999-05-12                          University Student Union
#> 814 1999 1999-05-13                              Marcus Garvey Centre
#> 815 1999 1999-05-14                                   Brighton Center
#> 816 1999 1999-05-15                                               Rex
#> 817 1999 1999-09-16                                          Paradiso
#> 818 1999 1999-09-18                                            Fabrik
#> 819 1999 1999-09-20                                             SO 36
#> 820 1999 1999-09-21                                          Kazamaty
#> 821 1999 1999-09-22                                      Conne Island
#> 822 1999 1999-09-23                                           Lucerna
#> 823 1999 1999-09-24                                             Z-Bau
#> 824 1999 1999-09-25                                         Backstage
#> 825 1999 1999-09-26                                             Flexx
#> 826 1999 1999-09-28                                         Metelkova
#> 827 1999 1999-09-29                                           Rivolta
#> 828 1999 1999-09-30                                  Forte Prenestino
#> 829 1999 1999-10-01                                               CPA
#> 830 1999 1999-10-03                        Porto Catania Outdoor Show
#> 831 1999 1999-10-05                                       Rote Fabrik
#> 832 1999 1999-10-06                                           L'Usine
#> 833 1999 1999-10-07                                 Theatre Du Moulin
#> 834 1999 1999-10-08                                           Zeleste
#> 835 1999 1999-10-10                                          Sala Jam
#> 836 1999 1999-10-11                                    Theatre Barbey
#> 837 1999 1999-10-12                                Le Confort Moderne
#> 838 1999 1999-10-13                                         L'Olympic
#> 839 1999 1999-10-14                               Le Cafe De la Danse
#> 840 1999 1999-10-15                                 Ancienne Belgique
#> 841 1999 1999-10-16                                               O13
#> 842 1999 1999-12-02                           Lupo's Heartbreak Hotel
#> 843 1999 1999-12-03                                              Roxy
#> 844 1999 1999-12-04                                  Electric Factory
#> 845 1999 1999-12-05                                         9:30 Club
#> 846 1999 1999-12-07                                              Trax
#> 847 1999 1999-12-17                                        Masquerade
#> 848 1999 1999-12-18                                           40 Watt
#> 849 1999 1999-12-19                                 Electric Ballroom
#> 850 1999 1999-12-20                                   328 Performance
#> 851 2000 2000-01-12                                              Ritz
#> 852 2000 2000-01-13                                Tremont Music Hall
#> 853 2000 2000-01-14                                        River Rock
#> 854 2000 2000-01-15                                        Brick City
#> 855 2000 2000-01-16                                         Firestone
#> 856 2000 2000-01-18                                      Chili Pepper
#> 857 2000 2000-01-19                                        Masquerade
#> 858 2000 2000-01-20                                              Moon
#> 859 2000 2000-06-04                              Mission Dolores Park
#> 860 2000 2000-06-27     Smithsonian Folklife Festival / National Mall
#> 861 2000 2000-09-30                                           Galaxen
#> 862 2000 2000-10-01                                       Kolingsborg
#> 863 2000 2000-10-02                            Rockefeller Music Hall
#> 864 2000 2000-10-03                                              Uffa
#> 865 2000 2000-10-04                                         Kvarteret
#> 866 2000 2000-10-06                                       Kulturhuset
#> 867 2000 2000-10-07                                            Loppen
#> 868 2000 2000-10-08                                          Mejeriet
#> 869 2000 2000-10-10                                           Nosturi
#> 870 2001 2001-04-05                                     Ogden Theater
#> 871 2001 2001-04-06                                     Ogden Theater
#> 872 2001 2001-04-07                               Colorado Music Hall
#> 873 2001 2001-04-08                               Sunshine Music Hall
#> 874 2001 2001-04-09                                                E9
#> 875 2001 2001-04-10                                    Rialto Theater
#> 876 2001 2001-04-12                                 Celebrity Theater
#> 877 2001 2001-04-13                            Grey Hills High School
#> 878 2001 2001-04-14                                            Bricks
#> 879 2001 2001-04-16                                        Cowboy Bar
#> 880 2001 2001-04-17                                   Centennial Hall
#> 881 2001 2001-04-18                                        El Torreon
#> 882 2001 2001-04-19                                         Blue Note
#> 883 2001 2001-04-20                          Knights of Columbus Hall
#> 884 2001 2001-04-21                        Carnegie Mellon University
#> 885 2001 2001-04-25                                         9:30 Club
#> 886 2001 2001-06-21                                  Columbian Center
#> 887 2001 2001-06-23                                  Congress Theater
#> 888 2001 2001-06-24                                  Congress Theater
#> 889 2001 2001-06-26                                Riverside Ballroom
#> 890 2001 2001-06-27                                      First Avenue
#> 891 2001 2001-06-28                             Playmaker's Pavillion
#> 892 2001 2001-06-29                                    Le Rendez Vous
#> 893 2001 2001-06-30                              University of Regina
#> 894 2001 2001-07-01                                      Sid's Garage
#> 895 2001 2001-07-02                                       Polish Hall
#> 896 2001 2001-07-03                                      MacEwan Hall
#> 897 2001 2001-07-05                                Performance Centre
#> 898 2001 2001-07-06                            Archie Browning Centre
#> 899 2001 2001-07-07                               Bill Copeland Arena
#> 900 2001 2001-08-13                                         Fort Reno
#> 901 2002 2002-03-22         University of Richmond Greek Amphitheater
#> 902 2002 2002-03-23                                              Ritz
#> 903 2002 2002-03-25                                     Sloss Furnace
#> 904 2002 2002-03-27                                        Tipitina's
#> 905 2002 2002-03-28                            International Ballroom
#> 906 2002 2002-03-29                                     Sunset Saloon
#> 907 2002 2002-03-30                                             Emo's
#> 908 2002 2002-03-31                                             Emo's
#> 909 2002 2002-04-01                                   Ridglea Theater
#> 910 2002 2002-04-02                             Rivermarket Pavillion
#> 911 2002 2002-04-04                          Spectrum Cultural Center
#> 912 2002 2002-04-05                                      Stone Monkey
#> 913 2002 2002-04-06               James Madison U. Godwin Gym/MacRock
#> 914 2002 2002-04-18                              Holyoke War Memorial
#> 915 2002 2002-04-19                                Mass Art Gymnasium
#> 916 2002 2002-04-20                                Mass Art Gymnasium
#>     attendance
#> 1          300
#> 2          200
#> 3           50
#> 4           50
#> 5          100
#> 6           10
#> 7          300
#> 8          100
#> 9          100
#> 10         125
#> 11          75
#> 12         250
#> 13         400
#> 14         200
#> 15         150
#> 16         350
#> 17         300
#> 18         100
#> 19         100
#> 20         150
#> 21          50
#> 22          20
#> 23         100
#> 24         100
#> 25          20
#> 26         100
#> 27          75
#> 28          75
#> 29          20
#> 30          50
#> 31         400
#> 32         200
#> 33         150
#> 34         100
#> 35          20
#> 36         300
#> 37         200
#> 38         200
#> 39         450
#> 40         200
#> 41         100
#> 42         500
#> 43          50
#> 44        1000
#> 45         400
#> 46         900
#> 47         150
#> 48         200
#> 49         400
#> 50         200
#> 51         120
#> 52         200
#> 53         350
#> 54          60
#> 55         300
#> 56         450
#> 57         300
#> 58         150
#> 59         250
#> 60         350
#> 61        1000
#> 62         140
#> 63         375
#> 64         600
#> 65         375
#> 66         300
#> 67         300
#> 68         350
#> 69         350
#> 70         350
#> 71         250
#> 72         250
#> 73         200
#> 74         350
#> 75         350
#> 76         450
#> 77         280
#> 78         360
#> 79         400
#> 80         200
#> 81         600
#> 82         450
#> 83         450
#> 84         800
#> 85         500
#> 86         850
#> 87         500
#> 88         450
#> 89         300
#> 90         350
#> 91         250
#> 92         400
#> 93         300
#> 94         250
#> 95         850
#> 96         400
#> 97         400
#> 98         300
#> 99         350
#> 100        350
#> 101        400
#> 102        400
#> 103        300
#> 104        250
#> 105        400
#> 106       1000
#> 107        700
#> 108        400
#> 109        500
#> 110        300
#> 111        500
#> 112        500
#> 113        500
#> 114        400
#> 115       1100
#> 116       1500
#> 117       1400
#> 118        800
#> 119       1000
#> 120        900
#> 121       1000
#> 122        900
#> 123        800
#> 124        250
#> 125       1700
#> 126        450
#> 127        250
#> 128        250
#> 129        100
#> 130        350
#> 131        935
#> 132        600
#> 133        985
#> 134        275
#> 135        180
#> 136        300
#> 137        250
#> 138        230
#> 139        650
#> 140        600
#> 141        800
#> 142       1200
#> 143        400
#> 144        350
#> 145        300
#> 146        220
#> 147        700
#> 148       1100
#> 149        350
#> 150        275
#> 151        300
#> 152        700
#> 153        500
#> 154       1000
#> 155       1000
#> 156        500
#> 157       1100
#> 158        650
#> 159        400
#> 160        250
#> 161        550
#> 162        300
#> 163        580
#> 164       1100
#> 165        400
#> 166        225
#> 167        500
#> 168        600
#> 169        800
#> 170        700
#> 171        250
#> 172        950
#> 173       1000
#> 174        300
#> 175       1100
#> 176        400
#> 177        400
#> 178        400
#> 179        700
#> 180        450
#> 181        380
#> 182        200
#> 183        400
#> 184        600
#> 185        700
#> 186        500
#> 187        250
#> 188       1300
#> 189        450
#> 190        460
#> 191       1000
#> 192        700
#> 193        400
#> 194        650
#> 195        380
#> 196        700
#> 197        700
#> 198        600
#> 199        700
#> 200        650
#> 201        800
#> 202        800
#> 203       2500
#> 204        350
#> 205        400
#> 206        600
#> 207       1300
#> 208       1000
#> 209        500
#> 210        500
#> 211        150
#> 212        250
#> 213         60
#> 214        110
#> 215        700
#> 216        450
#> 217        600
#> 218       2000
#> 219       1800
#> 220        800
#> 221       1500
#> 222        500
#> 223       1100
#> 224       1000
#> 225       1400
#> 226        700
#> 227       1300
#> 228        450
#> 229        700
#> 230       1000
#> 231        800
#> 232        450
#> 233        250
#> 234       1000
#> 235       1000
#> 236        600
#> 237        400
#> 238        500
#> 239        600
#> 240        300
#> 241        500
#> 242        100
#> 243        500
#> 244       1200
#> 245        100
#> 246        500
#> 247        500
#> 248       1500
#> 249       1300
#> 250        500
#> 251       1800
#> 252        600
#> 253       1100
#> 254       1100
#> 255        200
#> 256        700
#> 257       1000
#> 258        850
#> 259        750
#> 260        800
#> 261        450
#> 262        400
#> 263        400
#> 264       1750
#> 265        500
#> 266       1100
#> 267       1350
#> 268       1000
#> 269        900
#> 270        250
#> 271        600
#> 272        400
#> 273        300
#> 274        400
#> 275        650
#> 276        500
#> 277        700
#> 278       1700
#> 279        200
#> 280        700
#> 281       1150
#> 282       1390
#> 283       1400
#> 284        500
#> 285        650
#> 286        365
#> 287        480
#> 288        283
#> 289       1200
#> 290       1100
#> 291        950
#> 292        600
#> 293       1000
#> 294        300
#> 295        230
#> 296        400
#> 297       1275
#> 298        450
#> 299        850
#> 300        350
#> 301        300
#> 302       1000
#> 303        400
#> 304        700
#> 305       1300
#> 306       1350
#> 307       1400
#> 308       1160
#> 309        500
#> 310       1000
#> 311       1200
#> 312        800
#> 313       1550
#> 314        850
#> 315        850
#> 316        350
#> 317       1550
#> 318        550
#> 319        500
#> 320        288
#> 321        700
#> 322       1300
#> 323        800
#> 324       1600
#> 325        850
#> 326        750
#> 327       1800
#> 328        600
#> 329        950
#> 330        350
#> 331        750
#> 332        300
#> 333       3800
#> 334       1160
#> 335        800
#> 336        900
#> 337       1000
#> 338        300
#> 339       1150
#> 340        500
#> 341        750
#> 342        450
#> 343        300
#> 344        900
#> 345        700
#> 346        800
#> 347        300
#> 348        550
#> 349        200
#> 350        900
#> 351        300
#> 352        300
#> 353        200
#> 354        850
#> 355       4000
#> 356       4000
#> 357       1200
#> 358        200
#> 359       3000
#> 360        800
#> 361        800
#> 362        750
#> 363        600
#> 364        950
#> 365       1200
#> 366        350
#> 367        300
#> 368        380
#> 369        500
#> 370        950
#> 371       4000
#> 372       1300
#> 373        700
#> 374        800
#> 375        720
#> 376       2000
#> 377       1000
#> 378        400
#> 379        350
#> 380        650
#> 381        400
#> 382        350
#> 383        445
#> 384       1300
#> 385        700
#> 386        860
#> 387        270
#> 388        950
#> 389        350
#> 390        300
#> 391       1000
#> 392        850
#> 393       3500
#> 394        600
#> 395       2000
#> 396       1300
#> 397        750
#> 398       1000
#> 399       1000
#> 400        600
#> 401       1600
#> 402        750
#> 403       1326
#> 404       1500
#> 405       1500
#> 406        700
#> 407       1000
#> 408        600
#> 409        700
#> 410        600
#> 411       2800
#> 412       1300
#> 413       1300
#> 414        800
#> 415       1461
#> 416       1000
#> 417        500
#> 418       1200
#> 419        150
#> 420        500
#> 421       2000
#> 422       1200
#> 423        760
#> 424        850
#> 425        700
#> 426        650
#> 427       1350
#> 428       1450
#> 429        600
#> 430       1200
#> 431       1600
#> 432       1650
#> 433       1500
#> 434       1450
#> 435        500
#> 436       1000
#> 437        750
#> 438        900
#> 439       2000
#> 440        950
#> 441       1010
#> 442       1500
#> 443        850
#> 444        750
#> 445       1400
#> 446       2400
#> 447        500
#> 448       1000
#> 449       1000
#> 450       1300
#> 451       2000
#> 452       1000
#> 453        400
#> 454        700
#> 455       1200
#> 456        850
#> 457       3300
#> 458       3700
#> 459       3900
#> 460       1200
#> 461        950
#> 462       1300
#> 463       5000
#> 464       4000
#> 465       1000
#> 466        400
#> 467        800
#> 468       1200
#> 469       3200
#> 470       1200
#> 471       1000
#> 472       1500
#> 473        950
#> 474       2000
#> 475       2400
#> 476        240
#> 477       2800
#> 478        700
#> 479       1600
#> 480       1600
#> 481       1200
#> 482       1000
#> 483       1300
#> 484       1300
#> 485       1600
#> 486       1400
#> 487       5000
#> 488        200
#> 489       1000
#> 490       1000
#> 491       1000
#> 492       1300
#> 493        850
#> 494       1300
#> 495        950
#> 496       1200
#> 497       1200
#> 498       1000
#> 499       2700
#> 500       1450
#> 501       1000
#> 502       1300
#> 503       3650
#> 504       5000
#> 505       3200
#> 506       1200
#> 507        775
#> 508       1400
#> 509        650
#> 510       1100
#> 511       2100
#> 512        400
#> 513       1100
#> 514        400
#> 515       3200
#> 516       2150
#> 517        700
#> 518       1000
#> 519       1000
#> 520        700
#> 521       3500
#> 522       3500
#> 523       1000
#> 524       1200
#> 525       1200
#> 526        500
#> 527        190
#> 528        100
#> 529        160
#> 530        350
#> 531        550
#> 532        550
#> 533        800
#> 534        550
#> 535        750
#> 536        750
#> 537       1300
#> 538        600
#> 539        250
#> 540        600
#> 541       1300
#> 542        450
#> 543        450
#> 544       1000
#> 545        450
#> 546        400
#> 547        180
#> 548        600
#> 549        550
#> 550       1000
#> 551        800
#> 552        500
#> 553       1300
#> 554         50
#> 555       2000
#> 556       3000
#> 557        200
#> 558        300
#> 559       1000
#> 560        800
#> 561        200
#> 562        300
#> 563         75
#> 564        350
#> 565        450
#> 566        650
#> 567       1000
#> 568       1200
#> 569       1200
#> 570       1100
#> 571       1100
#> 572       1100
#> 573       1200
#> 574        921
#> 575       1500
#> 576       1600
#> 577       1700
#> 578        200
#> 579       1300
#> 580       1000
#> 581        600
#> 582       1200
#> 583       1500
#> 584        600
#> 585       1000
#> 586        630
#> 587       3500
#> 588       1000
#> 589       1000
#> 590       1300
#> 591        850
#> 592       1000
#> 593        315
#> 594       1000
#> 595       1000
#> 596        500
#> 597        500
#> 598       1000
#> 599        650
#> 600        400
#> 601        800
#> 602       1400
#> 603        800
#> 604       3000
#> 605       2500
#> 606       2000
#> 607       1400
#> 608       2000
#> 609       1200
#> 610       5000
#> 611       5000
#> 612       1000
#> 613        800
#> 614        900
#> 615       2000
#> 616        600
#> 617        800
#> 618        660
#> 619       1200
#> 620        760
#> 621        600
#> 622       1500
#> 623        900
#> 624       1300
#> 625        450
#> 626        500
#> 627        560
#> 628       1000
#> 629        400
#> 630        650
#> 631        950
#> 632       3000
#> 633        900
#> 634        750
#> 635       1500
#> 636        450
#> 637        850
#> 638       1650
#> 639       1350
#> 640       1300
#> 641       3000
#> 642       1666
#> 643       1621
#> 644        826
#> 645       1300
#> 646        750
#> 647       1300
#> 648       1100
#> 649        780
#> 650       3200
#> 651       1000
#> 652       1500
#> 653       1700
#> 654       1700
#> 655        600
#> 656       1300
#> 657        804
#> 658        700
#> 659       2000
#> 660       2000
#> 661        500
#> 662        400
#> 663       1400
#> 664       1000
#> 665       2050
#> 666       1100
#> 667       1000
#> 668       1200
#> 669       1200
#> 670        900
#> 671       2200
#> 672       3400
#> 673       1500
#> 674       2500
#> 675        895
#> 676        861
#> 677       1100
#> 678       1100
#> 679       1400
#> 680       1400
#> 681       1200
#> 682        700
#> 683       1500
#> 684       1300
#> 685       1135
#> 686        900
#> 687       2400
#> 688        900
#> 689        400
#> 690        975
#> 691       1295
#> 692       1100
#> 693       1100
#> 694        700
#> 695       1100
#> 696       1600
#> 697       1700
#> 698       1200
#> 699       1100
#> 700       1250
#> 701       1250
#> 702        600
#> 703       1500
#> 704       1050
#> 705        900
#> 706       4000
#> 707       1000
#> 708       1650
#> 709        400
#> 710        400
#> 711        170
#> 712         90
#> 713        280
#> 714        160
#> 715        254
#> 716        205
#> 717        332
#> 718        150
#> 719        150
#> 720        400
#> 721        200
#> 722        800
#> 723        800
#> 724        450
#> 725       1000
#> 726        550
#> 727        300
#> 728       3000
#> 729       1000
#> 730       2900
#> 731        900
#> 732        850
#> 733       1200
#> 734        450
#> 735        950
#> 736        250
#> 737        150
#> 738        150
#> 739        700
#> 740        600
#> 741        350
#> 742        800
#> 743        500
#> 744       1100
#> 745        700
#> 746       2500
#> 747        350
#> 748       1300
#> 749       1200
#> 750       1400
#> 751       1000
#> 752       1300
#> 753       2500
#> 754       3100
#> 755       2400
#> 756        800
#> 757        920
#> 758        450
#> 759       1200
#> 760       1250
#> 761        625
#> 762        650
#> 763        173
#> 764        275
#> 765        800
#> 766        750
#> 767        200
#> 768       2000
#> 769       1500
#> 770        900
#> 771       1711
#> 772        500
#> 773       1200
#> 774        750
#> 775        850
#> 776        750
#> 777       1100
#> 778        700
#> 779       1300
#> 780        900
#> 781        765
#> 782       1100
#> 783        500
#> 784        400
#> 785        700
#> 786       1000
#> 787       1500
#> 788       1350
#> 789       1350
#> 790       1000
#> 791       2000
#> 792       1000
#> 793       1000
#> 794       1200
#> 795       1200
#> 796       1500
#> 797        750
#> 798       1000
#> 799        400
#> 800       1000
#> 801       1000
#> 802        400
#> 803        950
#> 804        500
#> 805        450
#> 806        500
#> 807        550
#> 808        600
#> 809        400
#> 810        400
#> 811        650
#> 812        600
#> 813        936
#> 814        778
#> 815        950
#> 816       3100
#> 817       1200
#> 818       1050
#> 819        949
#> 820        800
#> 821        921
#> 822        900
#> 823        918
#> 824        753
#> 825       1000
#> 826        500
#> 827       1800
#> 828       5000
#> 829       3000
#> 830       2000
#> 831        625
#> 832        650
#> 833        450
#> 834       1125
#> 835       1300
#> 836        800
#> 837        650
#> 838        690
#> 839        700
#> 840       1900
#> 841        600
#> 842       1900
#> 843       2500
#> 844       3000
#> 845       1500
#> 846        900
#> 847       1200
#> 848        900
#> 849        700
#> 850        800
#> 851       1750
#> 852        900
#> 853        700
#> 854       1100
#> 855       1650
#> 856       1200
#> 857       1400
#> 858       1200
#> 859      15000
#> 860       1000
#> 861        500
#> 862        700
#> 863        650
#> 864        300
#> 865        300
#> 866        600
#> 867        450
#> 868        350
#> 869        370
#> 870       1200
#> 871       1200
#> 872        900
#> 873       1100
#> 874        990
#> 875       1500
#> 876       2600
#> 877        600
#> 878       1500
#> 879        500
#> 880       1000
#> 881        900
#> 882       1000
#> 883        700
#> 884       2000
#> 885       1500
#> 886        350
#> 887       3500
#> 888       3500
#> 889       1200
#> 890       1700
#> 891        975
#> 892        750
#> 893        550
#> 894        260
#> 895       1000
#> 896       1000
#> 897        450
#> 898       1100
#> 899       2518
#> 900       4000
#> 901       3500
#> 902       2400
#> 903       1450
#> 904       1000
#> 905       1900
#> 906       1400
#> 907       1200
#> 908       1300
#> 909       1350
#> 910       1350
#> 911       1350
#> 912        500
#> 913       3000
#> 914       1200
#> 915       1500
#> 916       1500
```
