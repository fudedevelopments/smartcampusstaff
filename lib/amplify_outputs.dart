const amplifyConfig = r'''{
  "auth": {
    "user_pool_id": "ap-south-1_UDuao2UIB",
    "aws_region": "ap-south-1",
    "user_pool_client_id": "12eed29hg2kltd5q12oqedgdc",
    "identity_pool_id": "ap-south-1:31201f5d-2912-4cae-a772-e48c5e4b418e",
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
    "url": "https://dp6g5lcr4ve63acalk5pt224ze.appsync-api.ap-south-1.amazonaws.com/graphql",
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
              "type": {
                "enum": "Status"
              },
              "isRequired": true,
              "attributes": []
            },
            "AcStatus": {
              "name": "AcStatus",
              "isArray": false,
              "type": {
                "enum": "Status"
              },
              "isRequired": true,
              "attributes": []
            },
            "HodStatus": {
              "name": "HodStatus",
              "isArray": false,
              "type": {
                "enum": "Status"
              },
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
          "pluralName": "onDutyModels",
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
              "type": "key",
              "properties": {
                "name": "onDutyModelsByProctor",
                "queryField": "listOnDutyModelByProctor",
                "fields": [
                  "Proctor"
                ]
              }
            },
            {
              "type": "key",
              "properties": {
                "name": "onDutyModelsByAc",
                "queryField": "listOnDutyModelByAc",
                "fields": [
                  "Ac"
                ]
              }
            },
            {
              "type": "key",
              "properties": {
                "name": "onDutyModelsByHod",
                "queryField": "listOnDutyModelByHod",
                "fields": [
                  "Hod"
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
                    "provider": "userPools",
                    "ownerField": "Proctor",
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
                    "provider": "userPools",
                    "ownerField": "Ac",
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
                    "provider": "userPools",
                    "ownerField": "Hod",
                    "allow": "owner",
                    "identityClaim": "cognito:username",
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
      "enums": {
        "Status": {
          "name": "Status",
          "values": [
            "PENDING",
            "REJECTED",
            "APPROVED"
          ]
        }
      },
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
    "bucket_name": "amplify-smartcampus-prave-smartcampuesbucket54db93-wwdmpe8ssthx",
    "buckets": [
      {
        "name": "Smartcampues",
        "bucket_name": "amplify-smartcampus-prave-smartcampuesbucket54db93-wwdmpe8ssthx",
        "aws_region": "ap-south-1",
        "paths": {
          "ondutydocs/*": {
            "authenticated": [
              "get",
              "list",
              "write",
              "delete"
            ]
          },
          "eventimages/*": {
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
  "version": "1.3"
}''';