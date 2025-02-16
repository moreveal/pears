/*
Как добавить новый кастомный скин на сервер?
- Если хотим добавить скин в организацию, добавляем его в public ReloadSkin

Как добавить скин в магазины?
- В настройках гос цен правительства указываешь ценник и доступ для заказа в магазы (и УСЁ)
*/

/*
SampSkinID ID скина заменка на дефолтную (если скин кастомный), если обычный -- 0
eSkinPrice цена в виртах
eSkinGoldPrice цена в голде
eSkinName название скина
eSkinClass класс скина
eSkinSex пол скина

name класса пишется: при просмотре подробной инфы о скине в инвентаре, при выпадении из кейса (желательно)

SKINCLASS_SYSTEM класс - любая продажа в магазах одежды оффнута, не сливаемый скупщику, не дропается с кейсов
name: Системный, цвет #444444

SKINCLASS_COMMON класс - доступен в магазах одежды, выпадает только с кейса одежды, голд ценник: $ / 2500
name: Обычный, цвет #a2a0a0

SKINCLASS_UNCOMMON класс - доступен в магазах одежды, выпадает с кейса одежды и голд кейса, голд ценник: $ / 2000
name: Необычный, цвет #66ca55

SKINCLASS_RARE класс - недоступен в магазах одежды за вирты, выпадает только с голд кейса, голд ценник: $ / 1500
name: Редкий, цвет #6d48e2

SKINCLASS_LEGENDARY класс - недоступен в магазах одежды, выпадает только с голд кейса, голд ценник: $ / 1000 или кастом
name: Легендарный, цвет #d90763
*/

#define MAX_SKIN_NAME 64

enum SKINCLASSENUM
{
    SKINCLASS_INVALID = -1,
    SKINCLASS_SYSTEM = 0,
    SKINCLASS_COMMON = 10,
    SKINCLASS_UNCOMMON = 20,
    SKINCLASS_RARE = 30,
    SKINCLASS_RESERVED1 = 40,
    SKINCLASS_RESERVED2 = 50,
    SKINCLASS_RESERVED3 = 60,
    SKINCLASS_LEGENDARY = 70
};

enum SKINSEXENUM
{
    SKINSEX_UNKNOWN = 0,
    SKINSEX_MALE = 1,
    SKINSEX_FEMALE = 2
};

