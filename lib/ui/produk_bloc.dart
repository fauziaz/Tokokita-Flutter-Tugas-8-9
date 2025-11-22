import 'dart:async';

class ProdukBloc {
  // Fungsi DELETE 
  static Future<bool> deleteProduk({required int id}) async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi proses
    print("Produk dengan ID $id dihapus (dummy)");
    return true;
  }
}