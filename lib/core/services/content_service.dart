import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../models/channel_model.dart';

class ContentService {
  static Stream<List<CategoryModel>> watchCategories() {
    return FirebaseFirestore.instance
        .collection('categories')
        .orderBy('order')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => CategoryModel.fromMap(d.id, d.data()))
            .toList());
  }

  static Stream<List<CategoryModel>> watchRootCategories() {
    return watchCategories().map(
      (categories) => categories.where((category) => category.parentId == null).toList(),
    );
  }

  static Stream<List<CategoryModel>> watchChildCategories(String parentId) {
    return watchCategories().map(
      (categories) => categories
          .where((category) => category.parentId == parentId)
          .toList(),
    );
  }

  static Stream<List<ChannelModel>> watchChannelsForCategory(
      String categoryId) {
    return FirebaseFirestore.instance
        .collection('channels')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ChannelModel.fromMap(d.id, d.data()))
            .toList());
  }
}
