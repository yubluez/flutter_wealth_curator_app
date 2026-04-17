import 'dart:io';

import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:flutter_wealth_curator_app/services/supabase_service.dart';

class AddTransactionController {
  final SupabaseService service;

  AddTransactionController(this.service);

  Future<String?> uploadImage(File? file) async {
    if (file == null) return null;
    return await service.uploadFile(file, 'images_bk');
  }

  Future<void> saveTransaction(Transaction transaction) async {
    await service.insertTransaction(transaction);
  }
}