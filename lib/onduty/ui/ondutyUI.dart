import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampusstaff/components/statuscard.dart';
import 'package:smartcampusstaff/utils/apicall.dart';
import 'package:smartcampusstaff/utils/authservices.dart';

// Define a constant for the table name
const String onDutyTableName = "onDutyModel-oxs67o2v2vfefhdk7fljk63uui-NONE";

class OndutyUI extends StatefulWidget {
  const OndutyUI({super.key});

  @override
  State<OndutyUI> createState() => _OndutyUIState();
}

class _OndutyUIState extends State<OndutyUI> {
  final OndutyController controller = Get.put(OndutyController());
  final ScrollController _scrollController = ScrollController();
  final AuthService authService = AuthService();
  final RxString selectedCategory = 'Proctor'.obs;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reload();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !controller.isFetchingMore.value) {
        controller.fetchData(
          tablename: onDutyTableName,
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

  Future<void> reload({bool forceRefresh = false}) async {
    String indexName = _getIndexName(selectedCategory.value);
    String partitionKey = _getPartitionKey(selectedCategory.value);

    if (forceRefresh) {
      await controller.refreshData(
        tablename: onDutyTableName,
        indexname: indexName,
        token: authService.idToken!,
        limit: 5,
        partitionKey: partitionKey,
        partitionKeyValue: authService.sub!,
      );
    } else {
      await controller.fetchData(
        tablename: onDutyTableName,
        indexname: indexName,
        token: authService.idToken!,
        limit: 5,
        partitionKey: partitionKey,
        partitionKeyValue: authService.sub!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed reload() call from here to prevent repeated API calls

    return Scaffold(
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Permission Requests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryButton("Proctor", context),
                        const SizedBox(width: 12),
                        _buildCategoryButton("Academic Coordinator", context),
                        const SizedBox(width: 12),
                        _buildCategoryButton("HOD", context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.onDutyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No permission requests found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => reload(forceRefresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.onDutyList.length +
                        (controller.isFetchingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.onDutyList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final onDuty = controller.onDutyList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: StatusCard(
                          index: selectedCategory.string,
                          onDutyModel: onDuty,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category, BuildContext context) {
    return Obx(() {
      final isSelected = selectedCategory.value == category;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (selectedCategory.value != category) {
              selectedCategory.value = category;
              reload(forceRefresh: false); // Use cached data if available
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    });
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