enum SKINENUM { eSampSkinID, eSkinPrice, eSkinGold, eSkinName[MAX_SKIN_NAME], SKINCLASSENUM:eSkinClass, SKINSEXENUM:eSkinSex }
new SkinPearsInfo[][SKINENUM] =
{
    {0     , 30_000          , 0           , "CJ"                                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 0      | null
    {0     , 15_000          , 0           , "The Truth"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 1      | TRUTH
    {0     , 150_000         , 50          , "Maccer"                                                        , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 2      | MACCER
    {0     , 100_000         , 50          , "Andre"                                                         , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 3      | ANDRE
    {0     , 150_000         , 75          , "Mini Bear"                                                     , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 4      | BBTHIN
    {0     , 0               , 0           , "Big Bear"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 5      | BB
    {0     , 150_000         , 75          , "Emmet"                                                         , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 6      | EMMET
    {0     , 200_000         , 100         , "Taxi Driver"                                                   , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 7      | male01
    {0     , 400_000         , 150         , "Janitor"                                                       , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 8      | JANITOR
    {0     , 75_000          , 50          , "Normal Ped"                                                    , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 9      | BFORI
    {0     , 0               , 0           , "Old Woman"                                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 10     | BFOST
    {0     , 0               , 0           , "Casino croupier"                                               , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 11     | VBFYCRP
    {0     , 0               , 0           , "Rich Woman"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 12     | BFYRI
    {0     , 0               , 0           , "Street Girl"                                                   , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 13     | BFYST
    {0     , 150_000         , 75          , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 14     | BMORI
    {0     , 150_000         , 75          , "Mr.Whittaker"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 15     | BMOST
    {0     , 400_000         , 200         , "Airport Worker"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 16     | BMYAP
    {0     , 20_000          , 0           , "Businessman"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 17     | BMYBU
    {0     , 15_000          , 0           , "Beach Visitor"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 18     | BMYBE
    {0     , 0               , 0           , "DJ"                                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 19     | BMYDJ
    {0     , 500_000         , 250         , "Rich Guy"                                                      , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 20     | BMYRI
    {0     , 100_000         , 60          , "Normal Ped"                                                    , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 21     | BMYCR
    {0     , 650_000         , 325         , "Normal Ped"                                                    , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 22     | BMYST
    {0     , 650_000         , 325         , "BMXer"                                                         , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 23     | WMYBMX
    {0     , 500_000         , 0           , "M.D. Bodyguard"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 24     | WBDYG1
    {0     , 1_000_000       , 0           , "M.D. Bodyguard"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 25     | WBDYG2
    {0     , 0               , 0           , "Backpacker"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 26     | WMYBP
    {0     , 45_000          , 0           , "Construction Worker"                                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 27     | WMYCON
    {0     , 45_000          , 0           , "Drug Dealer"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 28     | BMYDRUG
    {0     , 2_000_000       , 2_000       , "Drug Dealer"                                                   , SKINCLASS_LEGENDARY     , SKINSEX_MALE      }, // 29     | WMYDRUG
    {0     , 0               , 0           , "Drug Dealer"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 30     | HMYDRUG
    {0     , 0               , 0           , "Farm Inhabitant"                                               , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 31     | DWFOLC
    {0     , 300_000         , 150         , "Farm Inhabitant"                                               , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 32     | DWMOLC1
    {0     , 600_000         , 450         , "Farm Inhabitant"                                               , SKINCLASS_RARE          , SKINSEX_MALE      }, // 33     | DWMOLC2
    {0     , 300_000         , 150         , "Farm Inhabitant"                                               , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 34     | DWMYLC1
    {0     , 0               , 0           , "Gardener"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 35     | HMOGAR
    {0     , 200_000         , 100         , "Golfer"                                                        , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 36     | WMYGOL1
    {0     , 200_000         , 100         , "Golfer"                                                        , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 37     | WMYGOL2
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 38     | HFORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 39     | HFOST
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 40     | HFYRI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 41     | HFYST
    {0     , 0               , 0           , "Jethro"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 42     | JETHRO
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 43     | HMORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 44     | HMOST
    {0     , 0               , 0           , "Beach Visitor"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 45     | HMYBE
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 46     | HMYRI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 47     | HMYCR
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 48     | HMYST
    {0     , 0               , 0           , "Da Nang"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 49     | OMOKUNG
    {0     , 0               , 0           , "Mechanic"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 50     | WMYMECH
    {0     , 0               , 0           , "Mountain Biker"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 51     | BMYMOUN
    {0     , 0               , 0           , "Mountain Biker"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 52     | WMYMOUN
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 53     | OFORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 54     | OFOST
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 55     | OFYRI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 56     | OFYST
    {0     , 0               , 0           , "Oriental Ped"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 57     | OMORI
    {0     , 0               , 0           , "Oriental Ped"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 58     | OMOST
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 59     | OMYRI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 60     | OMYST
    {0     , 0               , 0           , "Pilot"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 61     | WMYPLT
    {0     , 0               , 0           , "Colonel Fuhrberger"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 62     | WMOPJ
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 63     | BFYPRO
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 64     | HFYPRO
    {0     , 0               , 0           , "Kendl Johnson"                                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 65     | KENDL
    {0     , 0               , 0           , "Pool Player"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 66     | BMYPOL1
    {0     , 0               , 0           , "Pool Player"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 67     | BMYPOL2
    {0     , 0               , 0           , "Preacher"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 68     | WMOPREA
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 69     | SBFYST
    {0     , 0               , 0           , "Scientist"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 70     | WMOSCI
    {0     , 0               , 0           , "Security Guard"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 71     | WMYSGRD
    {0     , 0               , 0           , "Hippy"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 72     | SWMYHP1
    {0     , 0               , 0           , "Hippy"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 73     | SWMYHP2
    {0     , 0               , 0           , "Unknown"                                                       , SKINCLASS_INVALID       , SKINSEX_MALE      }, // 74     |
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 75     | SWFOPRO
    {0     , 0               , 0           , "Stewardess"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 76     | WFYSTEW
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 77     | SWMOTR1
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 78     | WMOTR1
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 79     | BMOTR1
    {0     , 0               , 0           , "Boxer"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 80     | VBMYBOX
    {0     , 0               , 0           , "Boxer"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 81     | VWMYBOX
    {0     , 0               , 0           , "Black Elvis"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 82     | VHMYELV
    {0     , 0               , 0           , "White Elvis"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 83     | VBMYELV
    {0     , 0               , 0           , "Blue Elvis"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 84     | VIMYELV
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 85     | VWFYPRO
    {0     , 0               , 0           , "Ryder Mask"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 86     | RYDER3
    {0     , 0               , 0           , "Stripper"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 87     | VWFYST1
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 88     | WFORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 89     | WFOST
    {0     , 0               , 0           , "Jogger"                                                        , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 90     | WFYJG
    {0     , 700_000         , 450         , "Rich Woman"                                                    , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 91     | WFYRI
    {0     , 0               , 0           , "Rollerskater"                                                  , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 92     | WFYRO
    {0     , 400_000         , 200         , "Normal Ped"                                                    , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 93     | WFYST
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 94     | WMORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 95     | WMOST
    {0     , 0               , 0           , "Jogger"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 96     | WMYJG
    {0     , 0               , 0           , "Lifeguard"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 97     | WMYLG
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 98     | WMYRI
    {0     , 0               , 0           , "Rollerskater"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 99     | WMYRO
    {0     , 0               , 0           , "Biker"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 100    | WMYCR
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 101    | WMYST
    {0     , 0               , 0           , "Balla"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 102    | BALLAS1
    {0     , 0               , 0           , "Balla"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 103    | BALLAS2
    {0     , 0               , 0           , "Balla"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 104    | BALLAS3
    {0     , 0               , 0           , "Grove"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 105    | FAM1
    {0     , 0               , 0           , "Grove"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 106    | FAM2
    {0     , 0               , 0           , "Grove"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 107    | FAM3
    {0     , 0               , 0           , "Vagos"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 108    | LSV1
    {0     , 0               , 0           , "Vagos"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 109    | LSV2
    {0     , 0               , 0           , "Vagos"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 110    | LSV3
    {0     , 0               , 0           , "Russian Mafia"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 111    | MAFFA
    {0     , 0               , 0           , "Russian Mafia"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 112    | MAFFB
    {0     , 0               , 0           , "Russian Mafia"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 113    | MAFBOSS
    {0     , 0               , 0           , "Aztecas"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 114    | VLA1
    {0     , 0               , 0           , "Aztecas"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 115    | VLA2
    {0     , 0               , 0           , "Aztecas"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 116    | VLA3
    {0     , 0               , 0           , "Triad"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 117    | TRIADA
    {0     , 0               , 0           , "Triad"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 118    | TRIADB
    {0     , 0               , 0           , "Johhny Sindacco"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 119    | SINDACO
    {0     , 0               , 0           , "Triad Boss"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 120    | TRIBOSS
    {0     , 0               , 0           , "Da Nang Boy"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 121    | DNB1
    {0     , 0               , 0           , "Da Nang Boy"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 122    | DNB2
    {0     , 0               , 0           , "Da Nang Boy"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 123    | DNB3
    {0     , 0               , 0           , "The Mafia"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 124    | VMAFF1
    {0     , 0               , 0           , "The Mafia"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 125    | VMAFF2
    {0     , 0               , 0           , "The Mafia"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 126    | VMAFF3
    {0     , 0               , 0           , "The Mafia"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 127    | VMAFF4
    {0     , 300_000         , 150         , "Farm Inhabitant"                                               , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 128    | DNMYLC
    {0     , 0               , 0           , "Farm Inhabitant"                                               , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 129    | DNFOLC1
    {0     , 0               , 0           , "Farm Inhabitant"                                               , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 130    | DNFOLC2
    {0     , 0               , 0           , "Farm Inhabitant"                                               , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 131    | DNFYLC
    {0     , 300_000         , 150         , "Farm Inhabitant"                                               , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 132    | DNMOLC1
    {0     , 0               , 0           , "Farm Inhabitant"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 133    | DNMOLC2
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 134    | SBMOTR2
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 135    | SWMOTR2
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 136    | SBMYTR3
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 137    | SWMOTR3
    {0     , 0               , 0           , "Beach Visitor"                                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 138    | WFYBE
    {0     , 0               , 0           , "Beach Visitor"                                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 139    | BFYBE
    {0     , 0               , 0           , "Beach Visitor"                                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 140    | HFYBE
    {0     , 0               , 0           , "Businesswoman"                                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 141    | SOFYBU
    {0     , 0               , 0           , "Taxi Driver"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 142    | SBMYST
    {0     , 0               , 0           , "Crack Maker"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 143    | SBMYCR
    {0     , 0               , 0           , "Crack Maker"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 144    | BMYCG
    {0     , 0               , 0           , "Crack Maker"                                                   , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 145    | WFYCRK
    {0     , 0               , 0           , "Crack Maker"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 146    | HMYCM
    {0     , 0               , 0           , "Businessman"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 147    | WMYBU
    {0     , 0               , 0           , "Businesswoman"                                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 148    | BFYBU
    {0     , 0               , 0           , "Big Smoke Armored"                                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 149    | SMOKEV
    {0     , 0               , 0           , "Businesswoman"                                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 150    | WFYBU
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 151    | DWFYLC1
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 152    | WFYPRO
    {0     , 0               , 0           , "Construction Worker"                                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 153    | WMYCONB
    {0     , 0               , 0           , "Beach Visitor"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 154    | WMYBE
    {0     , 0               , 0           , "Pizza Worker"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 155    | WMYPIZZ
    {0     , 250_000         , 125         , "Barber"                                                        , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 156    | BMOBAR
    {0     , 0               , 0           , "Hillbilly"                                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 157    | CWFYHB
    {0     , 300_000         , 150         , "Farmer"                                                        , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 158    | CWMOFR
    {0     , 0               , 0           , "Hillbilly"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 159    | CWMOHB1
    {0     , 0               , 0           , "Hillbilly"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 160    | CWMOHB2
    {0     , 300_000         , 150         , "Farmer"                                                        , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 161    | CWMYFR
    {0     , 300_000         , 150         , "Hillbilly"                                                     , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 162    | CWMYHB1
    {0     , 0               , 0           , "Black Bouncer"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 163    | BMYBOUN
    {0     , 0               , 0           , "White Bouncer"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 164    | WMYBOUN
    {0     , 0               , 0           , "White MIB agent"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 165    | WMOMIB
    {0     , 0               , 0           , "Black MIB agent"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 166    | BMYMIB
    {0     , 0               , 0           , "Cluckin' Bell Worker"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 167    | WMYBELL
    {0     , 0               , 0           , "Chilli Dog Vendor"                                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 168    | BMOCHIL
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 169    | SOFYRI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 170    | SOMYST
    {0     , 800_000         , 500         , "Blackjack Dealer"                                              , SKINCLASS_RARE          , SKINSEX_MALE      }, // 171    | VWMYBJD
    {0     , 800_000         , 500         , "Casino croupier"                                               , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 172    | VWFYCRP
    {0     , 0               , 0           , "Rifa"                                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 173    | SFR1
    {0     , 0               , 0           , "Rifa"                                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 174    | SFR2
    {0     , 0               , 0           , "Rifa"                                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 175    | SFR3
    {0     , 500_000         , 250         , "Barber"                                                        , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 176    | BMYBAR
    {0     , 900_000         , 600         , "Barber"                                                        , SKINCLASS_RARE          , SKINSEX_MALE      }, // 177    | WMYBAR
    {0     , 0               , 0           , "Whore"                                                         , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 178    | WFYSEX
    {0     , 0               , 0           , "Ammunation"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 179    | WMYAMMO
    {0     , 500_000         , 250         , "Tattoo Artist"                                                 , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 180    | BMYTATT
    {0     , 0               , 0           , "Punk"                                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 181    | VWMYCR
    {0     , 0               , 0           , "Cab Driver"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 182    | VBMOCD
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 183    | VBMYCR
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 184    | VHMYCR
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 185    | SBMYRI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 186    | SOMYRI
    {0     , 0               , 0           , "Businessman"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 187    | SOMYBU
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 188    | SWMYST
    {0     , 700_000         , 550         , "Valet"                                                         , SKINCLASS_RARE          , SKINSEX_MALE      }, // 189    | WMYVA
    {0     , 0               , 0           , "Barbara Schternvart"                                           , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 190    | COPGRL3
    {0     , 0               , 0           , "Helena Wankstein"                                              , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 191    | GUNGRL3
    {0     , 0               , 0           , "Michelle Cannes"                                               , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 192    | MECGRL3
    {0     , 0               , 0           , "Katie Zhan"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 193    | NURGRL3
    {0     , 900_000         , 700         , "Millie Perkins"                                                , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 194    | CROGRL3
    {0     , 0               , 0           , "Denise Robinson"                                               , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 195    | GANGRL3
    {0     , 0               , 0           , "Farm Inhabitan"                                                , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 196    | CWFOFR
    {0     , 0               , 0           , "Hillbill"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 197    | CWFOHB
    {0     , 0               , 0           , "Farm Inhabitan"                                                , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 198    | CWFYFR1
    {0     , 0               , 0           , "Farm Inhabitan"                                                , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 199    | CWFYFR2
    {0     , 0               , 0           , "Hillbilly"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 200    | CWMYHB2
    {0     , 0               , 0           , "Farmer"                                                        , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 201    | DWFYLC2
    {0     , 0               , 0           , "Farmer"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 202    | DWMYLC2
    {0     , 0               , 0           , "Karate Teacher"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 203    | OMYKARA
    {0     , 0               , 0           , "Karate Teacher"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 204    | WMYKARA
    {0     , 0               , 0           , "Burger Shot Cashier"                                           , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 205    | WFYBURG
    {0     , 0               , 0           , "Cab Driver"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 206    | VWMYCD
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 207    | VHFYPRO
    {0     , 0               , 0           , "Su Xi Mu"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 208    | SUZIE
    {0     , 0               , 0           , "Noodle Vendor"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 209    | OMONOOD
    {0     , 0               , 0           , "School Instructor"                                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 210    | OMOBOAT
    {0     , 450_000         , 225         , "Shop Staff"                                                    , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 211    | WFYCLOT
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 212    | VWMOTR1
    {0     , 0               , 0           , "Weird old man"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 213    | VWMOTR2
    {0     , 0               , 0           , "Maria Latore"                                                  , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 214    | VWFYWAI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 215    | SBFORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 216    | SWFYRI
    {0     , 0               , 0           , "Shop Staff"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 217    | WMYCLOT
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 218    | SBFOST
    {0     , 0               , 0           , "Rich Woman"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 219    | SBFYRI
    {0     , 0               , 0           , "Cab Driver"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 220    | SBMOCD
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 221    | SBMORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 222    | SBMOST
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 223    | SHMYCR
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 224    | SOFORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 225    | SOFOST
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 226    | SOFYST
    {0     , 0               , 0           , "Oriental Businessman"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 227    | SOMOBU
    {0     , 0               , 0           , "Oriental Ped"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 228    | SOMORI
    {0     , 0               , 0           , "Oriental Ped"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 229    | SOMOST
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 230    | SWMOTR5
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 231    | SWFORI
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 232    | SWFOST
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 233    | SWFYST
    {0     , 0               , 0           , "Cab Driver"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 234    | SWMOCD
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 235    | SWMORI
    {0     , 500_000         , 400         , "Normal Ped"                                                    , SKINCLASS_RARE          , SKINSEX_MALE      }, // 236    | SWMOST
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 237    | SHFYPRO
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 238    | SBFYPRO
    {0     , 0               , 0           , "Homeless"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 239    | SWMOTR4
    {0     , 0               , 0           , "The D.A"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 240    | SWMYRI
    {0     , 0               , 0           , "Afro-American"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 241    | SMYST
    {0     , 0               , 0           , "Mexican"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 242    | SMYST2
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 243    | SFYPRO
    {0     , 0               , 0           , "Stripper"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 244    | VBFYST2
    {0     , 0               , 0           , "Prostitute"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 245    | VBFYPRO
    {0     , 0               , 0           , "Stripper"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 246    | VHFYST3
    {0     , 0               , 0           , "Biker"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 247    | BIKERA
    {0     , 0               , 0           , "Biker"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 248    | BIKERB
    {0     , 1_000_000       , 750         , "Pimp"                                                          , SKINCLASS_RARE          , SKINSEX_MALE      }, // 249    | BMYPIMP
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 250    | SWMYCR
    {0     , 0               , 0           , "Lifeguard"                                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 251    | WFYLG
    {0     , 0               , 0           , "Naked Valet"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 252    | WMYVA2
    {0     , 0               , 0           , "Bus Driver"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 253    | BMOSEC
    {0     , 0               , 0           , "Biker Drug Dealer"                                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 254    | BIKDRUG
    {0     , 0               , 0           , "Chauffeu"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 255    | WMYCH
    {0     , 0               , 0           , "Stripper"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 256    | SBFYSTR
    {0     , 0               , 0           , "Stripper"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 257    | SWFYSTR
    {0     , 500_000         , 250         , "Heckler"                                                       , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 258    | HECK1
    {0     , 500_000         , 250         , "Heckler"                                                       , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 259    | HECK2
    {0     , 0               , 0           , "Construction Worker"                                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 260    | BMYCON
    {0     , 0               , 0           , "Cab driver"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 261    | WMYCD1
    {0     , 0               , 0           , "Cab driver"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 262    | BMOCD
    {0     , 0               , 0           , "Normal Ped"                                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 263    | VWFYWA2
    {0     , 0               , 0           , "Clown"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 264    | WMOICE
    {0     , 0               , 0           , "Frank Tenpenny"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 265    | TENPEN
    {0     , 0               , 0           , "Eddie Pulaski"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 266    | PULASKI
    {0     , 0               , 0           , "Jimmy Hernandez"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 267    | HERN
    {0     , 0               , 0           , "Dwayne"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 268    | DWAYNE
    {0     , 0               , 0           , "Big Smoke"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 269    | SMOKE
    {0     , 0               , 0           , "Sweet"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 270    | SWEET
    {0     , 0               , 0           , "Ryder"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 271    | RYDER2
    {0     , 0               , 0           , "Mafia Boss"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 272    | FORELLI
    {0     , 0               , 0           , "T-Bone Mendez"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 273    | TBONE
    {0     , 0               , 0           , "Paramedic"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 274    | laemt1
    {0     , 0               , 0           , "Paramedic"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 275    | lvemt1
    {0     , 0               , 0           , "Paramedic"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 276    | sfemt1
    {0     , 0               , 0           , "Firefighter"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 277    | lafd1
    {0     , 0               , 0           , "Firefighter"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 278    | lvfd1
    {0     , 0               , 0           , "Firefighter"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 279    | sffd1
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 280    | lapd1
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 281    | sfpd1
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 282    | lvpd1
    {0     , 0               , 0           , "County Sheriff"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 283    | csher
    {0     , 0               , 0           , "Motorbike Cop"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 284    | lapdm1
    {0     , 0               , 0           , "Special Forces"                                                , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 285    | swat
    {0     , 0               , 0           , "Federal Agent"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 286    | fbi
    {0     , 0               , 0           , "Army"                                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 287    | army
    {0     , 0               , 0           , "Desert Sheriff"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 288    | dsher
    {0     , 0               , 0           , "Zero"                                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 289    | ZERO
    {0     , 800_000         , 550         , "Ken Rosenberg"                                                 , SKINCLASS_RARE          , SKINSEX_MALE      }, // 290    | ROSE
    {0     , 600_000         , 450         , "Kent Paul"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 291    | PAUL
    {0     , 0               , 0           , "Cesar Vialpando"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 292    | CESAR
    {0     , 0               , 0           , "OG Loc"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 293    | OGLOC
    {0     , 0               , 0           , "Wu Zi Mu"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 294    | WUZIMU
    {0     , 0               , 0           , "Michael Toreno"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 295    | TORINO
    {0     , 0               , 0           , "Jizzy"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 296    | JIZZY
    {0     , 0               , 0           , "Madd Dogg"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 297    | MADDOGG
    {0     , 0               , 0           , "Catalina"                                                      , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 298    | CAT
    {0     , 0               , 0           , "Claude"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 299    | CLAUDE
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 300    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 301    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 302    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 303    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 304    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 305    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 306    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 307    |
    {0     , 0               , 0           , "Paramedic"                                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 308    |
    {0     , 0               , 0           , "Police Officer"                                                , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 309    |
    {0     , 0               , 0           , "Country Sheriff"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 310    |
    {0     , 0               , 0           , "Desert Sheriff"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 311    |
    {294   , 300_000         , 120         , "Парень в черном"                                               , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 312    | pearspedcu
    {60    , 1_000_000       , 660         , "Стильный мужик"                                                , SKINCLASS_RARE          , SKINSEX_MALE      }, // 313    | pearspeda
    {233   , 350_000         , 140         , "Девушка в белом платье"                                        , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 314    | pearspedb
    {19    , 500_000         , 250         , "Парень с тату"                                                 , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 315    | pearspedc
    {59    , 700_000         , 280         , "Парень в кофте с черепами"                                     , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 316    | pearspedd
    {93    , 700_000         , 280         , "Девушка в костюме Adidas"                                      , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 317    | pearspede
    {19    , 500_000         , 200         , "Парень с тату в кепке"                                         , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 318    | pearspedf
    {59    , 1_000_000       , 500         , "Мужчина в подтяжках"                                           , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 319    | pearspedg
    {125   , 2_900_000       , 2_000       , "МакГрегор"                                                     , SKINCLASS_RARE          , SKINSEX_MALE      }, // 320    | pearspedh
    {23    , 1               , 1           , "Парень в красных вансах"                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 321    | pearspedi
    {21    , 1               , 1           , "Мужчина в Одежде Луи Витон"                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 322    | pearspedj
    {216   , 500_000         , 250         , "Женщина в зеленом платье"                                      , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 323    | pearspedk
    {55    , 400_000         , 200         , "Женщина в платье скелете"                                      , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 324    | pearspedl
    {93    , 1_000_000       , 650         , "Женщина в костюме Nike"                                        , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 325    | pearspedm
    {7     , 1               , 1           , "Мужчина в простой одежде"                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 326    | pearspedn
    {125   , 500_000         , 250         , "Мужчина с тату"                                                , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 327    | pearspedo
    {1     , 500_000         , 250         , "Мужчина в майке с тату"                                        , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 328    | pearspedp
    {248   , 0               , 0           , "Мужчина в джинсовой одежде"                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 329    | pearspedq
    {29    , 0               , 0           , "Мужчина в капюшоне и джинсовке"                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 330    | pearspedr
    {121   , 0               , 0           , "Мужчина в джинсовых вещах"                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 331    | pearspeds
    {125   , 0               , 0           , "Мужчина в джинсовых вещах"                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 332    | pearspedt
    {240   , 100_000         , 50          , "Мужчина в черной куртке"                                       , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 333    | pearspedu
    {223   , 3_000_000       , 2_000       , "Мужчина в фирменой одежде"                                     , SKINCLASS_RARE          , SKINSEX_MALE      }, // 334    | pearspedv
    {28    , 1               , 1           , "Мужчина в белом худи"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 335    | pearspedw
    {25    , 2_500_000       , 1_650       , "Мужчина в куртке"                                              , SKINCLASS_RARE          , SKINSEX_MALE      }, // 336    | pearspedx
    {150   , 600_000         , 240         , "Женщина в черном пальто"                                       , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 337    | pearspedy
    {237   , 500_000         , 250         , "Женщина в черно-белой одежде"                                  , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 338    | pearspedz
    {131   , 1               , 1           , "Женщина в черной одежде"                                       , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 339    | pearspedaa
    {12    , 300_000         , 120         , "Девушка в топе с вишенкой"                                     , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 340    | pearspedab
    {40    , 300_000         , 120         , "Девушка в топе"                                                , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 341    | pearspedac
    {178   , 0               , 0           , "Сексуальная девушка"                                           , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 342    | pearspedad
    {233   , 500_000         , 250         , "Девушка в Gucci"                                               , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 343    | pearspedae
    {93    , 1               , 1           , "Девушка в черной одежде"                                       , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 344    | pearspedaf
    {157   , 1               , 1           , "Девушка в зеленом"                                             , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 345    | pearspedag
    {223   , 500_000         , 200         , "Девушка в белой одежде"                                        , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 346    | pearspedah
    {233   , 600_000         , 240         , "Девушка в клетчатой рубашке"                                   , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 347    | pearspedai
    {233   , 500_000         , 250         , "Девушка в розовой одежде"                                      , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 348    | pearspedaj
    {233   , 400_000         , 160         , "Девушка в светлой одежде"                                      , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 349    | pearspedak
    {93    , 2_500_000       , 1_650       , "Девушка гот"                                                   , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 350    | pearspedal
    {233   , 250_000         , 100         , "Девушка в топе с бабочкой"                                     , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 351    | pearspedam
    {223   , 1               , 1           , "Мужчина в коричневом худи"                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 352    | pearspedan
    {240   , 1_500_000       , 1_000       , "Мужчина в сером бомбере"                                       , SKINCLASS_RARE          , SKINSEX_MALE      }, // 353    | pearspedao
    {126   , 1_000_000       , 700         , "Мужчина в свитшоте"                                            , SKINCLASS_RARE          , SKINSEX_MALE      }, // 354    | pearspedap
    {93    , 900_000         , 600         , "Девушка в бомбере"                                             , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 355    | pearspedaq
    {240   , 400_000         , 200         , "Мужчина в черной футболке"                                     , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 356    | pearspedar
    {93    , 2_500_000       , 1_700       , "Девушка в черной одежде"                                       , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 357    | pearspedas
    {93    , 500_000         , 200         , "Девушка в черной одежде"                                       , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 358    | pearspedat
    {91    , 3_000_000       , 3_000       , "Девушка в свадебном платье"                                    , SKINCLASS_LEGENDARY     , SKINSEX_FEMALE    }, // 359    | pearspedau
    {233   , 1_500_000       , 1_000       , "Беловолосая девушка в полушубе"                                , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 360    | pearspedav
    {216   , 600_000         , 300         , "Девушка в зеленом"                                             , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 361    | pearspedaw
    {216   , 0               , 0           , "Девушка в полотенце"                                           , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 362    | pearspedax
    {93    , 2_300_000       , 1_500       , "Девушка в белой куртке"                                        , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 363    | pearspeday
    {240   , 0               , 0           , "Парень в рубахе"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 364    | pearspedaz
    {180   , 200_000         , 80          , "Парень в свитшоте с сердцем"                                   , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 365    | pearspedba
    {226   , 1               , 1           , "Девушка в футболке"                                            , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 366    | pearspedbb
    {60    , 1               , 1           , "Парень в черном"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 367    | pearspedbc
    {257   , 700_000         , 350         , "Девушка в топе в сеточку"                                      , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 368    | pearspedbd
    {257   , 0               , 0           , "Проститутка"                                                   , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 369    | pearspedbe
    {41    , 1               , 1           , "Девушка в белой куртке"                                        , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 370    | pearspedbf
    {40    , 1               , 1           , "Девушка в черном платье"                                       , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 371    | pearspedbg
    {233   , 0               , 0           , "Девушка в купальнике"                                          , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 372    | pearspedbh
    {233   , 0               , 0           , "Девушка в купальнике"                                          , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 373    | pearspedbi
    {93    , 800_000         , 400         , "Девушка в черном платье"                                       , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 374    | pearspedbj
    {233   , 1_000_000       , 500         , "Девушка в розовой кофте"                                       , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 375    | pearspedbk
    {98    , 900_000         , 450         , "Мужчина в пиджаке"                                             , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 376    | pearspedbl
    {98    , 900_000         , 450         , "Мужчина в синем костюме"                                       , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 377    | pearspedbm
    {98    , 1_500_000       , 1_000       , "Мужчина в черной куртке"                                       , SKINCLASS_RARE          , SKINSEX_MALE      }, // 378    | pearspedbn
    {98    , 1_200_000       , 800         , "Мужчина в черном костюме"                                      , SKINCLASS_RARE          , SKINSEX_MALE      }, // 379    | pearspedbo
    {112   , 800_000         , 400         , "Лысый хрен в красных спортах"                                  , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 380    | pearspedbp
    {127   , 600_000         , 300         , "Мужчина в белом костюме"                                       , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 381    | pearspedbq
    {127   , 500_000         , 250         , "Мужчина в черном костюме"                                      , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 382    | pearspedbr
    {240   , 300_000         , 120         , "Парень в кофте"                                                , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 383    | pearspedbs
    {240   , 300_000         , 120         , "Парень в куртке"                                               , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 384    | pearspedbt
    {240   , 400_000         , 200         , "Парень в кофте"                                                , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 385    | pearspedbu
    {45    , 250_000         , 100         , "Парень с голым торсом"                                         , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 386    | pearspedbv
    {91    , 400_000         , 200         , "Девушка в топе и юбке"                                         , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 387    | pearspedbw
    {98    , 1_000_000       , 500         , "Мужчина в костюме"                                             , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 388    | pearspedbx
    {216   , 1_500_000       , 1_000       , "Девушка в розовой кофте"                                       , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 389    | pearspedby
    {25    , 1_100_000       , 720         , "Мужчина в белой одежде"                                        , SKINCLASS_RARE          , SKINSEX_MALE      }, // 390    | pearspedbz
    {120   , 1_000_000       , 750         , "Мужчина в черной одежде"                                       , SKINCLASS_RARE          , SKINSEX_MALE      }, // 391    | pearspedca
    {179   , 0               , 0           , "Мужчина в камуфляжной форме"                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 392    | pearspedcb
    {233   , 1               , 1           , "Девушка в спортивном стиле"                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 393    | pearspedcc
    {12    , 700_000         , 350         , "Девушка в голубой блузке"                                      , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 394    | pearspedcd
    {40    , 800_000         , 400         , "Девушка в красном топе"                                        , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 395    | pearspedce
    {85    , 2_000_000       , 1_300       , "Девушка в шубе"                                                , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 396    | pearspedcf
    {233   , 700_000         , 350         , "Девушка в белом топе"                                          , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 397    | pearspedcg
    {233   , 800_000         , 400         , "Девушка в розовой одежде"                                      , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 398    | pearspedct
    {233   , 700_000         , 350         , "Девушка в белом топе"                                          , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 399    | pearspedch
    {12    , 900_000         , 450         , "Девушка в черном пальто"                                       , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 400    | pearspedci
    {217   , 800_000         , 400         , "Мужчина в черно-белой одежде"                                  , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 401    | pearspedcj
    {12    , 2_200_000       , 2_200       , "Ким Кардашьян"                                                 , SKINCLASS_LEGENDARY     , SKINSEX_FEMALE    }, // 402    | pearspedck
    {59    , 1               , 1           , "Парень в простой одежде"                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 403    | pearspedcl
    {93    , 1_500_000       , 1_000       , "Девушка в черных легинсах"                                     , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 404    | pearspedcm
    {98    , 2_100_000       , 1_400       , "Парень в жилетке"                                              , SKINCLASS_RARE          , SKINSEX_MALE      }, // 405    | pearspedcn
    {143   , 800_000         , 400         , "Мужчина в куртке"                                              , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 406    | pearspedco
    {93    , 1_000_000       , 500         , "Девушка в белых штанах"                                        , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 407    | pearspedcp
    {91    , 1_100_000       , 550         , "Девушка в красной куртке"                                      , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 408    | pearspedcq
    {40    , 1_600_000       , 1_050       , "Девушка в Nike"                                                , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 409    | pearspedcr
    {46    , 2_000_000       , 2_000       , "Мужчина в костюме"                                             , SKINCLASS_LEGENDARY     , SKINSEX_MALE      }, // 410    | pearspedcs
    {40    , 0               , 0           , "Девушка в парандже"                                            , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 411    | pedaraba
    {221   , 0               , 0           , "Мужчина в парандже"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 412    | pedarabb
    {142   , 0               , 0           , "Мужчина в маске"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 413    | pedarabc
    {42    , 0               , 0           , "Мужчина бандит"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 414    | prisonmex
    {311   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 415    | pearscop
    {287   , 0               , 0           , "Военный"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 416    | pearsarmy1
    {287   , 0               , 0           , "Военный"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 417    | pearsarmy2
    {5     , 0               , 0           , "Мужчина толстый"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 418    | pearsswat1
    {285   , 0               , 0           , "Полицейский в броне"                                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 419    | pearsswat2
    {300   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 420    | pearscop2
    {301   , 0               , 0           , "Полицейский в броне"                                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 421    | pearsswat4
    {300   , 0               , 0           , "Полицейский в броне"                                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 422    | pearsswat5
    {300   , 0               , 0           , "Полицейский с кепкой"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 423    | pearscop3
    {305   , 1_200_000       , 600         , "Мужчина в красной рубашке"                                     , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 424    | pearscop4
    {303   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 425    | pearscop5
    {142   , 2_000_000       , 12_000      , "Неизвестный в маске"                                           , SKINCLASS_LEGENDARY     , SKINSEX_UNKNOWN   }, // 426    | pearspedcv
    {221   , 0               , 0           , "Неизвестный в белом"                                           , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 427    | pearspedcw
    {277   , 0               , 0           , "Космонавт"                                                     , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 428    | astronaut
    {6     , 0               , 0           , "Маньяк Джейсон"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 429    | jason
    {21    , 0               , 0           , "Парень в оранжевом комбинизоне"                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 430    | prisonblack
    {141   , 1_800_000       , 1_800       , "Монахиня"                                                      , SKINCLASS_LEGENDARY     , SKINSEX_FEMALE    }, // 431    | pearspedcx
    {144   , 1_500_000       , 1_000       , "Спортик"                                                       , SKINCLASS_RARE          , SKINSEX_MALE      }, // 432    | pearspedcy
    {287   , 0               , 0           , "Военный"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 433    | pearspedcz
    {146   , 1_600_000       , 1_050       , "Качок в майке"                                                 , SKINCLASS_RARE          , SKINSEX_MALE      }, // 434    | pearspedda
    {42    , 600_000         , 300         , "Мужчина в спортивном костюме"                                  , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 435    | pearspeddb
    {287   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 436    | pearspeddc
    {307   , 0               , 0           , "Полицейский (жен.)"                                            , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 437    | pearspeddd
    {310   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 438    | pearspedde
    {306   , 0               , 0           , "Полицейский (жен.)"                                            , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 439    | pearscop6
    {281   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 440    | pearspeddf
    {280   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 441    | pearspeddg
    {265   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 442    | pearspeddh
    {310   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 443    | pearspeddi
    {306   , 0               , 0           , "Полицейский (жен.)"                                            , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 444    | pearspeddj
    {306   , 0               , 0           , "Полицейский в шлеме (жен.)"                                    , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 445    | pearspeddk
    {282   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 446    | pearspeddl
    {282   , 0               , 0           , "Полицейский в очках"                                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 447    | pearspeddm
    {282   , 0               , 0           , "Полицейский (галстук)"                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 448    | pearspeddn
    {282   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 449    | pearspeddo
    {282   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 450    | pearspeddp
    {282   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 451    | pearspeddq
    {306   , 0               , 0           , "Полицейский (жен.)"                                            , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 452    | pearspeddr
    {121   , 0               , 0           , "Доминик"                                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 453    | pearspedds
    {165   , 0               , 0           , "Агент ФБР в бронежилете"                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 454    | pearspeddt
    {286   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 455    | pearspeddu
    {286   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 456    | pearspeddv
    {295   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 457    | pearspeddw
    {286   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 458    | pearspeddx
    {286   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 459    | pearspeddy
    {285   , 0               , 0           , "Спецназ ФБР"                                                   , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 460    | pearspeddz
    {285   , 0               , 0           , "Спецназ ФБР"                                                   , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 461    | pearspedea
    {165   , 0               , 0           , "Спец.агент ФБР"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 462    | pearspedeb
    {286   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 463    | pearspedec
    {286   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 464    | pearspeded
    {150   , 0               , 0           , "Агент ФБР (жен.)"                                              , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 465    | pearspedee
    {286   , 0               , 0           , "Агент ФБР"                                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 466    | pearspedef
    {29    , 1_300_000       , 850         , "Мужчина в красном анараке"                                     , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 467    | zverworks
    {121   , 0               , 0           , "Азиат с татуировками"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 468    | pearspedeg
    {118   , 0               , 0           , "Азиат в пиджаке"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 469    | pearspedeh
    {123   , 0               , 0           , "Мужчина в спортивках"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 470    | pearspedei
    {118   , 0               , 0           , "Мужчина в японском костюме"                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 471    | pearspedej
    {119   , 0               , 0           , "Русский в куртке"                                              , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 472    | pearspedek
    {66    , 800_000         , 400         , "Мужчина в открытой рубашке"                                    , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 473    | pearspedel
    {60    , 0               , 0           , "Русский с фингалом"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 474    | pearspedem
    {113   , 0               , 0           , "Русский с крестом"                                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 475    | pearspeden
    {68    , 1_500_000       , 1_000       , "Дед в куртке"                                                  , SKINCLASS_RARE          , SKINSEX_MALE      }, // 476    | pearspedeo
    {68    , 2_000_000       , 2_000       , "Дед в смокинге"                                                , SKINCLASS_LEGENDARY     , SKINSEX_MALE      }, // 477    | pearspedep
    {113   , 1_400_000       , 950         , "Мужчина в тёмном"                                              , SKINCLASS_RARE          , SKINSEX_MALE      }, // 478    | pearspedeq
    {66    , 800_000         , 400         , "Парень в веселой футболке"                                     , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 479    | pearspeder
    {111   , 0               , 0           , "Русский в темной куртке"                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 480    | pearspedes
    {247   , 1_600_000       , 1_050       , "Мужчина с бородой"                                             , SKINCLASS_RARE          , SKINSEX_MALE      }, // 481    | pearspedet
    {46    , 0               , 0           , "Русский в открытой рубашке"                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 482    | pearspedeu
    {223   , 2_000_000       , 1_300       , "Мужчина в розовом пиджаке"                                     , SKINCLASS_RARE          , SKINSEX_MALE      }, // 483    | pearspedev
    {111   , 0               , 0           , "Русский в кожаной куртке"                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 484    | pearspedew
    {46    , 0               , 0           , "Русский с татуировками"                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 485    | pearspedex
    {60    , 900_000         , 450         , "Парень в балаклаве и очках"                                    , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 486    | pearspedey
    {29    , 800_000         , 400         , "Парень в майке"                                                , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 487    | pearspedez
    {117   , 0               , 0           , "Азиат в костюме"                                               , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 488    | pearspedfa
    {121   , 2_200_000       , 1_450       , "Грозный мужчина"                                               , SKINCLASS_RARE          , SKINSEX_MALE      }, // 489    | pearspedfb
    {272   , 0               , 0           , "Серьёзный русский"                                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 490    | pearspedfc
    {126   , 0               , 0           , "Русский в костюме"                                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 491    | pearspedfd
    {125   , 3_000_000       , 2_000       , "Мужчина в белом костюме"                                       , SKINCLASS_RARE          , SKINSEX_MALE      }, // 492    | pearspedfe
    {294   , 4_000_000       , 4_000       , "Золотой Вузи"                                                  , SKINCLASS_LEGENDARY     , SKINSEX_MALE      }, // 493    | pearspedff
    {285   , 0               , 0           , "Армейский лётчик"                                              , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 494    | pearsvvs
    {70    , 0               , 0           , "Доктор в очках"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 495    | pearsdoctor
    {308   , 0               , 0           , "Сотрудник больницы (жен.)"                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 496    | pearsmedg1
    {308   , 0               , 0           , "Сотрудник больницы (жен.)"                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 497    | pearsmedg2
    {308   , 0               , 0           , "Сотрудник больницы (жен.)"                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 498    | pearsmedg3
    {308   , 0               , 0           , "Сотрудник больницы (жен.)"                                     , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 499    | pearsmedg4
    {275   , 0               , 0           , "Сотрудник больницы"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 500    | pearsmedm1
    {276   , 0               , 0           , "Сотрудник больницы"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 501    | pearsmedm2
    {275   , 0               , 0           , "Сотрудник больницы"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 502    | pearsmedm3
    {276   , 0               , 0           , "Сотрудник больницы"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 503    | pearsmedm4
    {274   , 0               , 0           , "Сотрудник больницы"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 504    | pearsmedm5
    {146   , 0               , 0           , "Скромник"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 505    | pearsebalai
    {264   , 0               , 0           , "Воплощенный вампир"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 506    | pearsvampir
    {168   , 0               , 0           , "Маньяк"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 507    | pearsbenzop
    {130   , 0               , 0           , "Овца"                                                          , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 508    | pearsovechka
    {31    , 0               , 0           , "Корова"                                                        , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 509    | pearskorova
    {153   , 0               , 0           , "Крик"                                                          , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 510    | pearsscream
    {264   , 0               , 0           , "Пенисвайз"                                                     , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 511    | pearsclown
    {82    , 0               , 0           , "Зомби"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 512    | pearszombie1
    {83    , 0               , 0           , "Зомби"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 513    | pearszombie2
    {84    , 0               , 0           , "Зомби"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 514    | pearszombie3
    {82    , 0               , 0           , "Зомби"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 515    | pearszombie4
    {83    , 0               , 0           , "Зомби"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 516    | pearszombie5
    {75    , 0               , 0           , "Зомби (жен.)"                                                  , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 517    | pearszombie6
    {77    , 0               , 0           , "Зомби (жен.)"                                                  , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 518    | pearszombie7
    {82    , 0               , 0           , "Зомби"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 519    | pearszombie8
    {83    , 0               , 0           , "Зомби"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 520    | pearszombie9
    {59    , 400_000         , 160         , "Парень с челкой"                                               , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 521    | pearskortu
    {60    , 600_000         , 240         , "Парень в темной одежде"                                        , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 522    | pearsmajodin
    {98    , 650_000         , 260         , "Парень в белой футболке"                                       , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 523    | pearsmajdva
    {23    , 700_000         , 280         , "Парень в белом с цепью"                                        , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 524    | pearsmajtri
    {248   , 1_800_000       , 1_200       , "Мужчина в веселой жилетке"                                     , SKINCLASS_RARE          , SKINSEX_MALE      }, // 525    | pearsjil
    {247   , 0               , 0           , "Парень в веселой жилетке"                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 526    | pearsjildva
    {187   , 1_400_000       , 950         , "Мужчина в пижаме"                                              , SKINCLASS_RARE          , SKINSEX_MALE      }, // 527    | pearskosb
    {91    , 1_200_000       , 800         , "Девушка в платье"                                              , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 528    | pearsmegno
    {19    , 1_000_000       , 650         , "Парень с полотенцем"                                           , SKINCLASS_RARE          , SKINSEX_MALE      }, // 529    | pearsgheze
    {93    , 750_000         , 375         , "Девушка в джинсах"                                             , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 530    | pearswjns
    {184   , 700_000         , 350         , "Пожилой в спортивном"                                          , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 531    | pearsdedsp
    {223   , 1_200_000       , 800         , "Пожилой в костюме"                                             , SKINCLASS_RARE          , SKINSEX_MALE      }, // 532    | pearssuitold
    {186   , 1_350_000       , 900         , "Пожилой в темном наряде"                                       , SKINCLASS_RARE          , SKINSEX_MALE      }, // 533    | pearssuoldv
    {208   , 1_000_000       , 500         , "Мужчина в темном"                                              , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 534    | pearsdetsu
    {66    , 600_000         , 300         , "Парень в куртке"                                               , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 535    | pearskurng
    {80    , 1_400_000       , 950         , "Боец UFC"                                                      , SKINCLASS_RARE          , SKINSEX_MALE      }, // 536    | pearsufcng
    {109   , 0               , 0           , "Бандит Vagos в темном"                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 537    | pearsvago
    {110   , 0               , 0           , "Бандит Vagos в кепке"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 538    | pearsvagtr
    {106   , 0               , 0           , "Бандит Grove в кепке"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 539    | pearsgroveo
    {107   , 0               , 0           , "Бандит Grove в куртке"                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 540    | pearsgrovet
    {195   , 0               , 0           , "Бандит Grove (жен.)"                                           , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 541    | pearsgroveg
    {102   , 0               , 0           , "Бандит Ballas"                                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 542    | pearsballo
    {102   , 0               , 0           , "Бандит Ballas в жилетке"                                       , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 543    | pearsballt
    {13    , 0               , 0           , "Бандит Ballas (жен.)"                                          , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 544    | pearsballg
    {104   , 0               , 0           , "Бандит Ballas в темном"                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 545    | pearsballtr
    {91    , 900_000         , 600         , "Девушка в белом поло"                                          , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 546    | pearsbecky
    {42    , 0               , 0           , "Неизв. в желтом комбинизоне"                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 547    | pearsorm
    {42    , 0               , 0           , "Неизв. в противогазе"                                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 548    | pearsorgm
    {258   , 1_250_000       , 830         , "Мужчина со шрамом"                                             , SKINCLASS_RARE          , SKINSEX_MALE      }, // 549    | pearsamkr
    {30    , 900_000         , 450         , "Парень в футболке с цепью"                                     , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 550    | pearsrcep
    {56    , 500_000         , 200         , "Женщина в зеленой блузке"                                      , SKINCLASS_COMMON        , SKINSEX_FEMALE    }, // 551    | pearsgigre
    {259   , 700_000         , 300         , "Пожилой с весом в футболке"                                    , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 552    | pearsolbat
    {258   , 800_000         , 320         , "Пожилой в синей куртке"                                        , SKINCLASS_COMMON        , SKINSEX_MALE      }, // 553    | pearssimsui
    {259   , 800_000         , 400         , "Пожилой в темно-синей рубашке"                                 , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 554    | pearssimpol
    {252   , 850_000         , 425         , "Пожилой в трусах"                                              , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 555    | pearssimnud
    {217   , 1_200_000       , 600         , "Мужчина в темном"                                              , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 556    | pearsardbl
    {171   , 1_500_000       , 1_000       , "Мужчина в синем костюме"                                       , SKINCLASS_RARE          , SKINSEX_MALE      }, // 557    | pearsardsui
    {208   , 1_800_000       , 1_200       , "Мужчина в темно-полосатом костюме"                             , SKINCLASS_RARE          , SKINSEX_MALE      }, // 558    | pearsardsuib
    {240   , 1_600_000       , 1_050       , "Мужчина в темно-полосатой жилетке"                             , SKINCLASS_RARE          , SKINSEX_MALE      }, // 559    | pearsardjil
    {46    , 3_000_000       , 2_000       , "Мужчина в белом костюме с розой"                               , SKINCLASS_RARE          , SKINSEX_MALE      }, // 560    | pearsardjen
    {223   , 1_100_000       , 750         , "Мужчина в джинсовке"                                           , SKINCLASS_RARE          , SKINSEX_MALE      }, // 561    | pearsardjens
    {211   , 1_200_000       , 800         , "Девушка в темно-короткой кофте"                                , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 562    | pearsgibl
    {216   , 1_000_000       , 650         , "Девушка в топе и шортах сердечки"                              , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 563    | pearsgipink
    {247   , 1_200_000       , 800         , "Байкер в огненной футболке и жилетке"                          , SKINCLASS_RARE          , SKINSEX_MALE      }, // 564    | pearsgjo
    {248   , 1_500_000       , 1_000       , "Байкер в поло и шортах-трико"                                  , SKINCLASS_RARE          , SKINSEX_MALE      }, // 565    | pearsgjt
    {254   , 900_000         , 450         , "Байкер в жилетке и белой футболке"                             , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 566    | pearsgjtr
    {100   , 1_500_000       , 1_000       , "Байкер в жилетке и джинсах"                                    , SKINCLASS_RARE          , SKINSEX_MALE      }, // 567    | pearsgjf
    {113   , 1_800_000       , 1_200       , "Пожилой в темном костюме и цепью-крест"                        , SKINCLASS_RARE          , SKINSEX_MALE      }, // 568    | pearsvicbs
    {111   , 800_000         , 400         , "Мужчина в болотной кофте"                                      , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 569    | pearsvicsrg
    {125   , 1_000_000       , 500         , "Мужчина в куртке и спортивках"                                 , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 570    | pearsvicrm
    {144   , 0               , 0           , "Террорист с камуфляжной шляпой"                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 571    | pearsterro
    {143   , 0               , 0           , "Террорист в бандане со шлемом"                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 572    | pearsterrt
    {176   , 0               , 0           , "Террорист в тюрбане и бронежилете"                             , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 573    | pearsterrtr
    {177   , 0               , 0           , "Террорист в камуфляжном бронежилете"                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 574    | pearsterrf
    {177   , 0               , 0           , "Террорист в тюрбане и камуфляжном бронежилете"                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 575    | pearsterrfm
    {183   , 0               , 0           , "Террорист в балаклаве и бронежилете"                           , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 576    | pearsterrfi
    {241   , 0               , 0           , "Террорист с зарядами РПГ"                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 577    | pearsterrs
    {273   , 1_500_000       , 750         , "Мужчина с голым торсом в татуировках"                          , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 578    | pearsmono
    {184   , 1_600_000       , 800         , "Мужчина в футболке череп с татуировками"                       , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 579    | pearsmont
    {119   , 1_200_000       , 600         , "Байкер в темном с жилеткой"                                    , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 580    | pearsmontr
    {47    , 1_300_000       , 650         , "Парень в белой футболке с цепью"                               , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 581    | pearsmonf
    {45    , 1_400_000       , 900         , "Татуированный мужчина с усами и голым торсом"                  , SKINCLASS_RARE          , SKINSEX_MALE      }, // 582    | pearsnudta
    {300   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 583    | pearsguo
    {300   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 584    | pearsgut
    {301   , 0               , 0           , "Полицейский"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 585    | pearsgutr
    {178   , 2_500_000       , 2_500       , "Кибер-женщина"                                                 , SKINCLASS_LEGENDARY     , SKINSEX_FEMALE    }, // 586    | fpearshall1
    {178   , 2_500_000       , 2_500       , "Женщина в кошачьей маске с кнутом"                             , SKINCLASS_LEGENDARY     , SKINSEX_FEMALE    }, // 587    | fpearshall2
    {152   , 1_500_000       , 1_000       , "Девушка в хэллоуинском костюме"                                , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 588    | fpearshall3
    {90    , 800_000         , 400         , "Девушка в боди хэллоуин"                                       , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 589    | fpearshall4
    {195   , 1_300_000       , 850         , "Девушка в футболке котик"                                      , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 590    | fpearshall5
    {90    , 700_000         , 350         , "Девушка в топе с летучими мышами"                              , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 591    | fpearshall6
    {137   , 1_000_000       , 1_000       , "Бомж-убийца"                                                   , SKINCLASS_LEGENDARY     , SKINSEX_MALE      }, // 592    | mpearshall1
    {252   , 1_200_000       , 800         , "Садамаза мужик"                                                , SKINCLASS_RARE          , SKINSEX_MALE      }, // 593    | mpearshall2
    {264   , 5_000_000       , 900         , "Карлик"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 594    | mpearshall3
    {258   , 1_200_000       , 120         , "Франкенштейн"                                                  , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 595    | mpearshall4
    {222   , 7_000_000       , 1_000       , "Мумия"                                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 596    | mpearshall5
    {212   , 1_000_000       , 650         , "Бешенный деревенский"                                          , SKINCLASS_RARE          , SKINSEX_MALE      }, // 597    | mpearshall6
    {211   , 750_000         , 350         , "Девушка в черном"                                              , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 598    | pearsranfem1
    {214   , 1_100_000       , 750         , "Девушка в белом"                                               , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 599    | pearsranfem2
    {101   , 0               , 0           , "Мужчина в серой куртке"                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 600    | pearsranma1
    {171   , 0               , 0           , "Мужчина в черном с перчатками"                                 , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 601    | pearsranma2
    {167   , 0               , 0           , "Анубис"                                                        , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 602    | pearsanubis
    {1     , 0               , 0           , "Скелет"                                                        , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 603    | pearsbfost
    {7     , 0               , 0           , "Призрак"                                                       , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 604    | pearsbmori
    {162   , 0               , 0           , "Медведь"                                                       , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 605    | pearsbear
    {157   , 0               , 0           , "Олень"                                                         , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 606    | pearsdeer
    {157   , 0               , 0           , "Лиса"                                                          , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 607    | pearsfox
    {157   , 0               , 0           , "Заяц"                                                          , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 608    | pearsrabbit
    {162   , 0               , 0           , "Волк"                                                          , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 609    | pearswolf
    {145   , 1_500_000       , 7_000       , "Женщина в жёлтом комбинизоне"                                  , SKINCLASS_LEGENDARY     , SKINSEX_FEMALE    }, // 610    | pearsfhaz
    {146   , 1_500_000       , 7_000       , "Мужчина в жёлтом комбинизоне"                                  , SKINCLASS_LEGENDARY     , SKINSEX_MALE      }, // 611    | pearsmhaz1
    {144   , 0               , 0           , "Мужчина в белом комбинизоне"                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 612    | pearsmhaz2
    {146   , 0               , 0           , "Парень в сером комбинизоне"                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 613    | pearsmhaz3
    {30    , 0               , 0           , "Уолтер Уайт"                                                   , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 614    | pearshaizenberg
    {60    , 0               , 0           , "Азиат в белой рубашке"                                         , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 615    | pearskitaec
    {111   , 0               , 0           , "Мужчина в темном костюме"                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 616    | pearsruski1
    {25    , 0               , 0           , "Мужчина в пуховике с белой футболкой"                          , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 617    | pearswinneg
    {191   , 0               , 0           , "Девушка в зеленом комбинизоне"                                 , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 618    | pearswarm1
    {287   , 0               , 0           , "Военный зимняя"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 619    | pearswinarm1
    {287   , 0               , 0           , "Военный зимняя"                                                , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 620    | pearswinarm2
    {191   , 0               , 0           , "Военный зимняя (жен.)"                                         , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 621    | pearswinarw1
    {216   , 0               , 0           , "Девушка в оранжевой полушубе"                                  , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 622    | pearswinw1
    {150   , 0               , 0           , "Женщина-врач"                                                  , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 623    | pearsdocw1
    {193   , 0               , 0           , "Девушка в новогоднем"                                          , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 624    | pearswinw2
    {179   , 2_000_000       , 10_000      , "Маскхалат"                                                     , SKINCLASS_LEGENDARY     , SKINSEX_MALE      }, // 625    | pearswinarm3
    {152   , 0               , 0           , "Белая кошка"                                                   , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 626    | pearscat1
    {152   , 0               , 0           , "Рыжая кошка"                                                   , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 627    | pearscat2
    {152   , 0               , 0           , "Серая кошка"                                                   , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 628    | pearscat3
    {152   , 0               , 0           , "Сиамская кошка"                                                , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 629    | pearscat4
    {152   , 0               , 0           , "Пятнистая кошка"                                               , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 630    | pearscat5
    {152   , 0               , 0           , "Черная кошка"                                                  , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 631    | pearscat6
    {153   , 0               , 0           , "Полосатый ротвейлер"                                           , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 632    | pearsdog1
    {153   , 0               , 0           , "Рыжий ротвейлер"                                               , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 633    | pearsdog2
    {153   , 0               , 0           , "Черный ротвейлер"                                              , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 634    | pearsdog3
    {153   , 0               , 0           , "Белый бостон терьер"                                           , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 635    | pearsdog4
    {153   , 0               , 0           , "Ротвейлер с зеленым ошейником"                                 , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 636    | pearsdog5
    {153   , 0               , 0           , "Черный бостон терьер"                                          , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 637    | pearsdog6
    {153   , 0               , 0           , "Рыжий стаффорд терьер"                                         , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 638    | pearsdog7
    {153   , 0               , 0           , "Черный доберман"                                               , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 639    | pearsdog8
    {153   , 0               , 0           , "Коричнево-белый бультерьер"                                    , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 640    | pearsdog9
    {153   , 0               , 0           , "Серо-белый бультерьер "                                        , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 641    | pearsdog10
    {153   , 0               , 0           , "Светло-коричневый шиба ину"                                    , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 642    | pearsdog11
    {153   , 0               , 0           , "Серая немецкая овчарка"                                        , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 643    | pearsdog12
    {153   , 0               , 0           , "Белый бультерьер"                                              , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 644    | pearsdog13
    {153   , 0               , 0           , "Сибирский хаски"                                               , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 645    | pearsdog14
    {153   , 0               , 0           , "Золотистый ретривер"                                           , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 646    | pearsdog15
    {153   , 0               , 0           , "Коричнево-белый пойнтер"                                       , SKINCLASS_SYSTEM        , SKINSEX_UNKNOWN   }, // 647    | pearsdog16
    {153   , 0               , 0           , "Далматин"                                                      , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 648    | pearsdog17
    {1     , 0               , 0           , "Санта Клаус"                                                   , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 649    | pearssanta
    {40    , 2_000_000       , 2_000       , "Женщина в розовом с шляпой"                                    , SKINCLASS_LEGENDARY     , SKINSEX_FEMALE    }, // 650    | pearsfwint1
    {55    , 1_300_000       , 850         , "Женщина-байкер"                                                , SKINCLASS_RARE          , SKINSEX_FEMALE    }, // 651    | pearsfwint2
    {56    , 700_000         , 350         , "Женщина в пуховике"                                            , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 652    | pearsfwint3
    {55    , 600_000         , 300         , "Девушка в красной толстовке"                                   , SKINCLASS_UNCOMMON      , SKINSEX_FEMALE    }, // 653    | pearsfwint4
    {60    , 800_000         , 400         , "Парень в синей зимней куртке"                                  , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 654    | pearsmwint1
    {25    , 600_000         , 300         , "Парень в темном пуховике"                                      , SKINCLASS_UNCOMMON      , SKINSEX_MALE      }, // 655    | pearsmwint2
    {46    , 1_400_000       , 950         , "Мужчина в шубе"                                                , SKINCLASS_RARE          , SKINSEX_MALE      }, // 656    | pearsmwint3
    {78    , 0               , 0           , "Бомж Клаус"                                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 657    | pearsmwint4
    {93    , 0               , 0           , "Женщина в спец. костюме"                                       , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }, // 658    | pearsfwp1
    {265   , 0               , 0           , "Полицейский зимняя"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 659    | pearsmwp1
    {280   , 0               , 0           , "Полицейский зимняя"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 660    | pearsmwp2
    {281   , 0               , 0           , "Полицейский в кепке зимняя"                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 661    | pearsmwp3
    {280   , 0               , 0           , "Полицейский в шапке зимняя"                                    , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 662    | pearsmwp4
    {266   , 0               , 0           , "Полицейский зимняя"                                            , SKINCLASS_SYSTEM        , SKINSEX_MALE      }, // 663    | pearsmwp5
    {12    , 0               , 0           , "Девушка в розовых рюшах"                                       , SKINCLASS_SYSTEM        , SKINSEX_FEMALE    }  // 664    | pearswdjp
};

#define MAX_MODELS_SKIN (sizeof(SkinPearsInfo))

stock bool:IsValidSkinId(skinid)
{
    return skinid >= 0 && skinid < sizeof(SkinPearsInfo) && SkinPearsInfo[skinid][eSkinClass] != SKINCLASS_INVALID;
}

stock bool:IsCustomSkin(skinid)
{
    return IsValidSkinId(skinid) && skinid > 311;
}

stock GetSkinPlaceholderId(skinid)
{
	if (!IsValidSkinId(skinid)) return 0;
	return SkinPearsInfo[skinid][eSampSkinID];
}

stock GetSkinDefaultPrice(skinid)
{
    if (!IsValidSkinId(skinid)) return 0;
    return max(0, SkinPearsInfo[skinid][eSkinPrice]);
}

stock GetSkinDefaultGoldPrice(skinid)
{
    if (!IsValidSkinId(skinid)) return 0;
    return max(0, SkinPearsInfo[skinid][eSkinGoldPrice]);
}

stock GetSkinName(skinid)
{
	new result[MAX_SKIN_NAME];
	result[0] = '\0';
    if (IsValidSkinId(skinid))
	{
		strcopy(result, SkinPearsInfo[skinid][eSkinName]);
	}
    return result;
}

stock SKINSEXENUM:GetSkinSex_New(skinid)
{
    if (!IsValidSkinId(skinid)) return SKINSEX_UNKNOWN;
    return SkinPearsInfo[skinid][eSkinSex];
}

stock GetSkinSex(skinid)
{
    return _:GetSkinSex_New(skinid);
}

stock SKINCLASSENUM:GetSkinClass(skinid)
{
    if (!IsValidSkinId(skinid)) return SKINCLASS_INVALID;
    return SkinPearsInfo[skinid][eSkinClass];
}

stock bool:IsSkinMale(skinid)
{
    return GetSkinSex(skinid) == SKINSEX_MALE;
}

stock bool:IsSkinFemale(skinid)
{
    return GetSkinSex(skinid) == SKINSEX_FEMALE;
}

stock bool:IsSpecialSystemSkin(skinid)
{
    if (!IsValidSkinId(skinid)) return false;
    // Скромник (SCP)
	if (skinid == 505) return true;
	// Горилла, Маньяк, Овца, Корова, Крик, Пеннивайз
	if (skinid >= 506 && skinid <= 511) return true;
	// Хеллоуин
	if (skinid >= 594 && skinid <= 596) return true;
	// Зомби
	if (skinid >= 512 && skinid <= 520) return true;
	// Раскопка могил и гробница
	if (skinid >= 602 && skinid <= 604) return true;
	// Звери
	if (skinid >= 605 && skinid <= 609) return true;
	// Домашние животные + Санта
	if (skinid >= 626 && skinid <= 649) return true;
	return false;
}

stock bool:CanSkinBeAvailableForSaleInShops(skinid)
{
	if (!IsValidSkinId(skinid)) return false;
    if (GetSkinDefaultPrice(skinid) <= 0) return false;
    if (IsSpecialSystemSkin(skinid)) return false;
    switch (GetSkinClass(skinid))
    {
    case SKINCLASS_COMMON, SKINCLASS_UNCOMMON:
        return true;
    }
    return false;
}

stock bool:CanSkinBeAvailableForSaleForGoldInShops(skinid)
{
	if (!IsValidSkinId(skinid)) return false;
    if (GetSkinDefaultGoldPrice(skinid) <= 0) return false;
    if (IsSpecialSystemSkin(skinid)) return false;
    switch (GetSkinClass(skinid))
    {
    case SKINCLASS_COMMON, SKINCLASS_UNCOMMON, SKINCLASS_RARE:
        return true;
    }
    return false;
}

stock AddCustomSkins()
{
    for (new i = 0; i < sizeof(SkinPearsInfo); i++)
    {
        if (SkinPearsInfo[i][eSampSkinID] == 0) continue;
        AddCharSyncModel(SkinPearsInfo[i][eSampSkinID], i);
    }
}

stock DeleteSpecialSystemSkins(playerid)
{
	if (IsPlayerNPC(playerid)) return 0;
	
	if (IsSpecialSystemSkin(PlayerInfo[playerid][pModel])) {
		TakeOffClothes(playerid);
	}
	for(new i = 0; i < 40; i++)
	{
		if (PlayerInfo[playerid][pInvenType][i] != 3) continue;
		new quan = PlayerInfo[playerid][pInvenQuan][i];
		if (quan < 1) continue;
		new skinid = PlayerInfo[playerid][pInven][i];
		if (IsSpecialSystemSkin(skinid)) {
			TakeInvent(playerid, skinid, quan, 3, i);
		}
	}
	return 1;
}

// Сюда добавляются скины для организаций (Максимально 50 слотов, значит 49 ПОСЛЕДНИЙ)
forward ReloadSkin(playerid, g);
public ReloadSkin(playerid, g)
{
	for(new i = 0; i < MAX_SKIN_ORGANIZATION; i++) OrganInfo[g][gSkin][i] = 0;

	if(g == 1 || g == 11 || g == 21 || g == 22) // SAPD
	{
		OrganInfo[g][gSkin][0] = 300, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 284, OrganInfo[g][gSkinPrice][1] = 10000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 301, OrganInfo[g][gSkinPrice][2] = 20000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 302, OrganInfo[g][gSkinPrice][3] = 30000, OrganInfo[g][gSkinRank][3] = 4;
		OrganInfo[g][gSkin][4] = 265, OrganInfo[g][gSkinPrice][4] = 40000, OrganInfo[g][gSkinRank][4] = 10;
		OrganInfo[g][gSkin][5] = 266, OrganInfo[g][gSkinPrice][5] = 50000, OrganInfo[g][gSkinRank][5] = 10;
		OrganInfo[g][gSkin][6] = 267, OrganInfo[g][gSkinPrice][6] = 60000, OrganInfo[g][gSkinRank][6] = 10;
		OrganInfo[g][gSkin][7] = 303, OrganInfo[g][gSkinPrice][7] = 70000, OrganInfo[g][gSkinRank][7] = 6;
		OrganInfo[g][gSkin][8] = 304, OrganInfo[g][gSkinPrice][8] = 80000, OrganInfo[g][gSkinRank][8] = 6;
		OrganInfo[g][gSkin][9] = 305, OrganInfo[g][gSkinPrice][9] = 90000, OrganInfo[g][gSkinRank][9] = 6;
		OrganInfo[g][gSkin][10] = 310, OrganInfo[g][gSkinPrice][10] = 100000, OrganInfo[g][gSkinRank][10] = 14;
		OrganInfo[g][gSkin][11] = 311, OrganInfo[g][gSkinPrice][11] = 150000, OrganInfo[g][gSkinRank][11] = 14;
		OrganInfo[g][gSkin][12] = 306, OrganInfo[g][gSkinPrice][12] = 0, OrganInfo[g][gSkinRank][12] = 1;
		OrganInfo[g][gSkin][13] = 307, OrganInfo[g][gSkinPrice][13] = 10000, OrganInfo[g][gSkinRank][13] = 5;
		OrganInfo[g][gSkin][14] = 309, OrganInfo[g][gSkinPrice][14] = 50000, OrganInfo[g][gSkinRank][14] = 10;
		OrganInfo[g][gSkin][15] = 150, OrganInfo[g][gSkinPrice][15] = 100000, OrganInfo[g][gSkinRank][15] = 14;
		OrganInfo[g][gSkin][16] = 423, OrganInfo[g][gSkinPrice][16] = 10000, OrganInfo[g][gSkinRank][16] = 1;
		OrganInfo[g][gSkin][17] = 420, OrganInfo[g][gSkinPrice][17] = 10000, OrganInfo[g][gSkinRank][17] = 1;
		OrganInfo[g][gSkin][18] = 424, OrganInfo[g][gSkinPrice][18] = 100000, OrganInfo[g][gSkinRank][18] = 10;
		OrganInfo[g][gSkin][19] = 425, OrganInfo[g][gSkinPrice][19] = 100000, OrganInfo[g][gSkinRank][19] = 10;
		OrganInfo[g][gSkin][20] = 415, OrganInfo[g][gSkinPrice][20] = 200000, OrganInfo[g][gSkinRank][20] = 14;
		OrganInfo[g][gSkin][21] = 440, OrganInfo[g][gSkinPrice][21] = 30000, OrganInfo[g][gSkinRank][21] = 2;
		OrganInfo[g][gSkin][22] = 441, OrganInfo[g][gSkinPrice][22] = 30000, OrganInfo[g][gSkinRank][22] = 2;
		OrganInfo[g][gSkin][23] = 442, OrganInfo[g][gSkinPrice][23] = 90000, OrganInfo[g][gSkinRank][23] = 5;
		OrganInfo[g][gSkin][24] = 443, OrganInfo[g][gSkinPrice][24] = 250000, OrganInfo[g][gSkinRank][24] = 14;
		OrganInfo[g][gSkin][25] = 444, OrganInfo[g][gSkinPrice][25] = 250000, OrganInfo[g][gSkinRank][25] = 14;
		OrganInfo[g][gSkin][26] = 285, OrganInfo[g][gSkinPrice][26] = 0, OrganInfo[g][gSkinRank][26] = 1;
		OrganInfo[g][gSkin][27] = 419, OrganInfo[g][gSkinPrice][27] = 10000, OrganInfo[g][gSkinRank][27] = 5;
		OrganInfo[g][gSkin][28] = 421, OrganInfo[g][gSkinPrice][28] = 20000, OrganInfo[g][gSkinRank][28] = 6;
		OrganInfo[g][gSkin][29] = 422, OrganInfo[g][gSkinPrice][29] = 20000, OrganInfo[g][gSkinRank][29] = 6;
		OrganInfo[g][gSkin][30] = 445, OrganInfo[g][gSkinPrice][30] = 10000, OrganInfo[g][gSkinRank][30] = 2;
		// Для LVPD
		OrganInfo[g][gSkin][32] = 446, OrganInfo[g][gSkinPrice][32] = 30000, OrganInfo[g][gSkinRank][32] = 2;
		OrganInfo[g][gSkin][33] = 447, OrganInfo[g][gSkinPrice][33] = 30000, OrganInfo[g][gSkinRank][33] = 2;
		OrganInfo[g][gSkin][34] = 448, OrganInfo[g][gSkinPrice][34] = 90000, OrganInfo[g][gSkinRank][34] = 5;
		OrganInfo[g][gSkin][35] = 449, OrganInfo[g][gSkinPrice][35] = 90000, OrganInfo[g][gSkinRank][35] = 5;
		OrganInfo[g][gSkin][36] = 450, OrganInfo[g][gSkinPrice][36] = 90000, OrganInfo[g][gSkinRank][36] = 5;
		OrganInfo[g][gSkin][37] = 451, OrganInfo[g][gSkinPrice][37] = 90000, OrganInfo[g][gSkinRank][37] = 5;
		OrganInfo[g][gSkin][38] = 452, OrganInfo[g][gSkinPrice][38] = 30000, OrganInfo[g][gSkinRank][38] = 2;
		OrganInfo[g][gSkin][39] = 443, OrganInfo[g][gSkinPrice][39] = 250000, OrganInfo[g][gSkinRank][39] = 14;
		OrganInfo[g][gSkin][40] = 444, OrganInfo[g][gSkinPrice][40] = 250000, OrganInfo[g][gSkinRank][40] = 14;
		OrganInfo[g][gSkin][41] = 583, OrganInfo[g][gSkinPrice][41] = 50000, OrganInfo[g][gSkinRank][41] = 3;
		OrganInfo[g][gSkin][42] = 584, OrganInfo[g][gSkinPrice][42] = 50000, OrganInfo[g][gSkinRank][42] = 3;
		OrganInfo[g][gSkin][43] = 585, OrganInfo[g][gSkinPrice][43] = 50000, OrganInfo[g][gSkinRank][43] = 3;
		// зимние
		OrganInfo[g][gSkin][44] = 658, OrganInfo[g][gSkinPrice][44] = 10000, OrganInfo[g][gSkinRank][44] = 1;
		OrganInfo[g][gSkin][45] = 659, OrganInfo[g][gSkinPrice][45] = 70000, OrganInfo[g][gSkinRank][45] = 5;
		OrganInfo[g][gSkin][46] = 660, OrganInfo[g][gSkinPrice][46] = 30000, OrganInfo[g][gSkinRank][46] = 2;
		OrganInfo[g][gSkin][47] = 661, OrganInfo[g][gSkinPrice][47] = 10000, OrganInfo[g][gSkinRank][47] = 1;
		OrganInfo[g][gSkin][48] = 662, OrganInfo[g][gSkinPrice][48] = 10000, OrganInfo[g][gSkinRank][48] = 1;
		OrganInfo[g][gSkin][49] = 663, OrganInfo[g][gSkinPrice][49] = 10000, OrganInfo[g][gSkinRank][49] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 2) // FBI
	{
        // Custom
        OrganInfo[g][gSkin][0] = 454, OrganInfo[g][gSkinPrice][0] = 30000, OrganInfo[g][gSkinRank][0] = 7;
        OrganInfo[g][gSkin][1] = 455, OrganInfo[g][gSkinPrice][1] = 0, OrganInfo[g][gSkinRank][1] = 1;
        OrganInfo[g][gSkin][2] = 456, OrganInfo[g][gSkinPrice][2] = 0, OrganInfo[g][gSkinRank][2] = 1;
        OrganInfo[g][gSkin][3] = 457, OrganInfo[g][gSkinPrice][3] = 0, OrganInfo[g][gSkinRank][3] = 1;
        OrganInfo[g][gSkin][4] = 458, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
        OrganInfo[g][gSkin][5] = 459, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
        OrganInfo[g][gSkin][6] = 460, OrganInfo[g][gSkinPrice][6] = 10000, OrganInfo[g][gSkinRank][6] = 3;
        OrganInfo[g][gSkin][7] = 461, OrganInfo[g][gSkinPrice][7] = 10000, OrganInfo[g][gSkinRank][7] = 3;
        OrganInfo[g][gSkin][8] = 462, OrganInfo[g][gSkinPrice][8] = 25000, OrganInfo[g][gSkinRank][8] = 6;
        OrganInfo[g][gSkin][9] = 463, OrganInfo[g][gSkinPrice][9] = 35000, OrganInfo[g][gSkinRank][9] = 7;
        OrganInfo[g][gSkin][10] = 464, OrganInfo[g][gSkinPrice][10] = 35000, OrganInfo[g][gSkinRank][10] = 7;
        OrganInfo[g][gSkin][11] = 465, OrganInfo[g][gSkinPrice][11] = 0, OrganInfo[g][gSkinRank][11] = 1;
        OrganInfo[g][gSkin][12] = 466, OrganInfo[g][gSkinPrice][12] = 35000, OrganInfo[g][gSkinRank][12] = 7;
        // Old скины
		OrganInfo[g][gSkin][13] = 286, OrganInfo[g][gSkinPrice][13] = 0, OrganInfo[g][gSkinRank][13] = 1;
		OrganInfo[g][gSkin][14] = 164, OrganInfo[g][gSkinPrice][14] = 50000, OrganInfo[g][gSkinRank][14] = 5;
		OrganInfo[g][gSkin][15] = 165, OrganInfo[g][gSkinPrice][15] = 100000, OrganInfo[g][gSkinRank][15] = 10;
		OrganInfo[g][gSkin][16] = 166, OrganInfo[g][gSkinPrice][16] = 150000, OrganInfo[g][gSkinRank][16] = 10;
		OrganInfo[g][gSkin][17] = 141, OrganInfo[g][gSkinPrice][17] = 0, OrganInfo[g][gSkinRank][17] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 3) // NGSA
	{
		OrganInfo[g][gSkin][0] = 73, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 287, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 179, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 253, OrganInfo[g][gSkinPrice][3] = 70000, OrganInfo[g][gSkinRank][3] = 10;
		OrganInfo[g][gSkin][4] = 61, OrganInfo[g][gSkinPrice][4] = 100000, OrganInfo[g][gSkinRank][4] = 12;
		OrganInfo[g][gSkin][5] = 295, OrganInfo[g][gSkinPrice][5] = 150000, OrganInfo[g][gSkinRank][5] = 18;
		OrganInfo[g][gSkin][6] = 191, OrganInfo[g][gSkinPrice][6] = 0, OrganInfo[g][gSkinRank][6] = 0;
		OrganInfo[g][gSkin][7] = 141, OrganInfo[g][gSkinPrice][7] = 0, OrganInfo[g][gSkinRank][7] = 10;
		OrganInfo[g][gSkin][8] = 392, OrganInfo[g][gSkinPrice][8] = 200000, OrganInfo[g][gSkinRank][8] = 10;
		OrganInfo[g][gSkin][9] = 416, OrganInfo[g][gSkinPrice][9] = 170000, OrganInfo[g][gSkinRank][9] = 10;
		OrganInfo[g][gSkin][10] = 417, OrganInfo[g][gSkinPrice][10] = 290000, OrganInfo[g][gSkinRank][10] = 10;
		OrganInfo[g][gSkin][11] = 433, OrganInfo[g][gSkinPrice][11] = 190000, OrganInfo[g][gSkinRank][11] = 5;
		OrganInfo[g][gSkin][12] = 436, OrganInfo[g][gSkinPrice][12] = 90000, OrganInfo[g][gSkinRank][12] = 10;
		OrganInfo[g][gSkin][13] = 437, OrganInfo[g][gSkinPrice][13] = 90000, OrganInfo[g][gSkinRank][13] = 10;
		OrganInfo[g][gSkin][14] = 438, OrganInfo[g][gSkinPrice][14] = 90000, OrganInfo[g][gSkinRank][14] = 10;
		OrganInfo[g][gSkin][15] = 439, OrganInfo[g][gSkinPrice][15] = 90000, OrganInfo[g][gSkinRank][15] = 10;
		OrganInfo[g][gSkin][16] = 494, OrganInfo[g][gSkinPrice][16] = 20000, OrganInfo[g][gSkinRank][16] = 2;
		OrganInfo[g][gSkin][17] = 618, OrganInfo[g][gSkinPrice][17] = 20000, OrganInfo[g][gSkinRank][17] = 2;
		OrganInfo[g][gSkin][18] = 619, OrganInfo[g][gSkinPrice][18] = 20000, OrganInfo[g][gSkinRank][18] = 2;
		OrganInfo[g][gSkin][19] = 620, OrganInfo[g][gSkinPrice][19] = 20000, OrganInfo[g][gSkinRank][19] = 2;
		OrganInfo[g][gSkin][20] = 621, OrganInfo[g][gSkinPrice][20] = 20000, OrganInfo[g][gSkinRank][20] = 2;
		OrganInfo[g][gSkin][21] = 625, OrganInfo[g][gSkinPrice][21] = 20000, OrganInfo[g][gSkinRank][21] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 4) // ASGH (Медики)
	{
		OrganInfo[g][gSkin][0] = 274, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 275, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 276, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 156, OrganInfo[g][gSkinPrice][3] = 70000, OrganInfo[g][gSkinRank][3] = 7;
		OrganInfo[g][gSkin][4] = 70, OrganInfo[g][gSkinPrice][4] = 100000, OrganInfo[g][gSkinRank][4] = 10;
		OrganInfo[g][gSkin][5] = 308, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 0;
		OrganInfo[g][gSkin][6] = 219, OrganInfo[g][gSkinPrice][6] = 70000, OrganInfo[g][gSkinRank][6] = 10;
		OrganInfo[g][gSkin][7] = 495, OrganInfo[g][gSkinPrice][7] = 90000, OrganInfo[g][gSkinRank][7] = 7;
		OrganInfo[g][gSkin][8] = 496, OrganInfo[g][gSkinPrice][8] = 10000, OrganInfo[g][gSkinRank][8] = 1;
		OrganInfo[g][gSkin][9] = 497, OrganInfo[g][gSkinPrice][9] = 10000, OrganInfo[g][gSkinRank][9] = 1;
		OrganInfo[g][gSkin][10] = 498, OrganInfo[g][gSkinPrice][10] = 10000, OrganInfo[g][gSkinRank][10] = 1;
		OrganInfo[g][gSkin][11] = 499, OrganInfo[g][gSkinPrice][11] = 10000, OrganInfo[g][gSkinRank][11] = 1;
		OrganInfo[g][gSkin][12] = 500, OrganInfo[g][gSkinPrice][12] = 10000, OrganInfo[g][gSkinRank][12] = 1;
		OrganInfo[g][gSkin][13] = 501, OrganInfo[g][gSkinPrice][13] = 10000, OrganInfo[g][gSkinRank][13] = 1;
		OrganInfo[g][gSkin][14] = 502, OrganInfo[g][gSkinPrice][14] = 10000, OrganInfo[g][gSkinRank][14] = 1;
		OrganInfo[g][gSkin][15] = 503, OrganInfo[g][gSkinPrice][15] = 10000, OrganInfo[g][gSkinRank][15] = 1;
		OrganInfo[g][gSkin][16] = 504, OrganInfo[g][gSkinPrice][16] = 10000, OrganInfo[g][gSkinRank][16] = 1;
		OrganInfo[g][gSkin][17] = 623, OrganInfo[g][gSkinPrice][17] = 10000, OrganInfo[g][gSkinRank][17] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 5) // Cosa Nostra
	{
		OrganInfo[g][gSkin][0] = 124, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 126, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 127, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 185, OrganInfo[g][gSkinPrice][3] = 40000, OrganInfo[g][gSkinRank][3] = 4;
		OrganInfo[g][gSkin][4] = 98, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 6;
		OrganInfo[g][gSkin][5] = 223, OrganInfo[g][gSkinPrice][5] = 70000, OrganInfo[g][gSkinRank][5] = 7;
		OrganInfo[g][gSkin][6] = 94, OrganInfo[g][gSkinPrice][6] = 70000, OrganInfo[g][gSkinRank][6] = 7;
		OrganInfo[g][gSkin][7] = 113, OrganInfo[g][gSkinPrice][7] = 100000, OrganInfo[g][gSkinRank][7] = 8;
		OrganInfo[g][gSkin][8] = 12, OrganInfo[g][gSkinPrice][8] = 0, OrganInfo[g][gSkinRank][8] = 1;
		OrganInfo[g][gSkin][9] = 214, OrganInfo[g][gSkinPrice][9] = 100000, OrganInfo[g][gSkinRank][9] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 6) // Yakuza Mafia
	{
		OrganInfo[g][gSkin][0] = 468, OrganInfo[g][gSkinPrice][0] = 50000, OrganInfo[g][gSkinRank][0] = 3;
		OrganInfo[g][gSkin][1] = 469, OrganInfo[g][gSkinPrice][1] = 0, OrganInfo[g][gSkinRank][1] = 1;
		OrganInfo[g][gSkin][2] = 470, OrganInfo[g][gSkinPrice][2] = 90000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 471, OrganInfo[g][gSkinPrice][3] = 90000, OrganInfo[g][gSkinRank][3] = 6;
		OrganInfo[g][gSkin][4] = 488, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 6;

		OrganInfo[g][gSkin][5] = 122, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
		OrganInfo[g][gSkin][6] = 123, OrganInfo[g][gSkinPrice][6] = 40000, OrganInfo[g][gSkinRank][6] = 4;
		OrganInfo[g][gSkin][7] = 203, OrganInfo[g][gSkinPrice][7] = 50000, OrganInfo[g][gSkinRank][7] = 5;
		OrganInfo[g][gSkin][8] = 49, OrganInfo[g][gSkinPrice][8] = 100000, OrganInfo[g][gSkinRank][8] = 8;
		OrganInfo[g][gSkin][9] = 55, OrganInfo[g][gSkinPrice][9] = 0, OrganInfo[g][gSkinRank][9] = 0;
		OrganInfo[g][gSkin][10] = 169, OrganInfo[g][gSkinPrice][10] = 100000, OrganInfo[g][gSkinRank][10] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 7) // Правительство
	{
		OrganInfo[g][gSkin][0] = 255, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 163, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 1;
		OrganInfo[g][gSkin][2] = 187, OrganInfo[g][gSkinPrice][2] = 40000, OrganInfo[g][gSkinRank][2] = 1;
		OrganInfo[g][gSkin][3] = 240, OrganInfo[g][gSkinPrice][3] = 60000, OrganInfo[g][gSkinRank][3] = 6;
		OrganInfo[g][gSkin][4] = 57, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 7;
		OrganInfo[g][gSkin][5] = 227, OrganInfo[g][gSkinPrice][5] = 100000, OrganInfo[g][gSkinRank][5] = 7;
		OrganInfo[g][gSkin][6] = 228, OrganInfo[g][gSkinPrice][6] = 100000, OrganInfo[g][gSkinRank][6] = 7;
		OrganInfo[g][gSkin][7] = 147, OrganInfo[g][gSkinPrice][7] = 100000, OrganInfo[g][gSkinRank][7] = 7;
		OrganInfo[g][gSkin][8] = 290, OrganInfo[g][gSkinPrice][8] = 100000, OrganInfo[g][gSkinRank][8] = 7;
		OrganInfo[g][gSkin][9] = 295, OrganInfo[g][gSkinPrice][9] = 100000, OrganInfo[g][gSkinRank][9] = 7;
		OrganInfo[g][gSkin][10] = 68, OrganInfo[g][gSkinPrice][10] = 100000, OrganInfo[g][gSkinRank][10] = 15;
		OrganInfo[g][gSkin][11] = 194, OrganInfo[g][gSkinPrice][11] = 0, OrganInfo[g][gSkinRank][11] = 1;
		OrganInfo[g][gSkin][12] = 150, OrganInfo[g][gSkinPrice][12] = 30000, OrganInfo[g][gSkinRank][12] = 1;
		OrganInfo[g][gSkin][13] = 141, OrganInfo[g][gSkinPrice][13] = 50000, OrganInfo[g][gSkinRank][13] = 5;
		OrganInfo[g][gSkin][14] = 91, OrganInfo[g][gSkinPrice][14] = 100000, OrganInfo[g][gSkinRank][14] = 15;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 8) // ICA
	{
		OrganInfo[g][gSkin][0] = 33, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 29, OrganInfo[g][gSkinPrice][1] = 1, OrganInfo[g][gSkinRank][1] = 11;
		OrganInfo[g][gSkin][2] = 208, OrganInfo[g][gSkinPrice][2] = 1, OrganInfo[g][gSkinRank][2] = 11;
		OrganInfo[g][gSkin][3] = 294, OrganInfo[g][gSkinPrice][3] = 1, OrganInfo[g][gSkinRank][3] = 11;
		OrganInfo[g][gSkin][4] = 285, OrganInfo[g][gSkinPrice][4] = 1, OrganInfo[g][gSkinRank][4] = 11;
		OrganInfo[g][gSkin][5] = 11, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
		OrganInfo[g][gSkin][6] = 211, OrganInfo[g][gSkinPrice][6] = 1, OrganInfo[g][gSkinRank][6] = 11;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 9) // CNN
	{
		OrganInfo[g][gSkin][0] = 188, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 186, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 291, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 297, OrganInfo[g][gSkinPrice][3] = 50000, OrganInfo[g][gSkinRank][3] = 5;
		OrganInfo[g][gSkin][4] = 290, OrganInfo[g][gSkinPrice][4] = 100000, OrganInfo[g][gSkinRank][4] = 8;
		OrganInfo[g][gSkin][5] = 148, OrganInfo[g][gSkinPrice][5] = 0, OrganInfo[g][gSkinRank][5] = 1;
		OrganInfo[g][gSkin][6] = 12, OrganInfo[g][gSkinPrice][6] = 30000, OrganInfo[g][gSkinRank][6] = 3;
		OrganInfo[g][gSkin][7] = 76, OrganInfo[g][gSkinPrice][7] = 50000, OrganInfo[g][gSkinRank][7] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 10) // Triada Mafia
	{
		OrganInfo[g][gSkin][0] = 117, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 118, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 120, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 208, OrganInfo[g][gSkinPrice][3] = 50000, OrganInfo[g][gSkinRank][3] = 5;
		OrganInfo[g][gSkin][4] = 204, OrganInfo[g][gSkinPrice][4] = 70000, OrganInfo[g][gSkinRank][4] = 7;
		OrganInfo[g][gSkin][5] = 229, OrganInfo[g][gSkinPrice][5] = 100000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 263, OrganInfo[g][gSkinPrice][6] = 0, OrganInfo[g][gSkinRank][6] = 1;
		OrganInfo[g][gSkin][7] = 225, OrganInfo[g][gSkinPrice][7] = 50000, OrganInfo[g][gSkinRank][7] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 12) // Russian Mafia
	{
		OrganInfo[g][gSkin][0] = 472, OrganInfo[g][gSkinPrice][0] = 70000, OrganInfo[g][gSkinRank][0] = 8;
		OrganInfo[g][gSkin][1] = 474, OrganInfo[g][gSkinPrice][1] = 0, OrganInfo[g][gSkinRank][1] = 1;
		OrganInfo[g][gSkin][2] = 475, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 480, OrganInfo[g][gSkinPrice][3] = 40000, OrganInfo[g][gSkinRank][3] = 3;
		OrganInfo[g][gSkin][4] = 482, OrganInfo[g][gSkinPrice][4] = 80000, OrganInfo[g][gSkinRank][4] = 7;
		OrganInfo[g][gSkin][5] = 484, OrganInfo[g][gSkinPrice][5] = 19000, OrganInfo[g][gSkinRank][5] = 2;
		OrganInfo[g][gSkin][6] = 485, OrganInfo[g][gSkinPrice][6] = 95000, OrganInfo[g][gSkinRank][6] = 6;
		OrganInfo[g][gSkin][7] = 490, OrganInfo[g][gSkinPrice][7] = 60000, OrganInfo[g][gSkinRank][7] = 6;
		OrganInfo[g][gSkin][8] = 491, OrganInfo[g][gSkinPrice][8] = 80000, OrganInfo[g][gSkinRank][8] = 7;

		OrganInfo[g][gSkin][9] = 112, OrganInfo[g][gSkinPrice][9] = 0, OrganInfo[g][gSkinRank][9] = 1;
		OrganInfo[g][gSkin][10] = 111, OrganInfo[g][gSkinPrice][10] = 20000, OrganInfo[g][gSkinRank][10] = 2;
		OrganInfo[g][gSkin][11] = 125, OrganInfo[g][gSkinPrice][11] = 30000, OrganInfo[g][gSkinRank][11] = 3;
		OrganInfo[g][gSkin][12] = 46, OrganInfo[g][gSkinPrice][12] = 50000, OrganInfo[g][gSkinRank][12] = 5;
		OrganInfo[g][gSkin][13] = 272, OrganInfo[g][gSkinPrice][13] = 100000, OrganInfo[g][gSkinRank][13] = 8;
		OrganInfo[g][gSkin][14] = 192, OrganInfo[g][gSkinPrice][14] = 0, OrganInfo[g][gSkinRank][14] = 1;
		OrganInfo[g][gSkin][15] = 85, OrganInfo[g][gSkinPrice][15] = 100000, OrganInfo[g][gSkinRank][15] = 8;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 13) // Grove Street
	{
		OrganInfo[g][gSkin][0] = 105, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 106, OrganInfo[g][gSkinPrice][1] = 20000, OrganInfo[g][gSkinRank][1] = 2;
		OrganInfo[g][gSkin][2] = 107, OrganInfo[g][gSkinPrice][2] = 30000, OrganInfo[g][gSkinRank][2] = 3;
		OrganInfo[g][gSkin][3] = 269, OrganInfo[g][gSkinPrice][3] = 40000, OrganInfo[g][gSkinRank][3] = 4;
		OrganInfo[g][gSkin][4] = 270, OrganInfo[g][gSkinPrice][4] = 50000, OrganInfo[g][gSkinRank][4] = 5;
		OrganInfo[g][gSkin][5] = 271, OrganInfo[g][gSkinPrice][5] = 100000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 207, OrganInfo[g][gSkinPrice][6] = 0, OrganInfo[g][gSkinRank][6] = 1;
		OrganInfo[g][gSkin][7] = 65, OrganInfo[g][gSkinPrice][7] = 90000, OrganInfo[g][gSkinRank][7] = 8;
		OrganInfo[g][gSkin][8] = 539, OrganInfo[g][gSkinPrice][8] = 10000, OrganInfo[g][gSkinRank][8] = 2;
		OrganInfo[g][gSkin][9] = 540, OrganInfo[g][gSkinPrice][9] = 10000, OrganInfo[g][gSkinRank][9] = 2;
		OrganInfo[g][gSkin][10] = 541, OrganInfo[g][gSkinPrice][10] = 10000, OrganInfo[g][gSkinRank][10] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 14) // Ballas Gang
	{
		OrganInfo[g][gSkin][0] = 103, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 102, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 104, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 296, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 243, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
		OrganInfo[g][gSkin][5] = 13, OrganInfo[g][gSkinPrice][5] = 90000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 542, OrganInfo[g][gSkinPrice][6] = 10000, OrganInfo[g][gSkinRank][6] = 2;
		OrganInfo[g][gSkin][7] = 543, OrganInfo[g][gSkinPrice][7] = 10000, OrganInfo[g][gSkinRank][7] = 2;
		OrganInfo[g][gSkin][8] = 544, OrganInfo[g][gSkinPrice][8] = 10000, OrganInfo[g][gSkinRank][8] = 2;
		OrganInfo[g][gSkin][9] = 545, OrganInfo[g][gSkinPrice][9] = 10000, OrganInfo[g][gSkinRank][9] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 15) // Vagos Gang
	{
		OrganInfo[g][gSkin][0] = 108, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 109, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 110, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 47, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 63, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
		OrganInfo[g][gSkin][5] = 12, OrganInfo[g][gSkinPrice][5] = 90000, OrganInfo[g][gSkinRank][5] = 8;
		OrganInfo[g][gSkin][6] = 537, OrganInfo[g][gSkinPrice][6] = 10000, OrganInfo[g][gSkinRank][6] = 2;
		OrganInfo[g][gSkin][7] = 538, OrganInfo[g][gSkinPrice][7] = 10000, OrganInfo[g][gSkinRank][7] = 2;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 16) // Los Aztecas
	{
		OrganInfo[g][gSkin][0] = 114, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 115, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 116, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 292, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 298, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	else if(g == 18) // Arabian
	{
		OrganInfo[g][gSkin][0] = 142, OrganInfo[g][gSkinPrice][0] = 0, OrganInfo[g][gSkinRank][0] = 1;
		OrganInfo[g][gSkin][1] = 220, OrganInfo[g][gSkinPrice][1] = 30000, OrganInfo[g][gSkinRank][1] = 3;
		OrganInfo[g][gSkin][2] = 222, OrganInfo[g][gSkinPrice][2] = 50000, OrganInfo[g][gSkinRank][2] = 5;
		OrganInfo[g][gSkin][3] = 221, OrganInfo[g][gSkinPrice][3] = 100000, OrganInfo[g][gSkinRank][3] = 8;
		OrganInfo[g][gSkin][4] = 40, OrganInfo[g][gSkinPrice][4] = 0, OrganInfo[g][gSkinRank][4] = 1;

		// Custom
		OrganInfo[g][gSkin][5] = 411, OrganInfo[g][gSkinPrice][5] = 20000, OrganInfo[g][gSkinRank][5] = 5;
		OrganInfo[g][gSkin][6] = 412, OrganInfo[g][gSkinPrice][6] = 200000, OrganInfo[g][gSkinRank][6] = 8;
		OrganInfo[g][gSkin][7] = 413, OrganInfo[g][gSkinPrice][7] = 100000, OrganInfo[g][gSkinRank][7] = 5;
		OrganInfo[g][gSkin][8] = 418, OrganInfo[g][gSkinPrice][8] = 150000, OrganInfo[g][gSkinRank][8] = 7;
		SaveSkinOrganization(g);
		OrgLog(g, "rskin", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[playerid][pPlaIP], 0, "", "", 0, "Сбросил Скины");
	}
	return 1;
}
