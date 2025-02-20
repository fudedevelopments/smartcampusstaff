import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampusstaff/components/statuscard.dart';
import 'package:smartcampusstaff/utils/apicall.dart';
import 'package:smartcampusstaff/utils/authservices.dart';

class OndutyUI extends StatelessWidget {
  final OndutyController controller = Get.put(OndutyController());
  final ScrollController _scrollController = ScrollController();
  final AuthService authService = AuthService();
  final RxString selectedCategory = 'Proctor'.obs;

  OndutyUI({super.key}) {
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !controller.isFetchingMore.value) {
        controller.fetchData(
          tablename: "onDutyModel-2jskpek75veajd4yfnqjmkppmu-NONE",
          indexname: _getIndexName(selectedCategory.value),
          token: authService.idToken!,
          limit: 5,
          partitionKey: _getPartitionKey(selectedCategory.value),
          partitionKeyValue: authService.sub!,
          isPagination: true,
        );
      }
    });
  }

  Future<void> reload() async {
    String indexName = _getIndexName(selectedCategory.value);
    await controller.fetchData(
      tablename: "onDutyModel-2jskpek75veajd4yfnqjmkppmu-NONE",
      indexname: indexName,
      token: authService.idToken!,
      limit: 5,
      partitionKey: _getPartitionKey(selectedCategory.value),
      partitionKeyValue: authService.sub!,
    );
  }

  @override
  Widget build(BuildContext context) {
    reload(); // Fetch initial data

    return Scaffold(
      appBar: AppBar(
        title: const Text("On Duty List"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton("Proctor"),
                _buildCategoryButton("Academic Coordinator"),
                _buildCategoryButton("HOD"),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: controller.onDutyList.length +
                    (controller.isFetchingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.onDutyList.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final onDuty = controller.onDutyList[index];
                  return StatusCard(
                    index: selectedCategory.string,
                    onDutyModel: onDuty,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Obx(() => ElevatedButton(
          onPressed: () {
            selectedCategory.value = category;
            reload(); // Call reload when category changes
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedCategory.value == category ? Colors.blue : Colors.grey,
          ),
          child: Text(category),
        ));
  }

  String _getIndexName(String category) {
    switch (category) {
      case 'Academic Coordinator':
        return 'onDutyModelsByAcAndCreatedAt';
      case 'HOD':
        return 'onDutyModelsByHodAndCreatedAt';
      default:
        return 'onDutyModelsByProctorAndCreatedAt';
    }
  }

  String _getPartitionKey(String category) {
    switch (category) {
      case 'Academic Coordinator':
        return 'Ac';
      case 'HOD':
        return 'Hod';
      default:
        return 'Proctor';
    }
  }
}
