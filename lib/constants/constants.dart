class AppConstants {
  // static final String dhisInstance = 'https://idsr.dhis2.udsm.ac.tz';
  // static final String dhisInstance = 'https://dhis.moh.go.tz/mainupgrade';
  static final String dhisInstance = 'https://idsr.dhis2.udsm.ac.tz';
  static final String immediateProgramUid = 'bWW1WxiP9lY';

  static final String malariaRegisrtyProgramUid = 'ib6PYHQ5Aa8';
  static final String weeklyDatasetUid = 'NDcgQeGaJC9';

  // static final immediateCaseListingParams = {'caseid': 'CxSxifEaRzd'};
  static final List<dynamic> immediateCaseListingParams = [
    {'id': 'CxSxifEaRzd', 'label': 'Case ID'},
    {'id': 'odR6HcTNgEW', 'label': 'Sex'},
    {'id': 'DWD892cNO8q', 'label': 'Disease'},
    {'id': 'b4xVFUUgMP2', 'label': 'Definition'}
  ];

  static final dynamic trackerSummaryListConfigs = {
    "ib6PYHQ5Aa8": [
      {'id': 'ZLPxZTo1sYt', 'label': 'Case ID'},
      {'id': 'jHVKTwTHWMK', 'label': 'First Name'},
      {'id': 'TJ7RITYo5IT', 'label': 'Last Nme'}
    ]
  };

  static final dynamic eventSummaryListConfigs = {
    "PXsALJ60dF3": [
      {"id": "SgclPhIHo7d", "label": "Sex"},
      {"id": "orgUnit", "label": "Facility"},
      {"id": "CMJKuLcTdxK", "label": "Test results"},
      {"id": "re1kmrVDl51", "label": "First name"},
      {"id": "NPUz9Eb9vZH", "label": "Last name"}
    ],
    "ZjGk4Xvo5r9": [
      {"id": "FXFcNI1Oyb0", "label": "Case ID"},
      {"id": "S3RrTASG8OK", "label": "First Name"},
      {"id": "ngvSfG8EXrx", "label": "Last Name"},
      {"id": "uHUGHCcKAQB", "label": "Test Result"},
    ]
  };

  static final List<dynamic> mcbsCaseListingParams = [
    {'id': 'jHVKTwTHWMK', "label": "First name"}
  ];
  static final List<dynamic> surveillanceSelectionArray = [
    {
      'header': 'Indicator Based Surveillance',
      'description':
          'Report immediate and weekly basis on selected notifiable diseases in health facilities',
      'icon': 'icon_plus.png',
      'routePath': 'ibslogin'
    },
    {
      'header': 'Event Based Surveillance',
      'description':
          'Detect, Identify and report alerts occuring in the community',
      'icon': 'icon_notification.png',
      'routePath': 'ebslogin'
    },
    {
      'header': 'Malaria Case Based Surveillance',
      'description':
          'Detect, Identify and report alerts occuring in the community',
      'icon': 'icon_notification.png',
      'routePath': 'mcbslogin'
    }
  ];

  static final dynamic formSections = {
    "PXsALJ60dF3": [
      {
        "name": "General Information",
        "id": "PQ2iNx2jfWD",
        "dataElements": [
          {"name": "Re-ACD Head of Household", "id": "NskGskYkIri"},
          {"name": "ACD Number of household members", "id": "Pdk3quWyeiC"}
        ]
      },
      {
        "name": "Contact Identification",
        "id": "ILTpPDf3Azh",
        "dataElements": [
          {"name": "Pro-ACD Case ID", "id": "XcGSRpO2OtK"},
          {"name": "Pro-ACD First name", "id": "re1kmrVDl51"},
          {"name": "Pro-ACD Middle name", "id": "af7SWfvqMSU"},
          {"name": "Pro-ACD Last name", "id": "NPUz9Eb9vZH"},
          {"name": "Pro-ACD Age", "id": "y2wfbpQOtR4"},
          {"name": "Pro-ACD Sex", "id": "SgclPhIHo7d"},
          {"name": "Pro-Occupation", "id": "dQHQYytEd9R"}
        ]
      },
      {
        "name": "Test",
        "id": "JT6kyfEEFjC",
        "dataElements": [
          {"name": "Pro-ACD Tested", "id": "EazXN7S0JEn"},
          {"name": "Pro-ACD Test Result", "id": "CMJKuLcTdxK"}
        ]
      },
      {
        "name": "History of illness",
        "id": "OqshNsiJAxx",
        "dataElements": [
          {
            "name": "Pro-ACD Fever or History of fever in the past 3 days",
            "id": "lwgOTxU6wOg"
          }
        ]
      },
      {
        "name": "Recent history of travel (<1 month)",
        "id": "rqWCfigPfBF",
        "dataElements": [
          {"name": "Pro-ACD Travel in the past 4 weeks", "id": "Mn198hpLKTq"},
          {"name": "Pro-ACD Place of travel", "id": "hkWCaATba6r"},
          {"name": "Pro-ACD Date of Travel", "id": "EgEpbmMxbop"},
          {"name": "Pro-ACD Date of Return", "id": "HDj1cSscCtr"}
        ]
      },
      {
        "name": "Case classification",
        "id": "KO23nNbG3EJ",
        "dataElements": [
          {"name": "Pro-ACD Case classification", "id": "QLsqy5mBCpP"},
          {
            "name":
                "Pro-If local, current foci classification, follow provided job aids",
            "id": "fgOR3Ojh5eE"
          },
          {
            "name":
                "Pro-Any known malaria /Fever Case within the same household/neighborhood in the past 28 days",
            "id": "JkYvhawrsRQ"
          },
          {"name": "Pro-Local case classification", "id": "yQt0OQ5NcJ3"}
        ]
      }
    ],
    "ZjGk4Xvo5r9": [
      {
        "name": "General Information",
        "id": "MVFV9Ai0BrG",
        "dataElements": [
          {"name": "Re-ACD Head of Household", "id": "NskGskYkIri"},
          {"name": "ACD Number of household members", "id": "Pdk3quWyeiC"}
        ]
      },
      {
        "name": "Contact Identification",
        "id": "eOTsQ4OPfDb",
        "dataElements": [
          {"name": "Re-ACD Case ID", "id": "FXFcNI1Oyb0"},
          {"name": "Re-ACD First name", "id": "S3RrTASG8OK"},
          {"name": "Re-ACD Middle name", "id": "z7dn4vXNPBS"},
          {"name": "Re-ACD Last name", "id": "ngvSfG8EXrx"},
          {"name": "Re-ACD Age", "id": "d1mXAqnn775"},
          {"name": "Re-ACD Sex", "id": "ynTZOe2zzPD"},
          {"name": "Re-Occupation", "id": "RXhlMxMPEFI"},
          {"name": "Re-Relation with index case", "id": "rt8o34GLnwn"}
        ]
      },
      {
        "name": "Test",
        "id": "wap32efasZw",
        "dataElements": [
          {"name": "Re-ACD Tested", "id": "jJd1ieyyrrM"},
          {"name": "Re-ACD Test Result", "id": "uHUGHCcKAQB"},
          {
            "name": "Re-ACD Reasons for not testing and stop recording",
            "id": "KqSLfvcHwnn"
          }
        ]
      },
      {
        "name": "History of Illness",
        "id": "hzt4z06qeMu",
        "dataElements": [
          {
            "name": "Re-ACD Fever or History of fever in the past 3 days",
            "id": "Wd6shffAm5E"
          }
        ]
      },
      {
        "name": "Recent history of travel (<1 month)",
        "id": "ruUP0VbsCHx",
        "dataElements": [
          {"name": "Re-ACD Travel in the past 4 weeks", "id": "m68e2mT1f1Y"},
          {"name": "Re-ACD Place of travel", "id": "Nrmpp5Em3fQ"},
          {"name": "Re-ACD Date of Travel", "id": "VEWB20kDYX3"},
          {"name": "Re-ACD Date of Return", "id": "UZIHjzdqppz"}
        ]
      },
      {
        "name": "Case classification",
        "id": "VbOU1MSOBgS",
        "dataElements": [
          {"name": "Re-ACD Case classification", "id": "ZVV4PtiYh7A"},
          {
            "name":
                "Re-If local, current foci classification, follow provided job aids",
            "id": "GN8P1YHW5mY"
          },
          {
            "name":
                "Re-Any known malaria /Fever Case within the same household/neighborhood in the past 28 days",
            "id": "SFpdcuZMW6W"
          },
          {"name": "Re-Local case classification", "id": "MiIDFmt7MYg"}
        ]
      }
    ]
  };

  static final List<dynamic> immediateCaseFormSection = [
    {
      "id": "general",
      "name": "General Details",
      "description": null,
      "fieldGroups": [
        {
          "isFormHorizontal": true,
          "fields": [
            {"id": "CxSxifEaRzd"}
          ]
        },
        {
          "isFormHorizontal": true,
          "fields": [
            {"id": "HqazINzzsEZ"},
            {"id": "PVF0hs3YxRz"}
          ]
        },
        {
          "fields": [
            {"id": "odR6HcTNgEW"},
            {"id": "vvxPDXvvoAM"}
          ]
        }
      ]
    },
    {
      "id": "disease-info",
      "name": "Disease Information",
      "description": null,
      "fieldGroups": [
        {
          "isFormHorizontal": true,
          "fields": [
            {"id": "DWD892cNO8q"},
            {"id": "b4xVFUUgMP2"}
          ]
        },
        {
          "fields": [
            {"id": "auNpv9QUve4"},
            {"id": "fbIXx7uohES"}
          ]
        }
      ]
    },
    {
      "id": "mortality-info",
      "name": "Mortality",
      "description": null,
      "fieldGroups": [
        {
          "fields": [
            {"id": "oqpyDVwngtS"},
            {"id": "QqoMDbIxOu5"},
            {"id": "jKiuKpzEz8a"}
          ]
        }
      ]
    },
    {
      "id": "lab-specimen",
      "name": "Lab Specimen",
      "description": null,
      "fieldGroups": [
        {
          "fields": [
            {"id": "ae0ReCg7C0G"},
            {"id": "bTqb2dov2Pl"}
          ]
        }
      ]
    },
    {
      "id": "action-taken",
      "name": " Action Taken",
      "fieldGroups": [
        {
          "fields": [
            {"id": "rj1WYTe0280"},
            {"id": "K1rG9A19Ssn"},
            {"id": "hK09K0f7F4N"},
            {"id": "ktm7DdZK6M8"},
            {"id": "uzrHtpkbkl7"},
            {"id": "jKXm6hkYeFo"}
          ]
        }
      ]
    }
  ];

  static final List<dynamic> dataSetDataElements = [
    {
      "name": "IDSR Animal Bites",
      "displayFormName": "IDSR Animal Bites",
      "id": "nrmGMpeTMpK",
      "shortName": "AB",
      "valueType": "INTEGER_ZERO_OR_POSITIVE"
    },
    {
      "name": "Diarrhoea dehydration in child < 5",
      "displayFormName": "Diarrhoea with dehydration in children < 5",
      "id": "kXD4hg575gJ",
      "shortName": "DWDH",
      "valueType": "INTEGER_ZERO_OR_POSITIVE"
    },
    {
      "name": "IDSR Severe Pneumonia <5 Years",
      "id": "qXCZieHvyrA",
      "shortName": "SPU5",
      "valueType": "INTEGER_ZERO_OR_POSITIVE",
      "displayFormName": "IDSR Severe Pneumonia <5 Years"
    },
    {
      "name": "IDSR Typhoid",
      "id": "OOnL47t1Ltg",
      "shortName": "TY",
      "valueType": "INTEGER_ZERO_OR_POSITIVE",
      "displayFormName": "IDSR Typhoid"
    },
    {
      "name": "IDSR Malaria ",
      "id": "mbN5Ha1T6Dx",
      "shortName": "MAL",
      "valueType": "INTEGER_ZERO_OR_POSITIVE",
      "displayFormName": "IDSR Malaria"
    },
    {
      "name": "IDSR Snake bites ",
      "id": "SID0lGYyHSU",
      "shortName": "SB",
      "valueType": "INTEGER_ZERO_OR_POSITIVE",
      "displayFormName": "IDSR Snake bites"
    }
  ];

  static final idsrCategoryCombo = {
    "name": "IDSR (Case Age Sex)",
    "id": "sbY37PWvJBp",
    "categoryOptionCombos": [
      {"name": "Case, < 5, ME", "id": "AttDwO4xCIu"},
      {"name": "Case, < 5, KE", "id": "QInmZugn9JO"},
      {"name": "Case, > 5, ME", "id": "FRzeEpefSK8"},
      {"name": "Case, > 5, KE", "id": "q3GdT7f6iw9"},
      {"name": "Death, < 5, ME", "id": "LZsl9VW71qr"},
      {"name": "Death, < 5, KE", "id": "ifRTBcyGzHU"},
      {"name": "Death, > 5, ME", "id": "lW9u3eKdMXH"},
      {"name": "Death, > 5, KE", "id": "Q8U3fXSfxY8"}
    ]
  };

  static final List<dynamic> weeklyFormSection = [
    {
      "id": "reportid",
      "name": "Report ID",
      "dataElement": "EyyNpp4BQtT",
      "description": null,
      "fieldGroups": [
        {
          "category": "ReportID",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "uGIJ6IdkP7Q",
                  "displayName": "Report ID"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "id": "animalbites",
      "name": "Animal Bites",
      "dataElement": "nrmGMpeTMpK",
      "description": null,
      "fieldGroups": [
        {
          "category": "Cases",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "AttDwO4xCIu",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "QInmZugn9JO",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "FRzeEpefSK8",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "q3GdT7f6iw9",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
        {
          "category": "Deaths",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "LZsl9VW71qr",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "ifRTBcyGzHU",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "lW9u3eKdMXH",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "Q8U3fXSfxY8",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
      ]
    },
    {
      "id": "diarrhea",
      "name": "Diarrhea with dehydration in child < 5yrs",
      "dataElement": "kXD4hg575gJ",
      "description": null,
      "fieldGroups": [
        {
          "category": "Cases",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "AttDwO4xCIu",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "QInmZugn9JO",
                  "displayName": "Under 5, Female"
                },
              ]
            }
          ]
        },
        {
          "category": "Deaths",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "LZsl9VW71qr",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "ifRTBcyGzHU",
                  "displayName": "Under 5, Female"
                },
              ]
            }
          ]
        },
      ]
    },
    {
      "id": "pneumonia",
      "name": "Severe Pneumonia < 5yrs",
      "dataElement": "qXCZieHvyrA",
      "description": null,
      "fieldGroups": [
        {
          "category": "Cases",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "AttDwO4xCIu",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "QInmZugn9JO",
                  "displayName": "Under 5, Female"
                },
              ]
            }
          ]
        },
        {
          "category": "Deaths",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "LZsl9VW71qr",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "ifRTBcyGzHU",
                  "displayName": "Under 5, Female"
                },
              ]
            }
          ]
        },
      ]
    },
    {
      "id": "typhoid",
      "name": "Typhoid",
      "dataElement": "OOnL47t1Ltg",
      "description": null,
      "fieldGroups": [
        {
          "category": "Cases",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "AttDwO4xCIu",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "QInmZugn9JO",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "FRzeEpefSK8",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "q3GdT7f6iw9",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
        {
          "category": "Deaths",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "LZsl9VW71qr",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "ifRTBcyGzHU",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "lW9u3eKdMXH",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "Q8U3fXSfxY8",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
      ]
    },
    {
      "id": "malaria",
      "name": "Malaria",
      "dataElement": "mbN5Ha1T6Dx",
      "description": null,
      "fieldGroups": [
        {
          "category": "Cases",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "AttDwO4xCIu",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "QInmZugn9JO",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "FRzeEpefSK8",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "q3GdT7f6iw9",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
        {
          "category": "Deaths",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "LZsl9VW71qr",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "ifRTBcyGzHU",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "lW9u3eKdMXH",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "Q8U3fXSfxY8",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
      ]
    },
    {
      "id": "snakebites",
      "name": "Snake bites",
      "dataElement": "SID0lGYyHSU",
      "description": null,
      "fieldGroups": [
        {
          "category": "Cases",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "AttDwO4xCIu",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "QInmZugn9JO",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "FRzeEpefSK8",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "q3GdT7f6iw9",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
        {
          "category": "Deaths",
          "categoryOptionCombos": [
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "LZsl9VW71qr",
                  "displayName": "Under 5, Male"
                },
                {
                  "categoryOptionCombo": "ifRTBcyGzHU",
                  "displayName": "Under 5, Female"
                },
              ]
            },
            {
              "isFormHorizontal": true,
              "fields": [
                {
                  "categoryOptionCombo": "lW9u3eKdMXH",
                  "displayName": "Above 5, Male"
                },
                {
                  "categoryOptionCombo": "Q8U3fXSfxY8",
                  "displayName": "Above 5, Female"
                },
              ]
            }
          ]
        },
      ]
    }
  ];

  static final List<dynamic> mcbsFormSection = [
    {
      "id": "general",
      "name": "General Details",
      "description": null,
      "fieldGroups": [
        {
          "isFormHorizontal": true,
          "fields": [
            {"id": "ZLPxZTo1sYt"}
          ]
        },
        {
          "isFormHorizontal": true,
          "fields": [
            {"id": "jHVKTwTHWMK"},
            {"id": "yPpv5Mc1jQE"}
          ]
        },
        {
          "fields": [
            {"id": "TJ7RITYo5IT"}
          ]
        },
        {
          "isFormHorizontal": true,
          "fields": [
            {"id": "ZE9SogpKOOx"},
            {"id": "nxgyUaeUWRF"},
          ]
        }
      ]
    },
    {
      "id": "geographical-info",
      "name": "Geographical Information",
      "description": null,
      "fieldGroups": [
        {
          "fields": [
            {"id": "N5569jYbmRt"},
            {"id": "TIX6yBTDIC2"},
            {"id": "MqwEwRCCrnX"}
          ]
        }
      ]
    },
    {
      "id": "disease-info",
      "name": "Disease Information",
      "description": null,
      "fieldGroups": [
        {
          "fields": [
            {"id": "bqcu8y9ymrV"},
            {"id": "Jse6DiRvM63"}
          ]
        }
      ]
    },
    {
      "id": "travel-info",
      "name": "Travel Information",
      "description": null,
      "fieldGroups": [
        {
          "fields": [
            {"id": "fLtLZi9U9sp"},
            {"id": "DZvnwu3pint"},
            {"id": "ac59KOtlVW1"},
            {"id": "IkX30fXj3cb"}
          ]
        }
      ]
    },
    {
      "id": "classification-info",
      "name": "Classification",
      "fieldGroups": [
        {
          "fields": [
            {"id": "TzQcMwBOMKM"},
            {"id": "nXeOcMvi9Os"},
            {"id": "uAnFHvxxITx"},
            {"id": "R3IQKrwOfH0"},
            {"id": "BPswEc7rniS"}
          ]
        }
      ]
    }
  ];
}
