// ไฟล์นี้ใช้สำหรับสร้างการทำงานต่างๆ กับ Supabase

// CRUD กับ Table->Database (PostgreSQL)->Supabase
// upload/delete file กับ Bucket->Storage->Supabase

import 'dart:io';

import 'package:flutter_wealth_curator_app/models/category_model.dart';
import 'package:flutter_wealth_curator_app/models/profile_model.dart';
import 'package:flutter_wealth_curator_app/models/transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // สร้าง instance/object/ตัวแทน ของ Supabase เพื่อใช้งาน
  final supabase = Supabase.instance.client;

  // สร้างคำสั่ง/เมธอดการทำงานต่างๆ กับ Supabase
  //------------------------------------------------------------------------------
  // เมธอดดึงข้อมูลงานทั้งหมดจาก category_tb และ return ค่าข้อมูลที่ได้จากการดึงไปใช้
  Future<List<Category>> getCategories() async {
    try {
      final data = await supabase.from('category_tb').select();

      return (data as List).map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Transaction>> getTransactions() async {
    try {
      final data = await supabase.from('transaction_tb').select();

      return (data as List).map((e) => Transaction.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions');
    }
  }

  Future<Profile?> getMyProfile() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final data = await supabase
          .from('profile_tb')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) return null;

      return Profile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load profile');
    }
  }

  //------------------------------------------------------------------------------
  // เมธอดอัปโหลดไฟล์ไปยัง avatar_tb และ return ค่าข้อมูลที่อยู่รูปที่ได้จากการอัปโหลดไปใช้งาน
  Future<String?> uploadFile(File file, String folder) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    final path = '$folder/$fileName';

    await supabase.storage.from('images_bk').upload(path, file);

    return supabase.storage.from('images_bk').getPublicUrl(path);
  }

  //------------------------------------------------------------------------------
  // เมธอดเพิ่มข้อมูลไปยัง category_tb
  Future insertCategory(Category category) async {
    //เพิ่มข้อมูลไปยัง category_tb
    await supabase.from('category_tb').insert(category.toJson());
  }

  Future insertTransaction(Transaction transaction) async {
    //เพิ่มข้อมูลไปยัง transaction_tb
    await supabase.from('transaction_tb').insert(transaction.toJson());
  }

  Future insertProfile(Profile profile) async {
    //เพิ่มข้อมูลไปยัง profile_tb
    await supabase.from('profile_tb').insert(profile.toJson());
  }

  //------------------------------------------------------------------------------
  // เมธอดลบไฟล์ที่อัปโหลดไปยัง category_tb
  Future deleteFile(String filename) async {
    // ลบไฟล์ที่อัปโหลดไปยัง category_tb
    // ก่อนลบให้ตัดเลือกแค่ชื่อไฟล์ ไม่เอาที่อยู่ไฟล์
    filename = filename.split('/').last;
    await supabase.storage.from('category_tb').remove([filename]);
  }

  //------------------------------------------------------------------------------
  // เมธอดแก้ไขข้อมูลใน category_tb
  Future updateCategory(String id, Category category) async {
    // แก้ไขข้อมูลไปยัง category_tb
    await supabase.from('category_tb').update(category.toJson()).eq('id', id);
  }

  //------------------------------------------------------------------------------
  // เมธอดลบข้อมูลจาก category_tb
  Future deleteCategory(String id) async {
    // ลบข้อมูลจาก category_tb
    await supabase.from('category_tb').delete().eq('id', id);
  }
}
