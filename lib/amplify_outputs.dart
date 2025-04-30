const amplifyConfig = r'''{
  "auth": {
    "user_pool_id": "ap-south-1_XhZsbIySU",
    "aws_region": "ap-south-1",
    "user_pool_client_id": "4uv9rchl91tkiootnba5isnog1",
    "identity_pool_id": "ap-south-1:f7a0e334-a108-4d23-bdeb-7cefbaab0cb6",
    "mfa_methods": [],
    "standard_required_attributes": [
      "email"
    ],
    "username_attributes": [
      "email"
    ],
    "user_verification_types": [
      "email"
    ],
    "groups": [
      {
        "ADMINS": {
          "precedence": 0
        }
      },
      {
        "STAFF": {
          "precedence": 1
        }
      }
    ],
    "mfa_configuration": "NONE",
    "password_policy": {
      "min_length": 8,
      "require_lowercase": true,
      "require_numbers": true,
      "require_symbols": true,
      "require_uppercase": true
    },
    "unauthenticated_identities_enabled": true
  },
  "data": {
    "url": "https://cdrwzc6hibduxevmfzpwkjbo2u.appsync-api.ap-south-1.amazonaws.com/graphql",
    "aws_region": "ap-south-1",
    "default_authorization_type": "AMAZON_COGNITO_USER_POOLS",
    "authorization_types": [
      "AWS_IAM"
    ],
    "model_introspection": {
      "version": 1,
      "models": {
        "StudentsUserProfile": {
          "name": "StudentsUserProfile",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "name": {
              "name": "name",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "regNo": {
              "name": "regNo",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "email": {
              "name": "email",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "department": {
              "name": "department",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "year": {
              "name": "year",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "Proctor": {
              "name": "Proctor",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "Ac": {
              "name": "Ac",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "Hod": {
              "name": "Hod",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "deviceToken": {
              "name": "deviceToken",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "StudentsUserProfiles",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "fields": [
                  "id"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "provider": "userPools",
                    "ownerField": "owner",
                    "allow": "owner",
                    "identityClaim": "cognito:username",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "operations": [
                      "read"
                    ],
                    "groups": [
                      "STAFF",
                      "ADMINS"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "StaffUserProfile": {
          "name": "StaffUserProfile",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "name": {
              "name": "name",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "email": {
              "name": "email",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "department": {
              "name": "department",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "qualification": {
              "name": "qualification",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "deviceToken": {
              "name": "deviceToken",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "StaffUserProfiles",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "fields": [
                  "id"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "STAFF"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "operations": [
                      "read"
                    ],
                    "groups": [
                      "ADMINS"
                    ]
                  },
                  {
                    "allow": "private",
                    "operations": [
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "onDutyModel": {
          "name": "onDutyModel",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "name": {
              "name": "name",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "regNo": {
              "name": "regNo",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "email": {
              "name": "email",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "department": {
              "name": "department",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "year": {
              "name": "year",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "student": {
              "name": "student",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "Proctor": {
              "name": "Proctor",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "Ac": {
              "name": "Ac",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "Hod": {
              "name": "Hod",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "eventname": {
              "name": "eventname",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "location": {
              "name": "location",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "date": {
              "name": "date",
              "isArray": false,
              "type": "AWSDate",
              "isRequired": true,
              "attributes": []
            },
            "details": {
              "name": "details",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "registeredUrl": {
              "name": "registeredUrl",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "validDocuments": {
              "name": "validDocuments",
              "isArray": true,
              "type": "String",
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": false
            },
            "proctorstatus": {
              "name": "proctorstatus",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "AcStatus": {
              "name": "AcStatus",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "HodStatus": {
              "name": "HodStatus",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSTimestamp",
              "isRequired": true,
              "attributes": []
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "onDutyModels",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "key",
              "properties": {
                "name": "onDutyModelsByStudentAndCreatedAt",
                "queryField": "listOnDutyModelByStudentAndCreatedAt",
                "fields": [
                  "student",
                  "createdAt"
                ]
              }
            },
            {
              "type": "key",
              "properties": {
                "name": "onDutyModelsByProctorAndCreatedAt",
                "queryField": "listOnDutyModelByProctorAndCreatedAt",
                "fields": [
                  "Proctor",
                  "createdAt"
                ]
              }
            },
            {
              "type": "key",
              "properties": {
                "name": "onDutyModelsByAcAndCreatedAt",
                "queryField": "listOnDutyModelByAcAndCreatedAt",
                "fields": [
                  "Ac",
                  "createdAt"
                ]
              }
            },
            {
              "type": "key",
              "properties": {
                "name": "onDutyModelsByHodAndCreatedAt",
                "queryField": "listOnDutyModelByHodAndCreatedAt",
                "fields": [
                  "Hod",
                  "createdAt"
                ]
              }
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "ADMINS",
                      "STAFF"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "EventsModel": {
          "name": "EventsModel",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "eventname": {
              "name": "eventname",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "location": {
              "name": "location",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "date": {
              "name": "date",
              "isArray": false,
              "type": "AWSDate",
              "isRequired": true,
              "attributes": []
            },
            "details": {
              "name": "details",
              "isArray": false,
              "type": "String",
              "isRequired": false,
              "attributes": []
            },
            "registeredUrl": {
              "name": "registeredUrl",
              "isArray": false,
              "type": "String",
              "isRequired": true,
              "attributes": []
            },
            "images": {
              "name": "images",
              "isArray": true,
              "type": "String",
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true
            },
            "expiray": {
              "name": "expiray",
              "isArray": false,
              "type": "AWSTimestamp",
              "isRequired": false,
              "attributes": []
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "EventsModels",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "ADMINS",
                      "STAFF"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        },
        "BannerImages": {
          "name": "BannerImages",
          "fields": {
            "id": {
              "name": "id",
              "isArray": false,
              "type": "ID",
              "isRequired": true,
              "attributes": []
            },
            "images": {
              "name": "images",
              "isArray": true,
              "type": "String",
              "isRequired": false,
              "attributes": [],
              "isArrayNullable": true
            },
            "createdAt": {
              "name": "createdAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            },
            "updatedAt": {
              "name": "updatedAt",
              "isArray": false,
              "type": "AWSDateTime",
              "isRequired": false,
              "attributes": [],
              "isReadOnly": true
            }
          },
          "syncable": true,
          "pluralName": "BannerImages",
          "attributes": [
            {
              "type": "model",
              "properties": {}
            },
            {
              "type": "auth",
              "properties": {
                "rules": [
                  {
                    "allow": "private",
                    "operations": [
                      "read"
                    ]
                  },
                  {
                    "groupClaim": "cognito:groups",
                    "provider": "userPools",
                    "allow": "groups",
                    "groups": [
                      "ADMINS",
                      "STAFF"
                    ],
                    "operations": [
                      "create",
                      "update",
                      "delete",
                      "read"
                    ]
                  }
                ]
              }
            }
          ],
          "primaryKeyInfo": {
            "isCustomPrimaryKey": false,
            "primaryKeyFieldName": "id",
            "sortKeyFieldNames": []
          }
        }
      },
      "enums": {},
      "nonModels": {},
      "queries": {
        "listUsersInGroup": {
          "name": "listUsersInGroup",
          "isArray": false,
          "type": "AWSJSON",
          "isRequired": false,
          "arguments": {
            "groupName": {
              "name": "groupName",
              "isArray": false,
              "type": "String",
              "isRequired": true
            }
          }
        }
      },
      "mutations": {
        "createUser": {
          "name": "createUser",
          "isArray": false,
          "type": "AWSJSON",
          "isRequired": false,
          "arguments": {
            "username": {
              "name": "username",
              "isArray": false,
              "type": "String",
              "isRequired": true
            },
            "email": {
              "name": "email",
              "isArray": false,
              "type": "AWSEmail",
              "isRequired": true
            },
            "password": {
              "name": "password",
              "isArray": false,
              "type": "String",
              "isRequired": true
            }
          }
        }
      }
    }
  },
  "storage": {
    "aws_region": "ap-south-1",
    "bucket_name": "amplify-smartcampus-prave-smartcampuesbucket54db93-9ghoagdpwd0n",
    "buckets": [
      {
        "name": "Smartcampues",
        "bucket_name": "amplify-smartcampus-prave-smartcampuesbucket54db93-9ghoagdpwd0n",
        "aws_region": "ap-south-1",
        "paths": {
          "ondutydocs/*": {
            "groupsADMINS": [
              "get",
              "list",
              "write",
              "delete"
            ],
            "groupsSTAFF": [
              "get",
              "list",
              "write",
              "delete"
            ],
            "authenticated": [
              "get",
              "list",
              "write",
              "delete"
            ]
          },
          "eventimages/*": {
            "groupsADMINS": [
              "get",
              "list",
              "write",
              "delete"
            ],
            "groupsSTAFF": [
              "get",
              "list",
              "write",
              "delete"
            ],
            "authenticated": [
              "get",
              "list",
              "write",
              "delete"
            ]
          },
          "bannerimages/*": {
            "groupsADMINS": [
              "get",
              "list",
              "write",
              "delete"
            ],
            "groupsSTAFF": [
              "get",
              "list",
              "write",
              "delete"
            ],
            "authenticated": [
              "get",
              "list",
              "write",
              "delete"
            ]
          }
        }
      }
    ]
  },
  "version": "1.3",
  "custom": {
    "API": {
      "NecHttp": {
        "endpoint": "https://c3n6lbtgl0.execute-api.ap-south-1.amazonaws.com/",
        "region": "ap-south-1",
        "apiName": "NecHttp"
      }
    }
  }
}''';