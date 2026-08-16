# Sound quality data, one record per show

Sound quality data, one record per show

## Usage

``` r
gid_sound_quality
```

## Format

dataframe with one row for each show in the Fugazi Live Series data.

- gid:

  show id

- sound_quality:

  Sound quality rating: Excellent, Very Good, Good, or Poor.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).

## Examples

``` r
gid_sound_quality
#>                                                gid sound_quality
#> 1                          washington-dc-usa-90387          Good
#> 2                          washington-dc-usa-92687     Very Good
#> 3                           richmond-va-usa-100787     Very Good
#> 4                         washington-dc-usa-101687          Good
#> 5                          frederick-md-usa-112587          Good
#> 6                         washington-dc-usa-120387          Good
#> 7                            norwalk-ct-usa-120587          Good
#> 8                         washington-dc-usa-122887     Very Good
#> 9   ypsilanti-mi-eastern-michigan-university-12288          Poor
#> 10                              flint-mi-usa-12188          Poor
#> 11                          annapolis-md-usa-20688          Good
#> 12                         merrifield-va-usa-22088          Poor
#> 13                         washington-dc-usa-30388     Very Good
#> 14                         washington-dc-usa-33088          Good
#> 15                          rockville-md-usa-40988          Good
#> 16                             boston-ma-usa-41688          Good
#> 17                         providence-ri-usa-41788          Good
#> 18                        clarksville-in-usa-50788          Good
#> 19                            bozeman-mt-usa-51288          Poor
#> 20                            spokane-wa-usa-51388          Good
#> 21                            olympia-wa-usa-51688          Good
#> 22                           berkeley-ca-usa-52088          Good
#> 23                         long-beach-ca-usa-52188          Poor
#> 24                             pomona-ca-usa-52288          Good
#> 25                             tucson-az-usa-52488          Poor
#> 26                    college-station-tx-usa-52688          Poor
#> 27                            atlanta-ga-usa-60488          Good
#> 28                         washington-dc-usa-61588          Good
#> 29                            hoboken-nj-usa-63088          Good
#> 30                         washington-dc-usa-71888          Poor
#> 31                         washington-dc-usa-72888          Good
#> 32                         washington-dc-usa-80188          Good
#> 33                       philadelphia-pa-usa-80788          Poor
#> 34                    rotterdam-netherlands-101488          Poor
#> 35                        hoorn-netherlands-101588          Good
#> 36                             gent-belgium-101688          Poor
#> 37                    amsterdam-netherlands-101688          Good
#> 38                           lubeck-germany-102188          Good
#> 39                              oslo-norway-102588     Very Good
#> 40                        bielefeld-germany-103188          Poor
#> 41                           nagold-germany-110488          Good
#> 42                         augsburg-germany-110588          Good
#> 43                             linz-austria-111088          Good
#> 44                              udine-italy-111488          Good
#> 45                               rome-italy-111788          Good
#> 46                              milan-italy-111988          Good
#> 47                             torino-italy-112088          Good
#> 48                             paris-france-112288          Good
#> 49                           london-england-112488          Poor
#> 50                        liverpool-england-112688          Good
#> 51                           dublin-ireland-112988          Poor
#> 52                            leeds-england-113088     Very Good
#> 53                            wigan-england-120188          Good
#> 54                       canterbury-england-120288          Good
#> 55                           london-england-120588          Good
#> 56                        washington-dc-usa-122988          Good
#> 57                         washington-dc-usa-12689          Poor
#> 58                         washington-dc-usa-32489          Poor
#> 59                           new-york-ny-usa-40589          Good
#> 60                          princeton-nj-usa-40689          Poor
#> 61                            norwalk-ct-usa-40789          Good
#> 62                         middletown-ct-usa-40889          Good
#> 63                            hoboken-nj-usa-40989          Good
#> 64                        chapel-hill-nc-usa-50189          Poor
#> 65                             athens-ga-usa-50389          Good
#> 66                            atlanta-ga-usa-50589          Good
#> 67                          fortworth-tx-usa-51189          Good
#> 68                            phoenix-az-usa-51689          Good
#> 69                        los-angeles-ca-usa-51889          Good
#> 70                           berkeley-ca-usa-52089          Poor
#> 71                     salt-lake-city-ut-usa-60189          Good
#> 72                           st-louis-mo-usa-60589          Good
#> 73                          milwaukee-wi-usa-60989          Poor
#> 74                         pittsburgh-pa-usa-61689          Good
#> 75                         washington-dc-usa-62289          Poor
#> 76                         washington-dc-usa-71989          Good
#> 77                         washington-dc-usa-72089          Poor
#> 78                         washington-dc-usa-92289          Good
#> 79                       philadelphia-pa-usa-92389          Good
#> 80                          guelph-on-canada-93089          Good
#> 81                        toronto-on-canada-100189          Good
#> 82                        providence-ri-usa-100589     Very Good
#> 83                           hoboken-nj-usa-100889          Good
#> 84                          new-york-ny-usa-100989          Good
#> 85                        washington-dc-usa-101589          Good
#> 86                    amsterdam-netherlands-110389          Good
#> 87                     nijmegen-netherlands-110989     Very Good
#> 88                       canterbury-england-111389          Good
#> 89                         brighton-england-111489          Poor
#> 90                           exeter-england-111689          Poor
#> 91                       birmingham-england-111989          Good
#> 92                            leeds-england-112089          Good
#> 93                          bristol-england-112289          Good
#> 94                           dublin-ireland-112389          Good
#> 95                 belfast-northern-ireland-112489          Poor
#> 96                        liverpool-england-112589          Good
#> 97                        newcastle-england-112689          Good
#> 98                         glasgow-scotland-112789          Poor
#> 99                       manchester-england-112889     Very Good
#> 100                          london-england-112989     Very Good
#> 101                      heidelberg-germany-120489          Good
#> 102                   groningen-netherlands-120789          Good
#> 103                   eindhoven-netherlands-120889          Good
#> 104                   amsterdam-netherlands-120989          Good
#> 105                            paris-france-121189          Good
#> 106                        washington-dc-usa-12790          Good
#> 107                         baltimore-md-usa-21190          Good
#> 108                         frederick-md-usa-21690          Good
#> 109                    virginia-beach-va-usa-31090     Very Good
#> 110                      harrisonburg-va-usa-31190          Good
#> 111                        greensboro-nc-usa-31290          Good
#> 112                          florence-sc-usa-31390          Good
#> 113                            athens-ga-usa-31490     Very Good
#> 114                           atlanta-ga-usa-31590          Good
#> 115                       gainesville-fl-usa-31690     Very Good
#> 116                           orlando-fl-usa-31790          Good
#> 117                         pensacola-fl-usa-31990     Very Good
#> 118                       new-orleans-la-usa-32190          Good
#> 119                         nashville-tn-usa-32390          Good
#> 120                         knoxville-tn-usa-32490          Good
#> 121                       chapel-hill-nc-usa-32590     Very Good
#> 122                      poughkeepsie-ny-usa-41390          Good
#> 123                       northampton-ma-usa-41490     Very Good
#> 124                            boston-ma-usa-42090          Good
#> 125                        providence-ri-usa-42190          Good
#> 126                          columbia-md-usa-42790          Good
#> 127                           memphis-tn-usa-50290     Very Good
#> 128                       little-rock-ar-usa-50390     Very Good
#> 129                            dallas-tx-usa-50490     Very Good
#> 130                            austin-tx-usa-50590     Very Good
#> 131                           houston-tx-usa-50690          Good
#> 132                       san-antonio-tx-usa-50790     Very Good
#> 133                            tucson-az-usa-51190          Good
#> 134                           phoenix-az-usa-51290          Good
#> 135                         encinitas-ca-usa-51590          Poor
#> 136                            reseda-ca-usa-51690     Very Good
#> 137                            reseda-ca-usa-51790     Very Good
#> 138                        isla-vista-ca-usa-51890     Very Good
#> 139                     san-francisco-ca-usa-51990          Good
#> 140                          berkeley-ca-usa-52090          Good
#> 141                             chico-ca-usa-52490          Good
#> 142                            eureka-ca-usa-52590          Poor
#> 143                            eugene-or-usa-52690          Good
#> 144                        bellingham-wa-usa-53090     Very Good
#> 145                          portland-or-usa-53190          Good
#> 146                           seattle-wa-usa-60190          Good
#> 147                           olympia-wa-usa-60290          Good
#> 148                          missoula-mt-usa-60490     Excellent
#> 149                    salt-lake-city-ut-usa-60690     Very Good
#> 150                            denver-co-usa-60890          Good
#> 151                             omaha-ne-usa-61090          Good
#> 152                          lawrence-ks-usa-61190          Good
#> 153                      fayetteville-ar-usa-61290          Good
#> 154                          st-louis-mo-usa-61390          Good
#> 155                           chicago-il-usa-61490          Good
#> 156                          waukesha-wi-usa-61590          Poor
#> 157                       minneapolis-mn-usa-61690          Good
#> 158                         green-bay-wi-usa-61890          Poor
#> 159                           madison-wi-usa-61990          Good
#> 160                             flint-mi-usa-62190          Good
#> 161                           detroit-mi-usa-62290          Poor
#> 162                         ann-arbor-mi-usa-62390          Poor
#> 163                         kalamazoo-mi-usa-62490          Good
#> 164                            toledo-oh-usa-62590          Good
#> 165                        louisville-ky-usa-62690          Good
#> 166                            dayton-oh-usa-62790          Poor
#> 167                             akron-oh-usa-62890          Good
#> 168                        pittsburgh-pa-usa-62990          Good
#> 169                        morgantown-wv-usa-63090          Good
#> 170                        washington-dc-usa-70690          Good
#> 171                        hoorn-netherlands-90190          Good
#> 172                    groningen-netherlands-90390          Poor
#> 173                    amsterdam-netherlands-90490     Very Good
#> 174                    eindhoven-netherlands-90590          Good
#> 175                     enschede-netherlands-90690          Good
#> 176                    rotterdam-netherlands-90790          Good
#> 177                   wageningen-netherlands-90890     Very Good
#> 178                          bristol-england-91090          Good
#> 179                        liverpool-england-91190          Good
#> 180                            leeds-england-91290          Good
#> 181                       nottingham-england-91390          Good
#> 182                        newcastle-england-91490          Good
#> 183                       edinburgh-scotland-91590     Very Good
#> 184                 belfast-northern-ireland-91690     Very Good
#> 185                           dublin-ireland-91790          Good
#> 186                       birmingham-england-91890     Very Good
#> 187                           london-england-91990     Very Good
#> 188                        herne-bay-england-92090          Good
#> 189                             geel-belgium-92290     Very Good
#> 190                            aalst-belgium-92390          Good
#> 191                           bremen-germany-92590          Good
#> 192                          hamburg-germany-92690          Good
#> 193                       copenhagen-denmark-92790          Good
#> 194                              oslo-norway-92890          Good
#> 195                            tromso-norway-92990          Good
#> 196                         trondheim-norway-93090          Good
#> 197                            gavle-sweden-100190          Good
#> 198                        linkoping-sweden-100290     Very Good
#> 199                             pila-poland-100490          Good
#> 200                           warsaw-poland-100590          Poor
#> 201                        zgorzelec-poland-100690          Good
#> 202                          berlin-germany-100790          Good
#> 203                       bielefeld-germany-100890     Very Good
#> 204                        hannover-germany-100990     Very Good
#> 205                      oberhausen-germany-101090          Good
#> 206                        wurzburg-germany-101190     Very Good
#> 207                           mainz-germany-101290     Very Good
#> 208                       stuttgart-germany-101390          Good
#> 209                          munich-germany-101490     Very Good
#> 210                             ulm-germany-101690          Good
#> 211                      zurich-switzerland-101790          Good
#> 212                        dornbirn-austria-101890     Very Good
#> 213                            wels-austria-101990     Very Good
#> 214                          vienna-austria-102090     Very Good
#> 215                    ljubljana-yugoslavia-102190     Very Good
#> 216                       zagreb-yugoslavia-102290     Very Good
#> 217                             udine-italy-102490     Very Good
#> 218                            milano-italy-102590     Very Good
#> 219                           bologna-italy-102690          Good
#> 220                              rome-italy-102790          Good
#> 221                              pisa-italy-102890     Very Good
#> 222                            torino-italy-102990          Good
#> 223                             lyon-france-103090          Good
#> 224                         barcelona-spain-110190     Very Good
#> 225                         bordeaux-france-110290          Good
#> 226                         poitiers-france-110390     Very Good
#> 227                   riec-sur-belon-france-110490          Good
#> 228                            paris-france-110590          Good
#> 229                            nancy-france-110690     Very Good
#> 230                   amsterdam-netherlands-110790     Very Good
#> 231                           lorton-va-usa-122690     Very Good
#> 232                        washington-dc-usa-10291          Good
#> 233                        washington-dc-usa-10391          Good
#> 234                        washington-dc-usa-11291          Good
#> 235                        washington-dc-usa-21591     Very Good
#> 236                          richmond-va-usa-22091     Very Good
#> 237                      philadelphia-pa-usa-30291          Good
#> 238                         lancaster-pa-usa-30391     Very Good
#> 239                          new-york-ny-usa-30491     Very Good
#> 240                          new-york-ny-usa-30591          Good
#> 241                           hoboken-nj-usa-30691     Very Good
#> 242                            storrs-ct-usa-30791          Good
#> 243                           amherst-ma-usa-30991     Very Good
#> 244                            latham-ny-usa-31091          Poor
#> 245                           buffalo-ny-usa-31191          Good
#> 246                          syracuse-ny-usa-31291          Good
#> 247                        burlington-vt-usa-31491          Good
#> 248                          portland-me-usa-31591          Good
#> 249                         worcester-ma-usa-31691     Very Good
#> 250                            boston-ma-usa-31791          Good
#> 251                        providence-ri-usa-31891          Good
#> 252                           trenton-nj-usa-31991          Good
#> 253                        washington-dc-usa-41291          Good
#> 254                          new-york-ny-usa-42091     Very Good
#> 255                    virginia-beach-va-usa-50191          Good
#> 256                        greensboro-nc-usa-50291          Good
#> 257                       chapel-hill-nc-usa-50391          Good
#> 258                         charlotte-nc-usa-50491          Good
#> 259                         knoxville-tn-usa-50591          Good
#> 260                         nashville-tn-usa-50791          Good
#> 261                        huntsville-al-usa-50891          Poor
#> 262                          columbia-sc-usa-51091          Good
#> 263                            athens-ga-usa-51191          Good
#> 264                           atlanta-ga-usa-51291          Good
#> 265                          savannah-ga-usa-51391          Good
#> 266                      jacksonville-fl-usa-51491          Good
#> 267                             tampa-fl-usa-51591     Very Good
#> 268                             miami-fl-usa-51691          Good
#> 269                           orlando-fl-usa-51791          Good
#> 270                       gainesville-fl-usa-51891          Good
#> 271                         pensacola-fl-usa-52091          Poor
#> 272                        birmingham-al-usa-52191          Good
#> 273                           memphis-tn-usa-52291          Good
#> 274                       little-rock-ar-usa-52391          Poor
#> 275                            dallas-tx-usa-52491          Good
#> 276                            austin-tx-usa-52591     Very Good
#> 277                           houston-tx-usa-52691          Good
#> 278                            edmond-ok-usa-53091     Very Good
#> 279                          lawrence-ks-usa-53191          Good
#> 280                      fayetteville-ar-usa-60191          Poor
#> 281                       springfield-mo-usa-60291          Good
#> 282                          columbia-mo-usa-60391          Good
#> 283                          st-louis-mo-usa-60491          Good
#> 284                         champaign-il-usa-60691          Good
#> 285                      indianapolis-in-usa-60791          Good
#> 286                        louisville-ky-usa-60891          Good
#> 287                         lexington-ky-usa-60991          Poor
#> 288                        cincinnati-oh-usa-61091          Good
#> 289                            dayton-oh-usa-61191          Good
#> 290                          columbus-oh-usa-61291          Good
#> 291                         cleveland-oh-usa-61391     Very Good
#> 292                        pittsburgh-pa-usa-61491          Good
#> 293                        washington-dc-usa-61791          Good
#> 294                        washington-dc-usa-72891          Good
#> 295                        washington-dc-usa-72991     Very Good
#> 296                       montreal-qc-canada-80291          Good
#> 297                         ottawa-on-canada-80391          Good
#> 298                        toronto-on-canada-80491     Very Good
#> 299                           detroit-mi-usa-80591     Very Good
#> 300                         kalamazoo-mi-usa-80691     Very Good
#> 301                           chicago-il-usa-80891          Good
#> 302                           madison-wi-usa-80991          Good
#> 303                         milwaukee-wi-usa-81091     Very Good
#> 304                         green-bay-wi-usa-81191          Good
#> 305                       minneapolis-mn-usa-81291     Very Good
#> 306                             fargo-nd-usa-81391          Good
#> 307                       winnipeg-mb-canada-81491     Very Good
#> 308                         regina-sk-canada-81591          Good
#> 309                        calgary-ab-canada-81791     Very Good
#> 310                      vancouver-bc-canada-81991     Very Good
#> 311                           olympia-wa-usa-82591          Good
#> 312                           seattle-wa-usa-82691     Very Good
#> 313                          portland-or-usa-82791     Very Good
#> 314                          petaluma-ca-usa-83091          Good
#> 315                           oakland-ca-usa-83191          Good
#> 316                          berkeley-ca-usa-90191     Very Good
#> 317                        sacramento-ca-usa-90391     Very Good
#> 318                        isla-vista-ca-usa-90591     Very Good
#> 319                    jawbone-canyon-ca-usa-90691          Good
#> 320                       los-angeles-ca-usa-90891          Good
#> 321                           phoenix-az-usa-90991     Very Good
#> 322                       albuquerque-nm-usa-91191          Good
#> 323                            denver-co-usa-91391     Very Good
#> 324                           lincoln-ne-usa-91491     Very Good
#> 325                   geelong-vic-australia-101791     Very Good
#> 326                 melbourne-vic-australia-101891     Very Good
#> 327                   croydon-vic-australia-101991     Very Good
#> 328                 melbourne-vic-australia-102091     Very Good
#> 329                   adelaide-sa-australia-102291          Good
#> 330                  canberra-nsw-australia-102391     Very Good
#> 331                    sydney-nsw-australia-102591          Good
#> 332                     manly-nsw-australia-102691     Very Good
#> 333                    sydney-nsw-australia-102791     Very Good
#> 334                gold-coast-qld-australia-110191     Very Good
#> 335                  brisbane-qld-australia-110291          Good
#> 336                 byron-bay-nsw-australia-110391          Good
#> 337                    auckland-new-zealand-110891          Good
#> 338                             tokyo-japan-111191     Very Good
#> 339                             tokyo-japan-111291          Good
#> 340                             osaka-japan-111491     Very Good
#> 341                         honolulu-hi-usa-111891     Very Good
#> 342                       washington-dc-usa-120891          Good
#> 343                       los-angeles-ca-usa-12492          Good
#> 344                       los-angeles-ca-usa-12592          Good
#> 345                        washington-dc-usa-30692     Very Good
#> 346                        washington-dc-usa-40392     Very Good
#> 347                        washington-dc-usa-40492          Good
#> 348                      philadelphia-pa-usa-40692     Very Good
#> 349                           hoboken-nj-usa-40792          Good
#> 350                            latham-ny-usa-40992          Good
#> 351                        bennington-vt-usa-41092          Good
#> 352                         worcester-ma-usa-41192          Good
#> 353                          portland-me-usa-41292     Very Good
#> 354                         new-haven-ct-usa-41392          Good
#> 355                    amsterdam-netherlands-50192          Good
#> 356                       whitstable-england-50492     Very Good
#> 357                       portsmouth-england-50592          Good
#> 358                        cambridge-england-50692     Very Good
#> 359                          norwich-england-50792     Excellent
#> 360                       nottingham-england-50892     Very Good
#> 361                           london-england-50992     Excellent
#> 362                           dublin-ireland-51192     Very Good
#> 363                 belfast-northern-ireland-51292     Very Good
#> 364                       manchester-england-51492     Very Good
#> 365                        newcastle-england-51592     Very Good
#> 366                         glasgow-scotland-51692     Very Good
#> 367                         bradford-england-51792          Good
#> 368                    groningen-netherlands-52092     Very Good
#> 369                    den-bosch-netherlands-52192     Very Good
#> 370                         tongeren-belgium-52292          Good
#> 371                        venlo-netherlands-52392          Poor
#> 372                     den-haag-netherlands-52492          Good
#> 373                        diksmuide-belgium-52692          Good
#> 374                             paris-france-52792     Very Good
#> 375                          poitiers-france-52892     Very Good
#> 376                          bordeaux-france-52992     Very Good
#> 377                          toulouse-france-53092          Good
#> 378                          barcelona-spain-53192     Very Good
#> 379                             madrid-spain-60292     Very Good
#> 380                           zaragoza-spain-60392     Very Good
#> 381                             torino-italy-60592     Very Good
#> 382                               pisa-italy-60692          Good
#> 383                               rome-italy-60792     Very Good
#> 384                             modena-italy-60892     Very Good
#> 385                             padova-italy-60992          Good
#> 386                       ljubljana-slovenia-61092          Good
#> 387                         budapest-hungary-61192          Good
#> 388                    prague-czechoslovakia-61392     Very Good
#> 389                           vienna-austria-61492     Very Good
#> 390                             wels-austria-61592     Very Good
#> 391                           munich-germany-61692     Very Good
#> 392                         hohenems-austria-61792          Good
#> 393                       zurich-switzerland-61892     Very Good
#> 394                        frankfurt-germany-61992          Good
#> 395                              ulm-germany-62092          Good
#> 396                        nuremberg-germany-62292          Good
#> 397        neuhausen-auf-den-fildern-germany-62392          Good
#> 398                   v-schwenningen-germany-62492          Good
#> 399                         hannover-germany-62592          Good
#> 400                            poznan-poland-62692          Good
#> 401                           berlin-germany-62892     Very Good
#> 402                        osnabruck-germany-62992          Good
#> 403                         dortmund-germany-63092     Very Good
#> 404                             koln-germany-70192          Good
#> 405                          hamburg-germany-70292          Good
#> 406                           bremen-germany-70392     Very Good
#> 407                       copenhagen-denmark-70492          Good
#> 408                              oslo-norway-70692          Good
#> 409                             gavle-sweden-70892          Good
#> 410                     nijmegen-netherlands-71192          Good
#> 411                        washington-dc-usa-72592          Good
#> 412                       washington-dc-usa-083192          Good
#> 413                       washington-dc-usa-102392          Good
#> 414                        baltimore-md-usa-102592          Good
#> 415                    virginia-beach-va-usa-20493     Very Good
#> 416                       chapel-hill-nc-usa-20593     Very Good
#> 417                        wilmington-nc-usa-20693     Very Good
#> 418                          columbia-sc-usa-20793          Good
#> 419                         charlotte-nc-usa-20893          Poor
#> 420                           atlanta-ga-usa-20993          Good
#> 421                           atlanta-ga-usa-21093          Good
#> 422                          savannah-ga-usa-21193          Good
#> 423                      jacksonville-fl-usa-21293     Very Good
#> 424                           orlando-fl-usa-21393     Very Good
#> 425                   fort-lauderdale-fl-usa-21493     Very Good
#> 426                             tampa-fl-usa-21693          Good
#> 427                       gainesville-fl-usa-21793     Very Good
#> 428                            athens-ga-usa-21893     Very Good
#> 429                            athens-ga-usa-21993     Very Good
#> 430                        greensboro-nc-usa-22093     Very Good
#> 431                          richmond-va-usa-22193     Very Good
#> 432                        washington-dc-usa-32193          Poor
#> 433                      college-park-md-usa-40293     Very Good
#> 434                   charlottesville-va-usa-40493          Good
#> 435                         knoxville-tn-usa-40593          Good
#> 436                         nashville-tn-usa-40693     Very Good
#> 437                           memphis-tn-usa-40793     Very Good
#> 438                           jackson-ms-usa-40893          Good
#> 439                       new-orleans-la-usa-40993     Very Good
#> 440                           houston-tx-usa-41093          Good
#> 441                             bryan-tx-usa-41193     Very Good
#> 442                            austin-tx-usa-41293          Good
#> 443                            austin-tx-usa-41393          Good
#> 444                       san-antonio-tx-usa-41493     Very Good
#> 445                            dallas-tx-usa-41693          Good
#> 446                            norman-ok-usa-41793     Very Good
#> 447                           lubbock-tx-usa-41893     Very Good
#> 448                           el-paso-tx-usa-41993          Good
#> 449                            tucson-az-usa-42093     Very Good
#> 450                         las-vegas-nv-usa-42293          Good
#> 451                       los-angeles-ca-usa-42393          Good
#> 452                       los-angeles-ca-usa-42493     Very Good
#> 453                       los-angeles-ca-usa-42593     Very Good
#> 454                         san-diego-ca-usa-42693     Very Good
#> 455                     santa-barbara-ca-usa-42793          Good
#> 456                       watsonville-ca-usa-42893          Good
#> 457                          berkeley-ca-usa-43093          Good
#> 458                    san-franscisco-ca-usa-50193     Very Good
#> 459                        sacramento-ca-usa-50293          Good
#> 460                            eugene-or-usa-50493          Poor
#> 461                          portland-or-usa-50593     Very Good
#> 462                           seattle-wa-usa-50693          Good
#> 463                      vancouver-bc-canada-50793     Very Good
#> 464                           olympia-wa-usa-50893     Very Good
#> 465                          bellevue-wa-usa-50993     Very Good
#> 466                         kennewick-wa-usa-51493          Good
#> 467                             boise-id-usa-51593          Good
#> 468                    salt-lake-city-ut-usa-51693     Very Good
#> 469                            denver-co-usa-51893     Very Good
#> 470                           laramie-wy-usa-51993          Poor
#> 471                             omaha-ne-usa-52193     Very Good
#> 472                        des-moines-ia-usa-52293          Good
#> 473                       minneapolis-mn-usa-52393     Very Good
#> 474                       minneapolis-mn-usa-52493     Very Good
#> 475                       minneapolis-mn-usa-52593     Very Good
#> 476                         green-bay-wi-usa-52693     Very Good
#> 477                           chicago-il-usa-52893     Very Good
#> 478                           chicago-il-usa-52993     Very Good
#> 479                      indianapolis-in-usa-53093          Poor
#> 480                          columbus-oh-usa-53193     Very Good
#> 481                        washington-dc-usa-80793     Very Good
#> 482                        washington-dc-usa-80993     Very Good
#> 483                           hoboken-nj-usa-81693     Very Good
#> 484                           trenton-nj-usa-81793     Very Good
#> 485                           trenton-nj-usa-81893     Very Good
#> 486                     mechanicsburg-pa-usa-81993     Very Good
#> 487                        pittsburgh-pa-usa-82093          Good
#> 488                            dayton-oh-usa-82193     Very Good
#> 489                        cincinnati-oh-usa-82293     Very Good
#> 490                        carbondale-il-usa-82493     Very Good
#> 491                          st-louis-mo-usa-82593     Very Good
#> 492                          st-louis-mo-usa-82693     Very Good
#> 493                          columbia-mo-usa-82793     Very Good
#> 494                       kansas-city-ks-usa-82893     Very Good
#> 495                         iowa-city-ia-usa-82993          Good
#> 496                            normal-il-usa-90193     Very Good
#> 497                         milwaukee-wi-usa-90293     Very Good
#> 498                           chicago-il-usa-90393          Good
#> 499                           pontiac-mi-usa-90493     Very Good
#> 500                         cleveland-oh-usa-90593          Good
#> 501                           buffalo-ny-usa-90693     Very Good
#> 502                        guelph-ont-canada-90893          Good
#> 503                       toronto-ont-canada-90993          Good
#> 504                       toronto-ont-canada-91093     Very Good
#> 505                        ottawa-ont-canada-91193     Very Good
#> 506                       montreal-qc-canada-91293     Very Good
#> 507                        burlington-vt-usa-91393          Good
#> 508                          portland-me-usa-91493          Good
#> 509                        bennington-vt-usa-91693     Very Good
#> 510                         fitchburg-ma-usa-91793          Good
#> 511                            storrs-ct-usa-91893     Very Good
#> 512                        providence-ri-usa-91993     Excellent
#> 513                            albany-ny-usa-92093     Very Good
#> 514                          syracuse-ny-usa-92193     Very Good
#> 515                        binghamton-ny-usa-92293     Very Good
#> 516                     new-york-city-ny-usa-92493     Very Good
#> 517                     new-york-city-ny-usa-92593     Very Good
#> 518                     state-college-pa-usa-92693     Very Good
#> 519                      philadelphia-pa-usa-92793     Very Good
#> 520                      philadelphia-pa-usa-92893     Very Good
#> 521                    rehoboth-beach-de-usa-92993     Very Good
#> 522                             osaka-japan-103193          Good
#> 523                             kyoto-japan-110193     Very Good
#> 524                            nagoya-japan-110393     Very Good
#> 525                             tokyo-japan-110593     Very Good
#> 526                             tokyo-japan-110693     Very Good
#> 527                     singapore-singapore-110893          Good
#> 528                      adelaide-australia-111193          Good
#> 529                   croydon-vic-australia-111293          Good
#> 530                 melbourne-vic-australia-111393          Good
#> 531                 melbourne-vic-australia-111493          Good
#> 532                      canberra-australia-111793     Very Good
#> 533                    wollongong-australia-111893          Good
#> 534                         manly-australia-111993          Good
#> 535                        sydney-australia-112093          Good
#> 536                     newcastle-australia-112493     Very Good
#> 537                       lismore-australia-112693     Very Good
#> 538                  brisbane-qld-australia-112793          Good
#> 539                    sydney-nsw-australia-120193          Good
#> 540                    hobart-tas-australia-120393     Very Good
#> 541                launceston-tas-australia-120493     Very Good
#> 542                christchurch-new-zealand-120893     Very Good
#> 543                     dunedin-new-zealand-120993     Very Good
#> 544                  wellington-new-zealand-121093     Very Good
#> 545                    auckland-new-zealand-121193     Excellent
#> 546                    auckland-new-zealand-121293     Excellent
#> 547                         honolulu-hi-usa-121493          Good
#> 548                        washington-dc-usa-80494          Good
#> 549                    belo-horizonte-brazil-81594     Very Good
#> 550                    rio-de-janeiro-brazil-81894          Good
#> 551                          itaborai-brazil-81994     Very Good
#> 552                         sao-paulo-brazil-82094          Good
#> 553                         sao-paulo-brazil-82194          Good
#> 554                          curitiba-brazil-82594     Very Good
#> 555                          curitiba-brazil-82694     Very Good
#> 556                          curitiba-brazil-82794          Good
#> 557                    silver-spring-md-usa-112094     Very Good
#> 558                       washington-dc-usa-112794     Very Good
#> 559                       washington-dc-usa-112994     Very Good
#> 560                         baltimore-md-usa-30295     Very Good
#> 561                      philadelphia-pa-usa-40195     Excellent
#> 562                      philadelphia-pa-usa-40295     Very Good
#> 563                     new-york-city-ny-usa-40395     Very Good
#> 564                     new-york-city-ny-usa-40495          Good
#> 565                     new-york-city-ny-usa-40595     Very Good
#> 566                      poughkeepsie-ny-usa-40695     Very Good
#> 567                          hartford-ct-usa-40795     Very Good
#> 568                          portland-me-usa-40895     Very Good
#> 569                        burlington-vt-usa-40995          Good
#> 570                        providence-ri-usa-41195     Very Good
#> 571                        providence-ri-usa-41295     Very Good
#> 572                           hoboken-nj-usa-41395          Good
#> 573                            newark-de-usa-41495          Poor
#> 574                    eindhoven-netherlands-50495     Excellent
#> 575                         brighton-england-50695          Poor
#> 576                       manchester-england-50795          Good
#> 577                         glasgow-scotland-50895          Poor
#> 578                 belfast-northern-ireland-50995          Good
#> 579                           dublin-ireland-51095          Good
#> 580                       nottingham-england-51295     Very Good
#> 581                           london-england-51395     Very Good
#> 582                    wolverhampton-england-51495     Very Good
#> 583                            leeds-england-51595     Very Good
#> 584                    amsterdam-netherlands-51795     Very Good
#> 585                           leuven-belgium-51895          Good
#> 586                             gent-belgium-51995     Very Good
#> 587                             arras-france-52095          Good
#> 588                             nancy-france-52195     Very Good
#> 589                             paris-france-52295          Good
#> 590                          poitiers-france-52495     Very Good
#> 591                            angers-france-52595     Very Good
#> 592                          bordeaux-france-52695     Very Good
#> 593                     lakuntza-spainbasque-52795          Good
#> 594                             oviedo-spain-52895          Poor
#> 595             santiago-de-compostela-spain-52995     Very Good
#> 596                          lisbon-portugal-53195     Very Good
#> 597                             madrid-spain-60295     Very Good
#> 598                          barcelona-spain-60395     Very Good
#> 599                           valencia-spain-60495          Good
#> 600                          toulouse-france-60695          Good
#> 601                              lyon-france-60895     Very Good
#> 602                       kingersheim-france-61095          Good
#> 603                              milan-italy-61295     Very Good
#> 604                             padova-italy-61395     Very Good
#> 605                           florence-italy-61495     Very Good
#> 606                             torino-italy-61595     Very Good
#> 607                            bologna-italy-61695          Good
#> 608                     gavoi-sardinia-italy-61795     Very Good
#> 609                     catania-sicily-italy-61895     Very Good
#> 610                               rome-italy-62095     Very Good
#> 611                             verona-italy-62195          Good
#> 612                    gde-spilimbergo-italy-62295          Good
#> 613                       ljubljana-slovenia-62395          Good
#> 614                           vienna-austria-62495          Poor
#> 615                             wels-austria-62595     Very Good
#> 616                           munich-germany-62695     Very Good
#> 617                              ulm-germany-62795          Good
#> 618                    prague-czech-republic-62995     Very Good
#> 619                        stuttgart-germany-63095     Very Good
#> 620                            mainz-germany-70195          Good
#> 621                           berlin-germany-70295     Very Good
#> 622                         dortmund-germany-70395          Poor
#> 623                          hamburg-germany-70495     Very Good
#> 624                     nijmegen-netherlands-70595     Very Good
#> 625                    groningen-netherlands-70795     Very Good
#> 626                        bielefeld-germany-70895          Good
#> 627                           bremen-germany-70995          Good
#> 628                       copenhagen-denmark-71095     Excellent
#> 629                          tampere-finland-71295     Very Good
#> 630                              oslo-norway-71495     Very Good
#> 631                        washington-dc-usa-91695          Poor
#> 632                       lindenhurst-ny-usa-92195     Very Good
#> 633                       northampton-ma-usa-92295          Good
#> 634                       montreal-qc-canada-92395          Good
#> 635                    quebec-city-qc-canada-92495          Good
#> 636                         ottawa-on-canada-92695     Very Good
#> 637                        toronto-on-canada-92795          Good
#> 638                         rochester-ny-usa-92895          Good
#> 639                        pittsburgh-pa-usa-92995     Very Good
#> 640                          detroit-mi-usa-100195          Good
#> 641                        cleveland-oh-usa-100295     Very Good
#> 642                         columbus-oh-usa-100395          Good
#> 643                           dayton-oh-usa-100495          Good
#> 644                       cincinnati-oh-usa-100595     Very Good
#> 645                     indianapolis-in-usa-100695          Good
#> 646                       louisville-ky-usa-100795     Excellent
#> 647                         st-louis-mo-usa-100895     Very Good
#> 648                           peoria-il-usa-100995     Very Good
#> 649                          chicago-il-usa-101095     Very Good
#> 650                        green-bay-wi-usa-101295     Very Good
#> 651                        milwaukee-wi-usa-101395          Good
#> 652                      minneapolis-mn-usa-101495     Very Good
#> 653                      minneapolis-mn-usa-101595     Very Good
#> 654                             ames-ia-usa-101795          Good
#> 655                          lincoln-ne-usa-101895     Very Good
#> 656                      sioux-falls-sd-usa-101995          Good
#> 657                       rapid-city-sd-usa-102095          Poor
#> 658                           denver-co-usa-102295          Good
#> 659                   salt-lake-city-ut-usa-102495          Good
#> 660                            boise-id-usa-102595     Very Good
#> 661                           yakima-wa-usa-102695     Very Good
#> 662                          seattle-wa-usa-102795     Very Good
#> 663                          olympia-wa-usa-102995     Very Good
#> 664                        anchorage-ak-usa-110195     Very Good
#> 665                         portland-or-usa-110295     Very Good
#> 666                       sacramento-ca-usa-110495          Good
#> 667                    san-francisco-ca-usa-110595     Very Good
#> 668                    san-francisco-ca-usa-110695     Very Good
#> 669                      bakersfield-ca-usa-110795     Very Good
#> 670                      los-angeles-ca-usa-110895          Good
#> 671                      los-angeles-ca-usa-110995     Very Good
#> 672                        san-diego-ca-usa-111095     Very Good
#> 673                          phoenix-az-usa-111195     Very Good
#> 674                      albuquerque-nm-usa-111395     Very Good
#> 675                          el-paso-tx-usa-111495          Good
#> 676                           austin-tx-usa-111695     Very Good
#> 677                           austin-tx-usa-111795     Very Good
#> 678                      san-antonio-tx-usa-111895     Very Good
#> 679                           dallas-tx-usa-111995          Good
#> 680                    oklahoma-city-ok-usa-112095     Very Good
#> 681                        washington-dc-usa-13096     Very Good
#> 682                        washington-dc-usa-13196     Excellent
#> 683                           norfolk-va-usa-31996     Very Good
#> 684                        wilmington-nc-usa-32096     Very Good
#> 685                     winston-salem-nc-usa-32196          Good
#> 686                         charlotte-nc-usa-32396     Very Good
#> 687                          columbia-sc-usa-32496     Very Good
#> 688                            athens-ga-usa-32696     Very Good
#> 689                        huntsville-al-usa-32796     Very Good
#> 690                           atlanta-ga-usa-32896     Very Good
#> 691                           atlanta-ga-usa-32996     Very Good
#> 692                          savannah-ga-usa-33096     Very Good
#> 693                      jacksonville-fl-usa-33196          Good
#> 694                           orlando-fl-usa-40196          Good
#> 695                   fort-lauderdale-fl-usa-40296     Very Good
#> 696                             tampa-fl-usa-40396          Good
#> 697                       new-orleans-la-usa-40596     Very Good
#> 698                         lafayette-la-usa-40796          Poor
#> 699                           houston-tx-usa-40896     Very Good
#> 700                            oxford-ms-usa-41096          Good
#> 701                         nashville-tn-usa-41196     Very Good
#> 702                         knoxville-tn-usa-41296     Very Good
#> 703                           roanoke-va-usa-41396     Very Good
#> 704                          richmond-va-usa-41496     Very Good
#> 705                        washington-dc-usa-41996     Very Good
#> 706                           washington-dc-081596          Poor
#> 707                        washington-dc-usa-92996     Very Good
#> 708                         honolulu-hi-usa-101696     Very Good
#> 709                             maui-hi-usa-101796     Very Good
#> 710                             maui-hi-usa-101896     Very Good
#> 711                           fukuoka-japan-102196     Very Good
#> 712                           okayama-japan-102296     Excellent
#> 713                             osaka-japan-102396     Very Good
#> 714                            nagoya-japan-102596     Very Good
#> 715                             tokyo-japan-102696     Very Good
#> 716                             tokyo-japan-102796     Very Good
#> 717                             tokyo-japan-102896     Excellent
#> 718                           sapporo-japan-103096     Very Good
#> 719                           sapporo-japan-103196     Very Good
#> 720                     hong-kong-hong-kong-110296     Very Good
#> 721                   kuala-lumpur-malaysia-110696     Very Good
#> 722                     singapore-singapore-110896          Good
#> 723                         perth-australia-111096     Very Good
#> 724                      adelaide-australia-111296     Very Good
#> 725                     hobart-tz-australia-111396     Very Good
#> 726                    sydney-nsw-australia-111596     Excellent
#> 727                     newcastle-australia-111696     Very Good
#> 728                        sydney-australia-111796     Very Good
#> 729                     new-york-city-ny-usa-50197          Good
#> 730                     new-york-city-ny-usa-50297     Very Good
#> 731                      philadelphia-pa-usa-50397          Good
#> 732                            durham-nh-usa-50497     Very Good
#> 733                           clinton-ma-usa-50597          Good
#> 734                        providence-ri-usa-50697     Very Good
#> 735                       canberra-australia-61397     Very Good
#> 736                         sydney-australia-61497          Good
#> 737                         sydney-australia-61597          Poor
#> 738                      melbourne-australia-61797     Very Good
#> 739                      melbourne-australia-61897     Excellent
#> 740                       ballarat-australia-61997     Very Good
#> 741                        geelong-australia-62097     Very Good
#> 742                       brisbane-australia-62197     Very Good
#> 743                        lismore-australia-62397          Good
#> 744                         darwin-australia-62597     Very Good
#> 745                     auckland-new-zealand-62797          Good
#> 746                   wellington-new-zealand-62897     Very Good
#> 747                       nelson-new-zealand-62997     Very Good
#> 748                      dunedin-new-zealand-70197     Very Good
#> 749                 christchurch-new-zealand-70297          Poor
#> 750                        piracicaba-brazil-80597          Poor
#> 751                         sao-paulo-brazil-80697     Very Good
#> 752                           vitoria-brazil-80797     Very Good
#> 753                          brasilia-brazil-80997          Good
#> 754                          brasilia-brazil-81097     Very Good
#> 755                          curitiba-brazil-81497          Good
#> 756                         joinville-brazil-81597     Very Good
#> 757                    belo-horizonte-brazil-81697     Very Good
#> 758                          campinas-brazil-81997          Poor
#> 759                            santos-brazil-82097     Excellent
#> 760                        washington-dc-usa-82997     Very Good
#> 761                        washington-dc-usa-90397     Very Good
#> 762                        hagerstown-md-usa-50198     Excellent
#> 763                        pittsburgh-pa-usa-50298     Very Good
#> 764                          columbus-oh-usa-50398     Very Good
#> 765                              kent-oh-usa-50498          Good
#> 766                         cleveland-oh-usa-50598     Very Good
#> 767                        cincinnati-oh-usa-50698          Good
#> 768                           chicago-il-usa-50798          Good
#> 769                           chicago-il-usa-50898          Poor
#> 770                           detroit-mi-usa-50998     Very Good
#> 771                          richmond-va-usa-51198     Very Good
#> 772                         baltimore-md-usa-51298          Poor
#> 773                      poughkeepsie-ny-usa-71698          Good
#> 774                          syracuse-ny-usa-71798          Good
#> 775                         rochester-ny-usa-71898     Very Good
#> 776                        toronto-on-canada-71998     Very Good
#> 777                         ottawa-on-canada-72098     Very Good
#> 778                       montreal-qc-canada-72198     Very Good
#> 779                    quebec-city-qc-canada-72298          Poor
#> 780                    fredericton-nb-canada-72498     Very Good
#> 781                        halifax-ns-canada-72598     Very Good
#> 782                          portland-me-usa-72698          Good
#> 783                           hoboken-nj-usa-72798          Good
#> 784                        washington-dc-usa-73098          Poor
#> 785                        washington-dc-usa-73198          Poor
#> 786                        milwaukee-wi-usa-111398          Good
#> 787                       eau-claire-wi-usa-111498          Good
#> 788                      minneapolis-mn-usa-111598     Very Good
#> 789                       des-moines-ia-usa-111698     Very Good
#> 790                            omaha-ne-usa-111798     Very Good
#> 791                           olathe-ks-usa-111898     Very Good
#> 792                    oklahoma-city-ok-usa-111998          Good
#> 793                          houston-tx-usa-112198     Very Good
#> 794                           austin-tx-usa-112298     Very Good
#> 795                           dallas-tx-usa-112398     Very Good
#> 796                           conway-ar-usa-112498     Very Good
#> 797                          memphis-tn-usa-112598          Good
#> 798                         st-louis-mo-usa-112698          Good
#> 799                       louisville-ky-usa-112798          Good
#> 800                       charleston-wv-usa-112898     Very Good
#> 801                       morgantown-wv-usa-112998          Poor
#> 802                       washington-dc-usa-120398     Very Good
#> 803                          fairfax-va-usa-120498     Very Good
#> 804                         san-diego-ca-usa-21899     Very Good
#> 805                           ventura-ca-usa-21999     Very Good
#> 806                       watsonville-ca-usa-22099     Very Good
#> 807                         palo-alto-ca-usa-22199     Excellent
#> 808                     san-francisco-ca-usa-22299     Very Good
#> 809                              reno-nv-usa-22399          Good
#> 810                        sacramento-ca-usa-22499     Very Good
#> 811                          portland-or-usa-22699     Very Good
#> 812                           olympia-wa-usa-22799     Very Good
#> 813                           seattle-wa-usa-22899     Excellent
#> 814                       springfield-or-usa-30299          Good
#> 815                             chico-ca-usa-30399     Very Good
#> 816                       bakersfield-ca-usa-30499     Very Good
#> 817                         las-vegas-nv-usa-30599     Very Good
#> 818                       victorville-ca-usa-30699     Very Good
#> 819                            pomona-ca-usa-30799          Good
#> 820                 los-angeles-ca-usa-palace-3899     Excellent
#> 821                       los-angeles-ca-usa-30999     Excellent
#> 822                       los-angeles-ca-usa-31099     Excellent
#> 823                        reykjavik-iceland-42799     Excellent
#> 824                            leeds-england-42999          Good
#> 825                    wolverhampton-england-43099     Very Good
#> 826                        newcastle-england-50299     Very Good
#> 827                       edinburgh-scotland-50399          Good
#> 828                        aberdeen-scotland-50499     Very Good
#> 829                         glasgow-scotland-50599     Very Good
#> 830                         kilkenny-ireland-50799     Very Good
#> 831                             cork-ireland-50899     Very Good
#> 832                           dublin-ireland-50999     Very Good
#> 833                            newport-wales-51199     Very Good
#> 834                       nottingham-england-51399     Very Good
#> 835                         brighton-england-51499     Very Good
#> 836                           london-england-51599          Good
#> 837                        washington-dc-usa-82699     Excellent
#> 838                    amsterdam-netherlands-91699     Very Good
#> 839                          bremen-germany-091799          Good
#> 840                          hamburg-germany-91899     Very Good
#> 841                           berlin-germany-92099     Very Good
#> 842                           wroclaw-poland-92199     Excellent
#> 843                          leipzig-germany-92299          Good
#> 844                        nuremberg-germany-92499     Very Good
#> 845                           munich-germany-92599     Very Good
#> 846                           vienna-austria-92699     Excellent
#> 847                       ljubljana-slovenia-92899          Good
#> 848                               rome-italy-93099     Very Good
#> 849                          florence-italy-100199     Excellent
#> 850                             milan-italy-100299     Very Good
#> 851                      zurich-switzerland-100599     Very Good
#> 852                      geneva-switzerland-100699     Very Good
#> 853                        marseille-france-100799     Very Good
#> 854                         barcelona-spain-100899     Very Good
#> 855                         bordeaux-france-101199     Very Good
#> 856                           nantes-france-101399     Very Good
#> 857                            paris-france-101499     Very Good
#> 858                        brussels-belgium-101599     Very Good
#> 859                     tilburg-netherlands-101699     Excellent
#> 860                       providence-ri-usa-120299     Excellent
#> 861                    new-york-city-ny-usa-120399     Very Good
#> 862                     philadelphia-pa-usa-120499     Excellent
#> 863                       washington-dc-usa-120599     Very Good
#> 864                  charlottesville-va-usa-120899     Excellent
#> 865                          atlanta-ga-usa-121799     Very Good
#> 866                           athens-ga-usa-121899     Very Good
#> 867                        knoxville-tn-usa-121999     Very Good
#> 868                        nashville-tn-usa-122099     Very Good
#> 869                           raleigh-nc-usa-11200     Excellent
#> 870                         charlotte-nc-usa-11300     Very Good
#> 871                       gainesville-fl-usa-11500     Very Good
#> 872                           orlando-fl-usa-11600     Excellent
#> 873                   fort-lauderdale-fl-usa-11800     Very Good
#> 874                             tampa-fl-usa-11900     Very Good
#> 875                       tallahassee-fl-usa-12000     Very Good
#> 876                     san-francisco-ca-usa-60400          Good
#> 877                        washington-dc-usa-62700     Very Good
#> 878                        washington-dc-usa-80700          Good
#> 879                              umea-sweden-93000     Very Good
#> 880                        stockholm-sweden-100100     Very Good
#> 881                             oslo-norway-100200     Excellent
#> 882                        trondheim-norway-100300     Very Good
#> 883                           bergen-norway-100400     Excellent
#> 884                        jonkoping-sweden-100600          Good
#> 885                      copenhagen-denmark-100700     Excellent
#> 886                             lund-sweden-100800     Very Good
#> 887                        helsinki-finland-101000     Very Good
#> 888                            denver-co-usa-40501     Very Good
#> 889                            denver-co-usa-40601     Excellent
#> 890                  colorado-springs-co-usa-40701     Excellent
#> 891                       albuquerque-nm-usa-40801     Excellent
#> 892                           el-paso-tx-usa-40901          Good
#> 893                            tucson-az-usa-41001     Excellent
#> 894                           phoenix-az-usa-41201     Very Good
#> 895                           laramie-wy-usa-41601     Excellent
#> 896                           lincoln-ne-usa-41701     Very Good
#> 897                       kansas-city-mo-usa-41801     Excellent
#> 898                          columbia-mo-usa-41901     Very Good
#> 899                      indianapolis-in-usa-42001     Very Good
#> 900                        pittsburgh-pa-usa-42101     Very Good
#> 901                        washington-dc-usa-42501     Excellent
#> 902                        washington-dc-usa-42701     Very Good
#> 903                      severna-park-md-usa-62101     Very Good
#> 904                           chicago-il-usa-62301     Very Good
#> 905                           chicago-il-usa-62401     Very Good
#> 906                         green-bay-wi-usa-62601     Very Good
#> 907                       minneapolis-mn-usa-62701     Very Good
#> 908                             fargo-nd-usa-62801     Very Good
#> 909                       winnipeg-mb-canada-62901     Very Good
#> 910                         regina-sk-canada-63001     Very Good
#> 911                      saskatoon-sk-canada-70101     Very Good
#> 912                       edmonton-ab-canada-70201     Very Good
#> 913                        calgary-ab-canada-70301     Very Good
#> 914                        kelowna-bc-canada-70501     Very Good
#> 915                       victoria-bc-canada-70601     Very Good
#> 916                        burnaby-bc-canada-70701     Excellent
#> 917                        washington-dc-usa-81301     Very Good
#> 918                          richmond-va-usa-32202     Very Good
#> 919                           raleigh-nc-usa-32302     Excellent
#> 920                         asheville-nc-usa-32402     Very Good
#> 921                        birmingham-al-usa-32502     Very Good
#> 922                       new-orleans-la-usa-32702     Very Good
#> 923                           houston-tx-usa-32802     Very Good
#> 924                       san-antonio-tx-usa-32902     Excellent
#> 925                            austin-tx-usa-33002     Very Good
#> 926                            austin-tx-usa-33102     Very Good
#> 927                        fort-worth-tx-usa-40102     Very Good
#> 928                       little-rock-ar-usa-40202     Very Good
#> 929                        louisville-ky-usa-40402     Very Good
#> 930                        huntington-wv-usa-40502     Very Good
#> 931                      harrisonburg-va-usa-40602     Very Good
#> 932                           holyoke-ma-usa-51802     Excellent
#> 933                            boston-ma-usa-51902     Very Good
#> 934                            boston-ma-usa-42002     Very Good
#> 935                        washington-dc-usa-70102     Very Good
#> 936                        brighton-england-102002     Very Good
#> 937                          exeter-england-102102     Very Good
#> 938                      birmingham-england-102202     Very Good
#> 939                      nottingham-england-102302     Very Good
#> 940                          dublin-ireland-102502          Good
#> 941                        limerick-ireland-102602          Good
#> 942                  derry-northern-ireland-102702     Very Good
#> 943                        glasgow-scotland-102902     Very Good
#> 944                      manchester-england-103002     Very Good
#> 945                           leeds-england-103102     Excellent
#> 946                         bristol-england-110102     Very Good
#> 947                          london-england-110202          Good
#> 948                          london-england-110302     Very Good
#> 949                          london-england-110402     Very Good
```
