import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:smartcampusstaff/models/onDutyModel.dart';


class Ondutyrepo {
  Future<GraphQLResponse> ondutyCreate({required onDutyModel onduty}) async {
    try {
      final ondutyrequest = ModelMutations.create(onduty);
      final response =
          await Amplify.API.mutate(request: ondutyrequest).response;
      safePrint(response);
      return response;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
