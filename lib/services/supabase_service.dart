import 'dart:io';

import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/profile_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // ================= CATEGORY =================
  Future<List<Category>> getCategories() async {
    final data = await supabase
        .from('category_tb')
        .select()
        .order('name', ascending: true);

    return (data as List).map((e) => Category.fromJson(e)).toList();
  }

  // ================= TRANSACTION =================
  Future<List<Transaction>> getTransactions() async {
    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('transactions_tb')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List).map((e) => Transaction.fromJson(e)).toList();
  }

  Future insertTransaction(Transaction transaction) async {
    // มั่นใจได้เลยว่าใน transaction.toJson() มี user_id มาแล้วจากหน้า UI
    await supabase.from('transactions_tb').insert(transaction.toJson());
  }

  Future updateTransaction(String id, Transaction transaction) async {
    await supabase
        .from('transactions_tb')
        .update(transaction.toJson())
        .eq('id', id);
  }

  Future deleteTransaction(String id) async {
    await supabase.from('transactions_tb').delete().eq('id', id);
  }

  // ================= PROFILE =================
  Future<Profile?> getMyProfile() async {
    final userId = supabase.auth.currentUser!.id;

    final data = await supabase
        .from('profile_tb')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;

    return Profile.fromJson(data);
  }

  Future updateProfile(String id, Profile profile) async {
    await supabase.from('profile_tb').update(profile.toJson()).eq('id', id);
  }

  // ================= STORAGE =================
  Future<String?> uploadFile(File file, String folder) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    final path = '$folder/$fileName';

    await supabase.storage
        .from('images_bk')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    return supabase.storage.from('images_bk').getPublicUrl(path);
  }

  Future deleteFile(String fileUrl) async {
    final fileName = fileUrl.split('/').last;

    await supabase.storage.from('images_bk').remove([fileName]);
  }
}
