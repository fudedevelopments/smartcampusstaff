/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the StudentsUserProfile type in your schema. */
class StudentsUserProfile extends amplify_core.Model {
  static const classType = const _StudentsUserProfileModelType();
  final String id;
  final String? _name;
  final String? _regNo;
  final String? _email;
  final String? _department;
  final String? _year;
  final String? _Proctor;
  final String? _Ac;
  final String? _Hod;
  final String? _deviceToken;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  StudentsUserProfileModelIdentifier get modelIdentifier {
      return StudentsUserProfileModelIdentifier(
        id: id
      );
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get regNo {
    try {
      return _regNo!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get department {
    try {
      return _department!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get year {
    try {
      return _year!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get Proctor {
    try {
      return _Proctor!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get Ac {
    try {
      return _Ac!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get Hod {
    try {
      return _Hod!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get deviceToken {
    try {
      return _deviceToken!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const StudentsUserProfile._internal({required this.id, required name, required regNo, required email, required department, required year, required Proctor, required Ac, required Hod, required deviceToken, createdAt, updatedAt}): _name = name, _regNo = regNo, _email = email, _department = department, _year = year, _Proctor = Proctor, _Ac = Ac, _Hod = Hod, _deviceToken = deviceToken, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory StudentsUserProfile({String? id, required String name, required String regNo, required String email, required String department, required String year, required String Proctor, required String Ac, required String Hod, required String deviceToken}) {
    return StudentsUserProfile._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      regNo: regNo,
      email: email,
      department: department,
      year: year,
      Proctor: Proctor,
      Ac: Ac,
      Hod: Hod,
      deviceToken: deviceToken);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StudentsUserProfile &&
      id == other.id &&
      _name == other._name &&
      _regNo == other._regNo &&
      _email == other._email &&
      _department == other._department &&
      _year == other._year &&
      _Proctor == other._Proctor &&
      _Ac == other._Ac &&
      _Hod == other._Hod &&
      _deviceToken == other._deviceToken;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("StudentsUserProfile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("regNo=" + "$_regNo" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("department=" + "$_department" + ", ");
    buffer.write("year=" + "$_year" + ", ");
    buffer.write("Proctor=" + "$_Proctor" + ", ");
    buffer.write("Ac=" + "$_Ac" + ", ");
    buffer.write("Hod=" + "$_Hod" + ", ");
    buffer.write("deviceToken=" + "$_deviceToken" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  StudentsUserProfile copyWith({String? name, String? regNo, String? email, String? department, String? year, String? Proctor, String? Ac, String? Hod, String? deviceToken}) {
    return StudentsUserProfile._internal(
      id: id,
      name: name ?? this.name,
      regNo: regNo ?? this.regNo,
      email: email ?? this.email,
      department: department ?? this.department,
      year: year ?? this.year,
      Proctor: Proctor ?? this.Proctor,
      Ac: Ac ?? this.Ac,
      Hod: Hod ?? this.Hod,
      deviceToken: deviceToken ?? this.deviceToken);
  }
  
  StudentsUserProfile copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? regNo,
    ModelFieldValue<String>? email,
    ModelFieldValue<String>? department,
    ModelFieldValue<String>? year,
    ModelFieldValue<String>? Proctor,
    ModelFieldValue<String>? Ac,
    ModelFieldValue<String>? Hod,
    ModelFieldValue<String>? deviceToken
  }) {
    return StudentsUserProfile._internal(
      id: id,
      name: name == null ? this.name : name.value,
      regNo: regNo == null ? this.regNo : regNo.value,
      email: email == null ? this.email : email.value,
      department: department == null ? this.department : department.value,
      year: year == null ? this.year : year.value,
      Proctor: Proctor == null ? this.Proctor : Proctor.value,
      Ac: Ac == null ? this.Ac : Ac.value,
      Hod: Hod == null ? this.Hod : Hod.value,
      deviceToken: deviceToken == null ? this.deviceToken : deviceToken.value
    );
  }
  
  StudentsUserProfile.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _regNo = json['regNo'],
      _email = json['email'],
      _department = json['department'],
      _year = json['year'],
      _Proctor = json['Proctor'],
      _Ac = json['Ac'],
      _Hod = json['Hod'],
      _deviceToken = json['deviceToken'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'regNo': _regNo, 'email': _email, 'department': _department, 'year': _year, 'Proctor': _Proctor, 'Ac': _Ac, 'Hod': _Hod, 'deviceToken': _deviceToken, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'regNo': _regNo,
    'email': _email,
    'department': _department,
    'year': _year,
    'Proctor': _Proctor,
    'Ac': _Ac,
    'Hod': _Hod,
    'deviceToken': _deviceToken,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<StudentsUserProfileModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<StudentsUserProfileModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final REGNO = amplify_core.QueryField(fieldName: "regNo");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final DEPARTMENT = amplify_core.QueryField(fieldName: "department");
  static final YEAR = amplify_core.QueryField(fieldName: "year");
  static final PROCTOR = amplify_core.QueryField(fieldName: "Proctor");
  static final AC = amplify_core.QueryField(fieldName: "Ac");
  static final HOD = amplify_core.QueryField(fieldName: "Hod");
  static final DEVICETOKEN = amplify_core.QueryField(fieldName: "deviceToken");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "StudentsUserProfile";
    modelSchemaDefinition.pluralName = "StudentsUserProfiles";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["id"], name: null)
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.REGNO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.DEPARTMENT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.YEAR,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.PROCTOR,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.AC,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.HOD,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentsUserProfile.DEVICETOKEN,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _StudentsUserProfileModelType extends amplify_core.ModelType<StudentsUserProfile> {
  const _StudentsUserProfileModelType();
  
  @override
  StudentsUserProfile fromJson(Map<String, dynamic> jsonData) {
    return StudentsUserProfile.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'StudentsUserProfile';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [StudentsUserProfile] in your schema.
 */
class StudentsUserProfileModelIdentifier implements amplify_core.ModelIdentifier<StudentsUserProfile> {
  final String id;

  /** Create an instance of StudentsUserProfileModelIdentifier using [id] the primary key. */
  const StudentsUserProfileModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'StudentsUserProfileModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is StudentsUserProfileModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}