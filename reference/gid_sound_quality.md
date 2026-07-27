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
#> 34                        washington-dc-usa-100688     Very Good
#> 35                    rotterdam-netherlands-101488          Poor
#> 36                        hoorn-netherlands-101588          Good
#> 37                             gent-belgium-101688          Poor
#> 38                    amsterdam-netherlands-101688          Good
#> 39                           lubeck-germany-102188          Good
#> 40                              oslo-norway-102588     Very Good
#> 41                        bielefeld-germany-103188          Poor
#> 42                           nagold-germany-110488          Good
#> 43                         augsburg-germany-110588          Good
#> 44                             linz-austria-111088          Good
#> 45                              udine-italy-111488          Good
#> 46                               rome-italy-111788          Good
#> 47                              milan-italy-111988          Good
#> 48                             torino-italy-112088          Good
#> 49                             paris-france-112288          Good
#> 50                           london-england-112488          Poor
#> 51                        liverpool-england-112688          Good
#> 52                           dublin-ireland-112988          Poor
#> 53                            leeds-england-113088     Very Good
#> 54                            wigan-england-120188          Good
#> 55                       canterbury-england-120288          Good
#> 56                           london-england-120588          Good
#> 57                        washington-dc-usa-122988          Good
#> 58                         washington-dc-usa-12689          Poor
#> 59                         washington-dc-usa-32489          Poor
#> 60                           new-york-ny-usa-40589          Good
#> 61                          princeton-nj-usa-40689          Poor
#> 62                            norwalk-ct-usa-40789          Good
#> 63                         middletown-ct-usa-40889          Good
#> 64                            hoboken-nj-usa-40989          Good
#> 65                        chapel-hill-nc-usa-50189          Poor
#> 66                             athens-ga-usa-50389          Good
#> 67                            atlanta-ga-usa-50589          Good
#> 68                          fortworth-tx-usa-51189          Good
#> 69                            phoenix-az-usa-51689          Good
#> 70                        los-angeles-ca-usa-51889          Good
#> 71                           berkeley-ca-usa-52089          Poor
#> 72                     salt-lake-city-ut-usa-60189          Good
#> 73                           st-louis-mo-usa-60589          Good
#> 74                          milwaukee-wi-usa-60989          Poor
#> 75                         pittsburgh-pa-usa-61689          Good
#> 76                         washington-dc-usa-62289          Poor
#> 77                         washington-dc-usa-71989          Good
#> 78                         washington-dc-usa-72089          Poor
#> 79                         washington-dc-usa-92289          Good
#> 80                       philadelphia-pa-usa-92389          Good
#> 81                          guelph-on-canada-93089          Good
#> 82                        toronto-on-canada-100189          Good
#> 83                        providence-ri-usa-100589     Very Good
#> 84                           hoboken-nj-usa-100889          Good
#> 85                          new-york-ny-usa-100989          Good
#> 86                        washington-dc-usa-101589          Good
#> 87                    amsterdam-netherlands-110389          Good
#> 88                     nijmegen-netherlands-110989     Very Good
#> 89                       canterbury-england-111389          Good
#> 90                         brighton-england-111489          Poor
#> 91                           exeter-england-111689          Poor
#> 92                       birmingham-england-111989          Good
#> 93                            leeds-england-112089          Good
#> 94                          bristol-england-112289          Good
#> 95                           dublin-ireland-112389          Good
#> 96                 belfast-northern-ireland-112489          Poor
#> 97                        liverpool-england-112589          Good
#> 98                        newcastle-england-112689          Good
#> 99                         glasgow-scotland-112789          Poor
#> 100                      manchester-england-112889     Very Good
#> 101                          london-england-112989     Very Good
#> 102                      heidelberg-germany-120489          Good
#> 103                   groningen-netherlands-120789          Good
#> 104                   eindhoven-netherlands-120889          Good
#> 105                   amsterdam-netherlands-120989          Good
#> 106                            paris-france-121189          Good
#> 107                        washington-dc-usa-12790          Good
#> 108                         baltimore-md-usa-21190          Good
#> 109                         frederick-md-usa-21690          Good
#> 110                    virginia-beach-va-usa-31090     Very Good
#> 111                      harrisonburg-va-usa-31190          Good
#> 112                        greensboro-nc-usa-31290          Good
#> 113                          florence-sc-usa-31390          Good
#> 114                            athens-ga-usa-31490     Very Good
#> 115                           atlanta-ga-usa-31590          Good
#> 116                       gainesville-fl-usa-31690     Very Good
#> 117                           orlando-fl-usa-31790          Good
#> 118                         pensacola-fl-usa-31990     Very Good
#> 119                       new-orleans-la-usa-32190          Good
#> 120                         nashville-tn-usa-32390          Good
#> 121                         knoxville-tn-usa-32490          Good
#> 122                       chapel-hill-nc-usa-32590     Very Good
#> 123                      poughkeepsie-ny-usa-41390          Good
#> 124                       northampton-ma-usa-41490     Very Good
#> 125                            boston-ma-usa-42090          Good
#> 126                        providence-ri-usa-42190          Good
#> 127                          columbia-md-usa-42790          Good
#> 128                           memphis-tn-usa-50290     Very Good
#> 129                       little-rock-ar-usa-50390     Very Good
#> 130                            dallas-tx-usa-50490     Very Good
#> 131                            austin-tx-usa-50590     Very Good
#> 132                           houston-tx-usa-50690          Good
#> 133                       san-antonio-tx-usa-50790     Very Good
#> 134                            tucson-az-usa-51190          Good
#> 135                           phoenix-az-usa-51290          Good
#> 136                         encinitas-ca-usa-51590          Poor
#> 137                            reseda-ca-usa-51690     Very Good
#> 138                            reseda-ca-usa-51790     Very Good
#> 139                        isla-vista-ca-usa-51890     Very Good
#> 140                     san-francisco-ca-usa-51990          Good
#> 141                          berkeley-ca-usa-52090          Good
#> 142                             chico-ca-usa-52490          Good
#> 143                            eureka-ca-usa-52590          Poor
#> 144                            eugene-or-usa-52690          Good
#> 145                        bellingham-wa-usa-53090     Very Good
#> 146                          portland-or-usa-53190          Good
#> 147                           seattle-wa-usa-60190          Good
#> 148                           olympia-wa-usa-60290          Good
#> 149                          missoula-mt-usa-60490     Excellent
#> 150                    salt-lake-city-ut-usa-60690     Very Good
#> 151                            denver-co-usa-60890          Good
#> 152                             omaha-ne-usa-61090          Good
#> 153                          lawrence-ks-usa-61190          Good
#> 154                      fayetteville-ar-usa-61290          Good
#> 155                          st-louis-mo-usa-61390          Good
#> 156                           chicago-il-usa-61490          Good
#> 157                          waukesha-wi-usa-61590          Poor
#> 158                       minneapolis-mn-usa-61690          Good
#> 159                         green-bay-wi-usa-61890          Poor
#> 160                           madison-wi-usa-61990          Good
#> 161                             flint-mi-usa-62190          Good
#> 162                           detroit-mi-usa-62290          Poor
#> 163                         ann-arbor-mi-usa-62390          Poor
#> 164                         kalamazoo-mi-usa-62490          Good
#> 165                            toledo-oh-usa-62590          Good
#> 166                        louisville-ky-usa-62690          Good
#> 167                            dayton-oh-usa-62790          Poor
#> 168                             akron-oh-usa-62890          Good
#> 169                        pittsburgh-pa-usa-62990          Good
#> 170                        morgantown-wv-usa-63090          Good
#> 171                        washington-dc-usa-70690          Good
#> 172                        hoorn-netherlands-90190          Good
#> 173                    groningen-netherlands-90390          Poor
#> 174                    amsterdam-netherlands-90490     Very Good
#> 175                    eindhoven-netherlands-90590          Good
#> 176                     enschede-netherlands-90690          Good
#> 177                    rotterdam-netherlands-90790          Good
#> 178                   wageningen-netherlands-90890     Very Good
#> 179                          bristol-england-91090          Good
#> 180                        liverpool-england-91190          Good
#> 181                            leeds-england-91290          Good
#> 182                       nottingham-england-91390          Good
#> 183                        newcastle-england-91490          Good
#> 184                       edinburgh-scotland-91590     Very Good
#> 185                 belfast-northern-ireland-91690     Very Good
#> 186                           dublin-ireland-91790          Good
#> 187                       birmingham-england-91890     Very Good
#> 188                           london-england-91990     Very Good
#> 189                        herne-bay-england-92090          Good
#> 190                             geel-belgium-92290     Very Good
#> 191                            aalst-belgium-92390          Good
#> 192                           bremen-germany-92590          Good
#> 193                          hamburg-germany-92690          Good
#> 194                       copenhagen-denmark-92790          Good
#> 195                              oslo-norway-92890          Good
#> 196                            tromso-norway-92990          Good
#> 197                         trondheim-norway-93090          Good
#> 198                            gavle-sweden-100190          Good
#> 199                        linkoping-sweden-100290     Very Good
#> 200                             pila-poland-100490          Good
#> 201                           warsaw-poland-100590          Poor
#> 202                        zgorzelec-poland-100690          Good
#> 203                          berlin-germany-100790          Good
#> 204                       bielefeld-germany-100890     Very Good
#> 205                        hannover-germany-100990     Very Good
#> 206                      oberhausen-germany-101090          Good
#> 207                        wurzburg-germany-101190     Very Good
#> 208                           mainz-germany-101290     Very Good
#> 209                       stuttgart-germany-101390          Good
#> 210                          munich-germany-101490     Very Good
#> 211                             ulm-germany-101690          Good
#> 212                      zurich-switzerland-101790          Good
#> 213                        dornbirn-austria-101890     Very Good
#> 214                            wels-austria-101990     Very Good
#> 215                          vienna-austria-102090     Very Good
#> 216                    ljubljana-yugoslavia-102190     Very Good
#> 217                       zagreb-yugoslavia-102290     Very Good
#> 218                             udine-italy-102490     Very Good
#> 219                            milano-italy-102590     Very Good
#> 220                           bologna-italy-102690          Good
#> 221                              rome-italy-102790          Good
#> 222                              pisa-italy-102890     Very Good
#> 223                            torino-italy-102990          Good
#> 224                             lyon-france-103090          Good
#> 225                         barcelona-spain-110190     Very Good
#> 226                         bordeaux-france-110290          Good
#> 227                         poitiers-france-110390     Very Good
#> 228                   riec-sur-belon-france-110490          Good
#> 229                            paris-france-110590          Good
#> 230                            nancy-france-110690     Very Good
#> 231                   amsterdam-netherlands-110790     Very Good
#> 232                           lorton-va-usa-122690     Very Good
#> 233                        washington-dc-usa-10291          Good
#> 234                        washington-dc-usa-10391          Good
#> 235                        washington-dc-usa-11291          Good
#> 236                        washington-dc-usa-21591     Very Good
#> 237                          richmond-va-usa-22091     Very Good
#> 238                      philadelphia-pa-usa-30291          Good
#> 239                         lancaster-pa-usa-30391     Very Good
#> 240                          new-york-ny-usa-30491     Very Good
#> 241                          new-york-ny-usa-30591          Good
#> 242                           hoboken-nj-usa-30691     Very Good
#> 243                            storrs-ct-usa-30791          Good
#> 244                           amherst-ma-usa-30991     Very Good
#> 245                            latham-ny-usa-31091          Poor
#> 246                           buffalo-ny-usa-31191          Good
#> 247                          syracuse-ny-usa-31291          Good
#> 248                        burlington-vt-usa-31491          Good
#> 249                          portland-me-usa-31591          Good
#> 250                         worcester-ma-usa-31691     Very Good
#> 251                            boston-ma-usa-31791          Good
#> 252                        providence-ri-usa-31891          Good
#> 253                           trenton-nj-usa-31991          Good
#> 254                        washington-dc-usa-41291          Good
#> 255                          new-york-ny-usa-42091     Very Good
#> 256                    virginia-beach-va-usa-50191          Good
#> 257                        greensboro-nc-usa-50291          Good
#> 258                       chapel-hill-nc-usa-50391          Good
#> 259                         charlotte-nc-usa-50491          Good
#> 260                         knoxville-tn-usa-50591          Good
#> 261                         nashville-tn-usa-50791          Good
#> 262                        huntsville-al-usa-50891          Poor
#> 263                          columbia-sc-usa-51091          Good
#> 264                            athens-ga-usa-51191          Good
#> 265                           atlanta-ga-usa-51291          Good
#> 266                          savannah-ga-usa-51391          Good
#> 267                      jacksonville-fl-usa-51491          Good
#> 268                             tampa-fl-usa-51591     Very Good
#> 269                             miami-fl-usa-51691          Good
#> 270                           orlando-fl-usa-51791          Good
#> 271                       gainesville-fl-usa-51891          Good
#> 272                         pensacola-fl-usa-52091          Poor
#> 273                        birmingham-al-usa-52191          Good
#> 274                           memphis-tn-usa-52291          Good
#> 275                       little-rock-ar-usa-52391          Poor
#> 276                            dallas-tx-usa-52491          Good
#> 277                            austin-tx-usa-52591     Very Good
#> 278                           houston-tx-usa-52691          Good
#> 279                            edmond-ok-usa-53091     Very Good
#> 280                          lawrence-ks-usa-53191          Good
#> 281                      fayetteville-ar-usa-60191          Poor
#> 282                       springfield-mo-usa-60291          Good
#> 283                          columbia-mo-usa-60391          Good
#> 284                          st-louis-mo-usa-60491          Good
#> 285                         champaign-il-usa-60691          Good
#> 286                      indianapolis-in-usa-60791          Good
#> 287                        louisville-ky-usa-60891          Good
#> 288                         lexington-ky-usa-60991          Poor
#> 289                        cincinnati-oh-usa-61091          Good
#> 290                            dayton-oh-usa-61191          Good
#> 291                          columbus-oh-usa-61291          Good
#> 292                         cleveland-oh-usa-61391     Very Good
#> 293                        pittsburgh-pa-usa-61491          Good
#> 294                        washington-dc-usa-61791          Good
#> 295                        washington-dc-usa-72891          Good
#> 296                        washington-dc-usa-72991     Very Good
#> 297                       montreal-qc-canada-80291          Good
#> 298                         ottawa-on-canada-80391          Good
#> 299                        toronto-on-canada-80491     Very Good
#> 300                           detroit-mi-usa-80591     Very Good
#> 301                         kalamazoo-mi-usa-80691     Very Good
#> 302                           chicago-il-usa-80891          Good
#> 303                           madison-wi-usa-80991          Good
#> 304                         milwaukee-wi-usa-81091     Very Good
#> 305                         green-bay-wi-usa-81191          Good
#> 306                       minneapolis-mn-usa-81291     Very Good
#> 307                             fargo-nd-usa-81391          Good
#> 308                       winnipeg-mb-canada-81491     Very Good
#> 309                         regina-sk-canada-81591          Good
#> 310                        calgary-ab-canada-81791     Very Good
#> 311                      vancouver-bc-canada-81991     Very Good
#> 312                           olympia-wa-usa-82591          Good
#> 313                           seattle-wa-usa-82691     Very Good
#> 314                          portland-or-usa-82791     Very Good
#> 315                          petaluma-ca-usa-83091          Good
#> 316                           oakland-ca-usa-83191          Good
#> 317                          berkeley-ca-usa-90191     Very Good
#> 318                        sacramento-ca-usa-90391     Very Good
#> 319                        isla-vista-ca-usa-90591     Very Good
#> 320                    jawbone-canyon-ca-usa-90691          Good
#> 321                       los-angeles-ca-usa-90891          Good
#> 322                           phoenix-az-usa-90991     Very Good
#> 323                       albuquerque-nm-usa-91191          Good
#> 324                            denver-co-usa-91391     Very Good
#> 325                           lincoln-ne-usa-91491     Very Good
#> 326                   geelong-vic-australia-101791     Very Good
#> 327                 melbourne-vic-australia-101891     Very Good
#> 328                   croydon-vic-australia-101991     Very Good
#> 329                 melbourne-vic-australia-102091     Very Good
#> 330                   adelaide-sa-australia-102291          Good
#> 331                  canberra-nsw-australia-102391     Very Good
#> 332                    sydney-nsw-australia-102591          Good
#> 333                     manly-nsw-australia-102691     Very Good
#> 334                    sydney-nsw-australia-102791     Very Good
#> 335                gold-coast-qld-australia-110191     Very Good
#> 336                  brisbane-qld-australia-110291          Good
#> 337                 byron-bay-nsw-australia-110391          Good
#> 338                    auckland-new-zealand-110891          Good
#> 339                             tokyo-japan-111191     Very Good
#> 340                             tokyo-japan-111291          Good
#> 341                             osaka-japan-111491     Very Good
#> 342                         honolulu-hi-usa-111891     Very Good
#> 343                       washington-dc-usa-120891          Good
#> 344                       los-angeles-ca-usa-12492          Good
#> 345                       los-angeles-ca-usa-12592          Good
#> 346                        washington-dc-usa-30692     Very Good
#> 347                        washington-dc-usa-40392     Very Good
#> 348                        washington-dc-usa-40492          Good
#> 349                      philadelphia-pa-usa-40692     Very Good
#> 350                           hoboken-nj-usa-40792          Good
#> 351                            latham-ny-usa-40992          Good
#> 352                        bennington-vt-usa-41092          Good
#> 353                         worcester-ma-usa-41192          Good
#> 354                          portland-me-usa-41292     Very Good
#> 355                         new-haven-ct-usa-41392          Good
#> 356                    amsterdam-netherlands-50192          Good
#> 357                       whitstable-england-50492     Very Good
#> 358                       portsmouth-england-50592          Good
#> 359                        cambridge-england-50692     Very Good
#> 360                          norwich-england-50792     Excellent
#> 361                       nottingham-england-50892     Very Good
#> 362                           london-england-50992     Excellent
#> 363                           dublin-ireland-51192     Very Good
#> 364                 belfast-northern-ireland-51292     Very Good
#> 365                       manchester-england-51492     Very Good
#> 366                        newcastle-england-51592     Very Good
#> 367                         glasgow-scotland-51692     Very Good
#> 368                         bradford-england-51792          Good
#> 369                    groningen-netherlands-52092     Very Good
#> 370                    den-bosch-netherlands-52192     Very Good
#> 371                         tongeren-belgium-52292          Good
#> 372                        venlo-netherlands-52392          Poor
#> 373                     den-haag-netherlands-52492          Good
#> 374                        diksmuide-belgium-52692          Good
#> 375                             paris-france-52792     Very Good
#> 376                          poitiers-france-52892     Very Good
#> 377                          bordeaux-france-52992     Very Good
#> 378                          toulouse-france-53092          Good
#> 379                          barcelona-spain-53192     Very Good
#> 380                             madrid-spain-60292     Very Good
#> 381                           zaragoza-spain-60392     Very Good
#> 382                             torino-italy-60592     Very Good
#> 383                               pisa-italy-60692          Good
#> 384                               rome-italy-60792     Very Good
#> 385                             modena-italy-60892     Very Good
#> 386                             padova-italy-60992          Good
#> 387                       ljubljana-slovenia-61092          Good
#> 388                         budapest-hungary-61192          Good
#> 389                    prague-czechoslovakia-61392     Very Good
#> 390                           vienna-austria-61492     Very Good
#> 391                             wels-austria-61592     Very Good
#> 392                           munich-germany-61692     Very Good
#> 393                         hohenems-austria-61792          Good
#> 394                       zurich-switzerland-61892     Very Good
#> 395                        frankfurt-germany-61992          Good
#> 396                              ulm-germany-62092          Good
#> 397                        nuremberg-germany-62292          Good
#> 398        neuhausen-auf-den-fildern-germany-62392          Good
#> 399                   v-schwenningen-germany-62492          Good
#> 400                         hannover-germany-62592          Good
#> 401                            poznan-poland-62692          Good
#> 402                           berlin-germany-62892     Very Good
#> 403                        osnabruck-germany-62992          Good
#> 404                         dortmund-germany-63092     Very Good
#> 405                             koln-germany-70192          Good
#> 406                          hamburg-germany-70292          Good
#> 407                           bremen-germany-70392     Very Good
#> 408                       copenhagen-denmark-70492          Good
#> 409                              oslo-norway-70692          Good
#> 410                             gavle-sweden-70892          Good
#> 411                     nijmegen-netherlands-71192          Good
#> 412                        washington-dc-usa-72592          Good
#> 413                       washington-dc-usa-083192          Good
#> 414                       washington-dc-usa-102392          Good
#> 415                        baltimore-md-usa-102592          Good
#> 416                    virginia-beach-va-usa-20493     Very Good
#> 417                       chapel-hill-nc-usa-20593     Very Good
#> 418                        wilmington-nc-usa-20693     Very Good
#> 419                          columbia-sc-usa-20793          Good
#> 420                         charlotte-nc-usa-20893          Poor
#> 421                           atlanta-ga-usa-20993          Good
#> 422                           atlanta-ga-usa-21093          Good
#> 423                          savannah-ga-usa-21193          Good
#> 424                      jacksonville-fl-usa-21293     Very Good
#> 425                           orlando-fl-usa-21393     Very Good
#> 426                   fort-lauderdale-fl-usa-21493     Very Good
#> 427                             tampa-fl-usa-21693          Good
#> 428                       gainesville-fl-usa-21793     Very Good
#> 429                            athens-ga-usa-21893     Very Good
#> 430                            athens-ga-usa-21993     Very Good
#> 431                        greensboro-nc-usa-22093     Very Good
#> 432                          richmond-va-usa-22193     Very Good
#> 433                        washington-dc-usa-32193          Poor
#> 434                      college-park-md-usa-40293     Very Good
#> 435                   charlottesville-va-usa-40493          Good
#> 436                         knoxville-tn-usa-40593          Good
#> 437                         nashville-tn-usa-40693     Very Good
#> 438                           memphis-tn-usa-40793     Very Good
#> 439                           jackson-ms-usa-40893          Good
#> 440                       new-orleans-la-usa-40993     Very Good
#> 441                           houston-tx-usa-41093          Good
#> 442                             bryan-tx-usa-41193     Very Good
#> 443                            austin-tx-usa-41293          Good
#> 444                            austin-tx-usa-41393          Good
#> 445                       san-antonio-tx-usa-41493     Very Good
#> 446                            dallas-tx-usa-41693          Good
#> 447                            norman-ok-usa-41793     Very Good
#> 448                           lubbock-tx-usa-41893     Very Good
#> 449                           el-paso-tx-usa-41993          Good
#> 450                            tucson-az-usa-42093     Very Good
#> 451                         las-vegas-nv-usa-42293          Good
#> 452                       los-angeles-ca-usa-42393          Good
#> 453                       los-angeles-ca-usa-42493     Very Good
#> 454                       los-angeles-ca-usa-42593     Very Good
#> 455                         san-diego-ca-usa-42693     Very Good
#> 456                     santa-barbara-ca-usa-42793          Good
#> 457                       watsonville-ca-usa-42893          Good
#> 458                          berkeley-ca-usa-43093          Good
#> 459                    san-franscisco-ca-usa-50193     Very Good
#> 460                        sacramento-ca-usa-50293          Good
#> 461                            eugene-or-usa-50493          Poor
#> 462                          portland-or-usa-50593     Very Good
#> 463                           seattle-wa-usa-50693          Good
#> 464                      vancouver-bc-canada-50793     Very Good
#> 465                           olympia-wa-usa-50893     Very Good
#> 466                          bellevue-wa-usa-50993     Very Good
#> 467                         kennewick-wa-usa-51493          Good
#> 468                             boise-id-usa-51593          Good
#> 469                    salt-lake-city-ut-usa-51693     Very Good
#> 470                            denver-co-usa-51893     Very Good
#> 471                           laramie-wy-usa-51993          Poor
#> 472                             omaha-ne-usa-52193     Very Good
#> 473                        des-moines-ia-usa-52293          Good
#> 474                       minneapolis-mn-usa-52393     Very Good
#> 475                       minneapolis-mn-usa-52493     Very Good
#> 476                       minneapolis-mn-usa-52593     Very Good
#> 477                         green-bay-wi-usa-52693     Very Good
#> 478                           chicago-il-usa-52893     Very Good
#> 479                           chicago-il-usa-52993     Very Good
#> 480                      indianapolis-in-usa-53093          Poor
#> 481                          columbus-oh-usa-53193     Very Good
#> 482                        washington-dc-usa-80793     Very Good
#> 483                        washington-dc-usa-80993     Very Good
#> 484                           hoboken-nj-usa-81693     Very Good
#> 485                           trenton-nj-usa-81793     Very Good
#> 486                           trenton-nj-usa-81893     Very Good
#> 487                     mechanicsburg-pa-usa-81993     Very Good
#> 488                        pittsburgh-pa-usa-82093          Good
#> 489                            dayton-oh-usa-82193     Very Good
#> 490                        cincinnati-oh-usa-82293     Very Good
#> 491                        carbondale-il-usa-82493     Very Good
#> 492                          st-louis-mo-usa-82593     Very Good
#> 493                          st-louis-mo-usa-82693     Very Good
#> 494                          columbia-mo-usa-82793     Very Good
#> 495                       kansas-city-ks-usa-82893     Very Good
#> 496                         iowa-city-ia-usa-82993          Good
#> 497                            normal-il-usa-90193     Very Good
#> 498                         milwaukee-wi-usa-90293     Very Good
#> 499                           chicago-il-usa-90393          Good
#> 500                           pontiac-mi-usa-90493     Very Good
#> 501                         cleveland-oh-usa-90593          Good
#> 502                           buffalo-ny-usa-90693     Very Good
#> 503                        guelph-ont-canada-90893          Good
#> 504                       toronto-ont-canada-90993          Good
#> 505                       toronto-ont-canada-91093     Very Good
#> 506                        ottawa-ont-canada-91193     Very Good
#> 507                       montreal-qc-canada-91293     Very Good
#> 508                        burlington-vt-usa-91393          Good
#> 509                          portland-me-usa-91493          Good
#> 510                        bennington-vt-usa-91693     Very Good
#> 511                         fitchburg-ma-usa-91793          Good
#> 512                            storrs-ct-usa-91893     Very Good
#> 513                        providence-ri-usa-91993     Excellent
#> 514                            albany-ny-usa-92093     Very Good
#> 515                          syracuse-ny-usa-92193     Very Good
#> 516                        binghamton-ny-usa-92293     Very Good
#> 517                     new-york-city-ny-usa-92493     Very Good
#> 518                     new-york-city-ny-usa-92593     Very Good
#> 519                     state-college-pa-usa-92693     Very Good
#> 520                      philadelphia-pa-usa-92793     Very Good
#> 521                      philadelphia-pa-usa-92893     Very Good
#> 522                    rehoboth-beach-de-usa-92993     Very Good
#> 523                             osaka-japan-103193          Good
#> 524                             kyoto-japan-110193     Very Good
#> 525                            nagoya-japan-110393     Very Good
#> 526                             tokyo-japan-110593     Very Good
#> 527                             tokyo-japan-110693     Very Good
#> 528                     singapore-singapore-110893          Good
#> 529                      adelaide-australia-111193          Good
#> 530                   croydon-vic-australia-111293          Good
#> 531                 melbourne-vic-australia-111393          Good
#> 532                 melbourne-vic-australia-111493          Good
#> 533                      canberra-australia-111793     Very Good
#> 534                    wollongong-australia-111893          Good
#> 535                         manly-australia-111993          Good
#> 536                        sydney-australia-112093          Good
#> 537                     newcastle-australia-112493     Very Good
#> 538                       lismore-australia-112693     Very Good
#> 539                  brisbane-qld-australia-112793          Good
#> 540                    sydney-nsw-australia-120193          Good
#> 541                    hobart-tas-australia-120393     Very Good
#> 542                launceston-tas-australia-120493     Very Good
#> 543                christchurch-new-zealand-120893     Very Good
#> 544                     dunedin-new-zealand-120993     Very Good
#> 545                  wellington-new-zealand-121093     Very Good
#> 546                    auckland-new-zealand-121193     Excellent
#> 547                    auckland-new-zealand-121293     Excellent
#> 548                         honolulu-hi-usa-121493          Good
#> 549                        washington-dc-usa-80494          Good
#> 550                    belo-horizonte-brazil-81594     Very Good
#> 551                    rio-de-janeiro-brazil-81894          Good
#> 552                          itaborai-brazil-81994     Very Good
#> 553                         sao-paulo-brazil-82094          Good
#> 554                         sao-paulo-brazil-82194          Good
#> 555                          curitiba-brazil-82594     Very Good
#> 556                          curitiba-brazil-82694     Very Good
#> 557                          curitiba-brazil-82794          Good
#> 558                    silver-spring-md-usa-112094     Very Good
#> 559                       washington-dc-usa-112794     Very Good
#> 560                       washington-dc-usa-112994     Very Good
#> 561                         baltimore-md-usa-30295     Very Good
#> 562                      philadelphia-pa-usa-40195     Excellent
#> 563                      philadelphia-pa-usa-40295     Very Good
#> 564                     new-york-city-ny-usa-40395     Very Good
#> 565                     new-york-city-ny-usa-40495          Good
#> 566                     new-york-city-ny-usa-40595     Very Good
#> 567                      poughkeepsie-ny-usa-40695     Very Good
#> 568                          hartford-ct-usa-40795     Very Good
#> 569                          portland-me-usa-40895     Very Good
#> 570                        burlington-vt-usa-40995          Good
#> 571                        providence-ri-usa-41195     Very Good
#> 572                        providence-ri-usa-41295     Very Good
#> 573                           hoboken-nj-usa-41395          Good
#> 574                            newark-de-usa-41495          Poor
#> 575                    eindhoven-netherlands-50495     Excellent
#> 576                         brighton-england-50695          Poor
#> 577                       manchester-england-50795          Good
#> 578                         glasgow-scotland-50895          Poor
#> 579                 belfast-northern-ireland-50995          Good
#> 580                           dublin-ireland-51095          Good
#> 581                       nottingham-england-51295     Very Good
#> 582                           london-england-51395     Very Good
#> 583                    wolverhampton-england-51495     Very Good
#> 584                            leeds-england-51595     Very Good
#> 585                    amsterdam-netherlands-51795     Very Good
#> 586                           leuven-belgium-51895          Good
#> 587                             gent-belgium-51995     Very Good
#> 588                             arras-france-52095          Good
#> 589                             nancy-france-52195     Very Good
#> 590                             paris-france-52295          Good
#> 591                          poitiers-france-52495     Very Good
#> 592                            angers-france-52595     Very Good
#> 593                          bordeaux-france-52695     Very Good
#> 594                     lakuntza-spainbasque-52795          Good
#> 595                             oviedo-spain-52895          Poor
#> 596             santiago-de-compostela-spain-52995     Very Good
#> 597                          lisbon-portugal-53195     Very Good
#> 598                             madrid-spain-60295     Very Good
#> 599                          barcelona-spain-60395     Very Good
#> 600                           valencia-spain-60495          Good
#> 601                          toulouse-france-60695          Good
#> 602                              lyon-france-60895     Very Good
#> 603                       kingersheim-france-61095          Good
#> 604                              milan-italy-61295     Very Good
#> 605                             padova-italy-61395     Very Good
#> 606                           florence-italy-61495     Very Good
#> 607                             torino-italy-61595     Very Good
#> 608                            bologna-italy-61695          Good
#> 609                     gavoi-sardinia-italy-61795     Very Good
#> 610                     catania-sicily-italy-61895     Very Good
#> 611                               rome-italy-62095     Very Good
#> 612                             verona-italy-62195          Good
#> 613                    gde-spilimbergo-italy-62295          Good
#> 614                       ljubljana-slovenia-62395          Good
#> 615                           vienna-austria-62495          Poor
#> 616                             wels-austria-62595     Very Good
#> 617                           munich-germany-62695     Very Good
#> 618                              ulm-germany-62795          Good
#> 619                    prague-czech-republic-62995     Very Good
#> 620                        stuttgart-germany-63095     Very Good
#> 621                            mainz-germany-70195          Good
#> 622                           berlin-germany-70295     Very Good
#> 623                         dortmund-germany-70395          Poor
#> 624                          hamburg-germany-70495     Very Good
#> 625                     nijmegen-netherlands-70595     Very Good
#> 626                    groningen-netherlands-70795     Very Good
#> 627                        bielefeld-germany-70895          Good
#> 628                           bremen-germany-70995          Good
#> 629                       copenhagen-denmark-71095     Excellent
#> 630                          tampere-finland-71295     Very Good
#> 631                              oslo-norway-71495     Very Good
#> 632                        washington-dc-usa-91695          Poor
#> 633                       lindenhurst-ny-usa-92195     Very Good
#> 634                       northampton-ma-usa-92295          Good
#> 635                       montreal-qc-canada-92395          Good
#> 636                    quebec-city-qc-canada-92495          Good
#> 637                         ottawa-on-canada-92695     Very Good
#> 638                        toronto-on-canada-92795          Good
#> 639                         rochester-ny-usa-92895          Good
#> 640                        pittsburgh-pa-usa-92995     Very Good
#> 641                          detroit-mi-usa-100195          Good
#> 642                        cleveland-oh-usa-100295     Very Good
#> 643                         columbus-oh-usa-100395          Good
#> 644                           dayton-oh-usa-100495          Good
#> 645                       cincinnati-oh-usa-100595     Very Good
#> 646                     indianapolis-in-usa-100695          Good
#> 647                       louisville-ky-usa-100795     Excellent
#> 648                         st-louis-mo-usa-100895     Very Good
#> 649                           peoria-il-usa-100995     Very Good
#> 650                          chicago-il-usa-101095     Very Good
#> 651                        green-bay-wi-usa-101295     Very Good
#> 652                        milwaukee-wi-usa-101395          Good
#> 653                      minneapolis-mn-usa-101495     Very Good
#> 654                      minneapolis-mn-usa-101595     Very Good
#> 655                             ames-ia-usa-101795          Good
#> 656                          lincoln-ne-usa-101895     Very Good
#> 657                      sioux-falls-sd-usa-101995          Good
#> 658                       rapid-city-sd-usa-102095          Poor
#> 659                           denver-co-usa-102295          Good
#> 660                   salt-lake-city-ut-usa-102495          Good
#> 661                            boise-id-usa-102595     Very Good
#> 662                           yakima-wa-usa-102695     Very Good
#> 663                          seattle-wa-usa-102795     Very Good
#> 664                          olympia-wa-usa-102995     Very Good
#> 665                        anchorage-ak-usa-110195     Very Good
#> 666                         portland-or-usa-110295     Very Good
#> 667                       sacramento-ca-usa-110495          Good
#> 668                    san-francisco-ca-usa-110595     Very Good
#> 669                    san-francisco-ca-usa-110695     Very Good
#> 670                      bakersfield-ca-usa-110795     Very Good
#> 671                      los-angeles-ca-usa-110895          Good
#> 672                      los-angeles-ca-usa-110995     Very Good
#> 673                        san-diego-ca-usa-111095     Very Good
#> 674                          phoenix-az-usa-111195     Very Good
#> 675                      albuquerque-nm-usa-111395     Very Good
#> 676                          el-paso-tx-usa-111495          Good
#> 677                           austin-tx-usa-111695     Very Good
#> 678                           austin-tx-usa-111795     Very Good
#> 679                      san-antonio-tx-usa-111895     Very Good
#> 680                           dallas-tx-usa-111995          Good
#> 681                    oklahoma-city-ok-usa-112095     Very Good
#> 682                        washington-dc-usa-13096     Very Good
#> 683                        washington-dc-usa-13196     Excellent
#> 684                           norfolk-va-usa-31996     Very Good
#> 685                        wilmington-nc-usa-32096     Very Good
#> 686                     winston-salem-nc-usa-32196          Good
#> 687                         charlotte-nc-usa-32396     Very Good
#> 688                          columbia-sc-usa-32496     Very Good
#> 689                            athens-ga-usa-32696     Very Good
#> 690                        huntsville-al-usa-32796     Very Good
#> 691                           atlanta-ga-usa-32896     Very Good
#> 692                           atlanta-ga-usa-32996     Very Good
#> 693                          savannah-ga-usa-33096     Very Good
#> 694                      jacksonville-fl-usa-33196          Good
#> 695                           orlando-fl-usa-40196          Good
#> 696                   fort-lauderdale-fl-usa-40296     Very Good
#> 697                             tampa-fl-usa-40396          Good
#> 698                       new-orleans-la-usa-40596     Very Good
#> 699                         lafayette-la-usa-40796          Poor
#> 700                           houston-tx-usa-40896     Very Good
#> 701                            oxford-ms-usa-41096          Good
#> 702                         nashville-tn-usa-41196     Very Good
#> 703                         knoxville-tn-usa-41296     Very Good
#> 704                           roanoke-va-usa-41396     Very Good
#> 705                          richmond-va-usa-41496     Very Good
#> 706                        washington-dc-usa-41996     Very Good
#> 707                           washington-dc-081596          Poor
#> 708                        washington-dc-usa-92996     Very Good
#> 709                         honolulu-hi-usa-101696     Very Good
#> 710                             maui-hi-usa-101796     Very Good
#> 711                             maui-hi-usa-101896     Very Good
#> 712                           fukuoka-japan-102196     Very Good
#> 713                           okayama-japan-102296     Excellent
#> 714                             osaka-japan-102396     Very Good
#> 715                            nagoya-japan-102596     Very Good
#> 716                             tokyo-japan-102696     Very Good
#> 717                             tokyo-japan-102796     Very Good
#> 718                             tokyo-japan-102896     Excellent
#> 719                           sapporo-japan-103096     Very Good
#> 720                           sapporo-japan-103196     Very Good
#> 721                     hong-kong-hong-kong-110296     Very Good
#> 722                   kuala-lumpur-malaysia-110696     Very Good
#> 723                     singapore-singapore-110896          Good
#> 724                         perth-australia-111096     Very Good
#> 725                      adelaide-australia-111296     Very Good
#> 726                     hobart-tz-australia-111396     Very Good
#> 727                    sydney-nsw-australia-111596     Excellent
#> 728                     newcastle-australia-111696     Very Good
#> 729                        sydney-australia-111796     Very Good
#> 730                     new-york-city-ny-usa-50197          Good
#> 731                     new-york-city-ny-usa-50297     Very Good
#> 732                      philadelphia-pa-usa-50397          Good
#> 733                            durham-nh-usa-50497     Very Good
#> 734                           clinton-ma-usa-50597          Good
#> 735                        providence-ri-usa-50697     Very Good
#> 736                       canberra-australia-61397     Very Good
#> 737                         sydney-australia-61497          Good
#> 738                         sydney-australia-61597          Poor
#> 739                      melbourne-australia-61797     Very Good
#> 740                      melbourne-australia-61897     Excellent
#> 741                       ballarat-australia-61997     Very Good
#> 742                        geelong-australia-62097     Very Good
#> 743                       brisbane-australia-62197     Very Good
#> 744                        lismore-australia-62397          Good
#> 745                         darwin-australia-62597     Very Good
#> 746                     auckland-new-zealand-62797          Good
#> 747                   wellington-new-zealand-62897     Very Good
#> 748                       nelson-new-zealand-62997     Very Good
#> 749                      dunedin-new-zealand-70197     Very Good
#> 750                 christchurch-new-zealand-70297          Poor
#> 751                        piracicaba-brazil-80597          Poor
#> 752                         sao-paulo-brazil-80697     Very Good
#> 753                           vitoria-brazil-80797     Very Good
#> 754                          brasilia-brazil-80997          Good
#> 755                          brasilia-brazil-81097     Very Good
#> 756                          curitiba-brazil-81497          Good
#> 757                         joinville-brazil-81597     Very Good
#> 758                    belo-horizonte-brazil-81697     Very Good
#> 759                          campinas-brazil-81997          Poor
#> 760                            santos-brazil-82097     Excellent
#> 761                        washington-dc-usa-82997     Very Good
#> 762                        washington-dc-usa-90397     Very Good
#> 763                        hagerstown-md-usa-50198     Excellent
#> 764                        pittsburgh-pa-usa-50298     Very Good
#> 765                          columbus-oh-usa-50398     Very Good
#> 766                              kent-oh-usa-50498          Good
#> 767                         cleveland-oh-usa-50598     Very Good
#> 768                        cincinnati-oh-usa-50698          Good
#> 769                           chicago-il-usa-50798          Good
#> 770                           chicago-il-usa-50898          Poor
#> 771                           detroit-mi-usa-50998     Very Good
#> 772                          richmond-va-usa-51198     Very Good
#> 773                         baltimore-md-usa-51298          Poor
#> 774                      poughkeepsie-ny-usa-71698          Good
#> 775                          syracuse-ny-usa-71798          Good
#> 776                         rochester-ny-usa-71898     Very Good
#> 777                        toronto-on-canada-71998     Very Good
#> 778                         ottawa-on-canada-72098     Very Good
#> 779                       montreal-qc-canada-72198     Very Good
#> 780                    quebec-city-qc-canada-72298          Poor
#> 781                    fredericton-nb-canada-72498     Very Good
#> 782                        halifax-ns-canada-72598     Very Good
#> 783                          portland-me-usa-72698          Good
#> 784                           hoboken-nj-usa-72798          Good
#> 785                        washington-dc-usa-73098          Poor
#> 786                        washington-dc-usa-73198          Poor
#> 787                        milwaukee-wi-usa-111398          Good
#> 788                       eau-claire-wi-usa-111498          Good
#> 789                      minneapolis-mn-usa-111598     Very Good
#> 790                       des-moines-ia-usa-111698     Very Good
#> 791                            omaha-ne-usa-111798     Very Good
#> 792                           olathe-ks-usa-111898     Very Good
#> 793                    oklahoma-city-ok-usa-111998          Good
#> 794                          houston-tx-usa-112198     Very Good
#> 795                           austin-tx-usa-112298     Very Good
#> 796                           dallas-tx-usa-112398     Very Good
#> 797                           conway-ar-usa-112498     Very Good
#> 798                          memphis-tn-usa-112598          Good
#> 799                         st-louis-mo-usa-112698          Good
#> 800                       louisville-ky-usa-112798          Good
#> 801                       charleston-wv-usa-112898     Very Good
#> 802                       morgantown-wv-usa-112998          Poor
#> 803                       washington-dc-usa-120398     Very Good
#> 804                          fairfax-va-usa-120498     Very Good
#> 805                         san-diego-ca-usa-21899     Very Good
#> 806                           ventura-ca-usa-21999     Very Good
#> 807                       watsonville-ca-usa-22099     Very Good
#> 808                         palo-alto-ca-usa-22199     Excellent
#> 809                     san-francisco-ca-usa-22299     Very Good
#> 810                              reno-nv-usa-22399          Good
#> 811                        sacramento-ca-usa-22499     Very Good
#> 812                          portland-or-usa-22699     Very Good
#> 813                           olympia-wa-usa-22799     Very Good
#> 814                           seattle-wa-usa-22899     Excellent
#> 815                       springfield-or-usa-30299          Good
#> 816                             chico-ca-usa-30399     Very Good
#> 817                       bakersfield-ca-usa-30499     Very Good
#> 818                         las-vegas-nv-usa-30599     Very Good
#> 819                       victorville-ca-usa-30699     Very Good
#> 820                            pomona-ca-usa-30799          Good
#> 821                 los-angeles-ca-usa-palace-3899     Excellent
#> 822                       los-angeles-ca-usa-30999     Excellent
#> 823                       los-angeles-ca-usa-31099     Excellent
#> 824                        reykjavik-iceland-42799     Excellent
#> 825                            leeds-england-42999          Good
#> 826                    wolverhampton-england-43099     Very Good
#> 827                        newcastle-england-50299     Very Good
#> 828                       edinburgh-scotland-50399          Good
#> 829                        aberdeen-scotland-50499     Very Good
#> 830                         glasgow-scotland-50599     Very Good
#> 831                         kilkenny-ireland-50799     Very Good
#> 832                             cork-ireland-50899     Very Good
#> 833                           dublin-ireland-50999     Very Good
#> 834                            newport-wales-51199     Very Good
#> 835                       nottingham-england-51399     Very Good
#> 836                         brighton-england-51499     Very Good
#> 837                           london-england-51599          Good
#> 838                        washington-dc-usa-82699     Excellent
#> 839                    amsterdam-netherlands-91699     Very Good
#> 840                          bremen-germany-091799          Good
#> 841                          hamburg-germany-91899     Very Good
#> 842                           berlin-germany-92099     Very Good
#> 843                           wroclaw-poland-92199     Excellent
#> 844                          leipzig-germany-92299          Good
#> 845                        nuremberg-germany-92499     Very Good
#> 846                           munich-germany-92599     Very Good
#> 847                           vienna-austria-92699     Excellent
#> 848                       ljubljana-slovenia-92899          Good
#> 849                               rome-italy-93099     Very Good
#> 850                          florence-italy-100199     Excellent
#> 851                             milan-italy-100299     Very Good
#> 852                      zurich-switzerland-100599     Very Good
#> 853                      geneva-switzerland-100699     Very Good
#> 854                        marseille-france-100799     Very Good
#> 855                         barcelona-spain-100899     Very Good
#> 856                         bordeaux-france-101199     Very Good
#> 857                           nantes-france-101399     Very Good
#> 858                            paris-france-101499     Very Good
#> 859                        brussels-belgium-101599     Very Good
#> 860                     tilburg-netherlands-101699     Excellent
#> 861                       providence-ri-usa-120299     Excellent
#> 862                    new-york-city-ny-usa-120399     Very Good
#> 863                     philadelphia-pa-usa-120499     Excellent
#> 864                       washington-dc-usa-120599     Very Good
#> 865                  charlottesville-va-usa-120899     Excellent
#> 866                          atlanta-ga-usa-121799     Very Good
#> 867                           athens-ga-usa-121899     Very Good
#> 868                        knoxville-tn-usa-121999     Very Good
#> 869                        nashville-tn-usa-122099     Very Good
#> 870                           raleigh-nc-usa-11200     Excellent
#> 871                         charlotte-nc-usa-11300     Very Good
#> 872                       gainesville-fl-usa-11500     Very Good
#> 873                           orlando-fl-usa-11600     Excellent
#> 874                   fort-lauderdale-fl-usa-11800     Very Good
#> 875                             tampa-fl-usa-11900     Very Good
#> 876                       tallahassee-fl-usa-12000     Very Good
#> 877                     san-francisco-ca-usa-60400          Good
#> 878                        washington-dc-usa-62700     Very Good
#> 879                        washington-dc-usa-80700          Good
#> 880                              umea-sweden-93000     Very Good
#> 881                        stockholm-sweden-100100     Very Good
#> 882                             oslo-norway-100200     Excellent
#> 883                        trondheim-norway-100300     Very Good
#> 884                           bergen-norway-100400     Excellent
#> 885                        jonkoping-sweden-100600          Good
#> 886                      copenhagen-denmark-100700     Excellent
#> 887                             lund-sweden-100800     Very Good
#> 888                        helsinki-finland-101000     Very Good
#> 889                            denver-co-usa-40501     Very Good
#> 890                            denver-co-usa-40601     Excellent
#> 891                  colorado-springs-co-usa-40701     Excellent
#> 892                       albuquerque-nm-usa-40801     Excellent
#> 893                           el-paso-tx-usa-40901          Good
#> 894                            tucson-az-usa-41001     Excellent
#> 895                           phoenix-az-usa-41201     Very Good
#> 896                           laramie-wy-usa-41601     Excellent
#> 897                           lincoln-ne-usa-41701     Very Good
#> 898                       kansas-city-mo-usa-41801     Excellent
#> 899                          columbia-mo-usa-41901     Very Good
#> 900                      indianapolis-in-usa-42001     Very Good
#> 901                        pittsburgh-pa-usa-42101     Very Good
#> 902                        washington-dc-usa-42501     Excellent
#> 903                        washington-dc-usa-42701     Very Good
#> 904                      severna-park-md-usa-62101     Very Good
#> 905                           chicago-il-usa-62301     Very Good
#> 906                           chicago-il-usa-62401     Very Good
#> 907                         green-bay-wi-usa-62601     Very Good
#> 908                       minneapolis-mn-usa-62701     Very Good
#> 909                             fargo-nd-usa-62801     Very Good
#> 910                       winnipeg-mb-canada-62901     Very Good
#> 911                         regina-sk-canada-63001     Very Good
#> 912                      saskatoon-sk-canada-70101     Very Good
#> 913                       edmonton-ab-canada-70201     Very Good
#> 914                        calgary-ab-canada-70301     Very Good
#> 915                        kelowna-bc-canada-70501     Very Good
#> 916                       victoria-bc-canada-70601     Very Good
#> 917                        burnaby-bc-canada-70701     Excellent
#> 918                        washington-dc-usa-81301     Very Good
#> 919                          richmond-va-usa-32202     Very Good
#> 920                           raleigh-nc-usa-32302     Excellent
#> 921                         asheville-nc-usa-32402     Very Good
#> 922                        birmingham-al-usa-32502     Very Good
#> 923                       new-orleans-la-usa-32702     Very Good
#> 924                           houston-tx-usa-32802     Very Good
#> 925                       san-antonio-tx-usa-32902     Excellent
#> 926                            austin-tx-usa-33002     Very Good
#> 927                            austin-tx-usa-33102     Very Good
#> 928                        fort-worth-tx-usa-40102     Very Good
#> 929                       little-rock-ar-usa-40202     Very Good
#> 930                        louisville-ky-usa-40402     Very Good
#> 931                        huntington-wv-usa-40502     Very Good
#> 932                      harrisonburg-va-usa-40602     Very Good
#> 933                           holyoke-ma-usa-51802     Excellent
#> 934                            boston-ma-usa-51902     Very Good
#> 935                            boston-ma-usa-42002     Very Good
#> 936                        washington-dc-usa-70102     Very Good
#> 937                        brighton-england-102002     Very Good
#> 938                          exeter-england-102102     Very Good
#> 939                      birmingham-england-102202     Very Good
#> 940                      nottingham-england-102302     Very Good
#> 941                          dublin-ireland-102502          Good
#> 942                        limerick-ireland-102602          Good
#> 943                  derry-northern-ireland-102702     Very Good
#> 944                        glasgow-scotland-102902     Very Good
#> 945                      manchester-england-103002     Very Good
#> 946                           leeds-england-103102     Excellent
#> 947                         bristol-england-110102     Very Good
#> 948                          london-england-110202          Good
#> 949                          london-england-110302     Very Good
#> 950                          london-england-110402     Very Good
```
