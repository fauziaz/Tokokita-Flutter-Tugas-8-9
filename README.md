# Tokokita Flutter - Tugas 8 Pertemuan 10

Nama: Fauzia Azahra Depriani  
NIM: H1D023117  
Shift Lama: D  
Shift Baru: F  

---

## ⚙️ Penjelasan Kode

1. **`main.dart`**
   - Kode ini merupakan awal aplikasi Flutter. `MyApp` menggunakan `MaterialApp` untuk mengatur konfigurasi aplikasi dan menetapkan halaman awal.

   ```dart
   import 'package:flutter/material.dart';
   import 'package:tokokita/ui/login_page.dart';
   import 'package:tokokita/ui/produk_page.dart';
   import 'package:tokokita/ui/registrasi_page.dart';

   void main() {
     runApp(const MyApp());
   }

   class MyApp extends StatelessWidget {
     const MyApp({Key? key}) : super(key: key);

     @override
     Widget build(BuildContext context) {
       return const MaterialApp(
         title: 'Toko Kita Fauzia',
         debugShowCheckedModeBanner: false,
         home: ProdukPage(),
       );
     }
   }
   ```

---

2. **Registrasi Page (`registrasi_page.dart`)**
   - Halaman ini digunakan untuk membuat akun baru
   - State dan Controller digunakan untuk validasi dan membaca input user:
     ```dart
      final _formKey = GlobalKey<FormState>();
      final _namaTextboxController = TextEditingController();
      final _emailTextboxController = TextEditingController();
      final _passwordTextboxController = TextEditingController();
     ```
   - Validasi input
     - Nama minimal 3 karakter dan tidak boleh kosong
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Nama harus diisi";
          }
          if (value.length < 3) {
            return "Nama harus diisi minimal 3 karakter";
          }
          return null;
        }
       ```
     - Email tidak boleh kosong dan harus sesuai format (dicek melalui regex)
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email harus diisi";
          }
        
          String pattern = r'^[^@]+@[^@]+\.[^@]+';
          RegExp regex = RegExp(pattern);
        
          if (!regex.hasMatch(value)) {
            return "Format email tidak valid";
          }
          return null;
        }
       ```
     - Password minimal 6 karakter dan tidak boleh kosong
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password harus diisi";
          }
          if (value.length < 6) {
            return "Password minimal 6 karakter";
          }
          return null;
        }
       ```
     - Konfirmasi Password tidak boleh kosong dan harus sama dengan yang dituliskan di password
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Konfirmasi password harus diisi";
          }
          if (value != _passwordTextboxController.text) {
            return "Konfirmasi password tidak sama";
          }
          return null;
        }
       ```
<p align="center">
  <img src="https://github.com/user-attachments/assets/4bcca1d5-2a69-486c-81c5-51b169a17094" width="360"/>
</p>

---

3. **Login Page (`login_page.dart`)**
   - Halaman ini digunakan untuk login ke dalam aplikasi
   - State dan Controller digunakan untuk validasi dan membaca input user:
     ```dart
      final _formKey = GlobalKey<FormState>();
      final _emailTextboxController = TextEditingController();
      final _passwordTextboxController = TextEditingController();
     ```
   - Validasi input
     - Email tidak boleh kosong dan harus sesuai format (dicek melalui regex)
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Email harus diisi";
          }
        
          String pattern = r'^[^@]+@[^@]+\.[^@]+';
          RegExp regex = RegExp(pattern);
        
          if (!regex.hasMatch(value)) {
            return "Format email tidak valid";
          }
          return null;
        }
       ```
     - Password minimal 6 karakter dan tidak boleh kosong
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password harus diisi";
          }
          if (value.length < 6) {
            return "Password minimal 6 karakter";
          }
          return null;
        }
       ```
     - Navigasi ke Registrasi jika pengguna belum memiliki akun
       ```dart
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegistrasiPage()),
            );
          },
          child: const Text("Daftar di sini"),
        )
       ```
<p align="center">
  <img src="https://github.com/user-attachments/assets/0f841d8f-9226-464b-9ce3-4e1494d5ddee" width="360"/>
</p>

---

4. **Produk Page (`produk_page.dart`)**
   - Halaman untuk menampilkan daftar produk
   - AppBar dan Tombol Tambah Produk:
     ```dart
      actions: [
        GestureDetector(
          child: const Icon(Icons.add),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProdukForm()),
          ),
        ),
      ]
     ```
   - Drawer
     Menu untuk logout dan navigasi lain
     ```dart
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
            )
          ],
        ),
      )
     ```
   - ItemProduk
     Widget card untuk setiap produk
     ```dart
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
        ),
        child: Card(
          child: ListTile(
            title: Text(produk.namaProduk!),
            subtitle: Text(produk.hargaProduk.toString()),
          ),
        ),
      )
     ```       
<p align="center">
  <img src="https://github.com/user-attachments/assets/a4185b04-03e5-4a42-acee-e2747e176efe" width="360"/>
</p>

---

5. **Produk Form (`produk_form.dart`)**
   - Digunakan untuk menambah atau mengedit produk
   - Jika menerima widget.produk, berarti halaman dalam mode edit:
     ```dart
      if (widget.produk != null) {
        // mode edit
      } else {
        // mode tambah
      }
     ```
   - Validasi input
     - Kode Produk harus diisi
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Kode produk harus diisi";
          }
          return null;
        }
       ```
     - Nama Produk harus diisi
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Nama produk harus diisi";
          }
          return null;
        }
       ```
     - Harga Produk tidak boleh kosong dan harus berupa angka
       ```dart
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Harga harus diisi";
          }
          if (int.tryParse(value) == null) {
            return "Harga harus berupa angka";
          }
          return null;
        }
       ```
   - Button Simpan/Ubah
     ```dart
      OutlinedButton(
        child: Text(tombolSubmit),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // proses simpan atau ubah
          }
        },
      )
     ```
<p align="center">
  <img src="https://github.com/user-attachments/assets/0b97785b-ba97-4769-bfe7-b17af00a31c9" width="360" style="display:inline-block; margin-right:10px;" />
  <img src="https://github.com/user-attachments/assets/f80e2594-de2c-4748-a58e-e1dae48cb408" width="360" style="display:inline-block;" />
</p>

     
---

   
6.  **Produk Detail (`produk_detail.dart`)**
     - Menampilkan informasi lengkap produk dengan button edit dan delete
     - Detail Produk
       ```dart
        Text("Kode : ${produk.kodeProduk}")
        Text("Nama : ${produk.namaProduk}")
        Text("Harga : Rp ${produk.hargaProduk}")
       ```
     - Button Edit
       ```dart
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProdukForm(produk: widget.produk)),
            );
          },
        )
       ```
     - Button Delete
       ```dart
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        )
       ```
     - Popup Konfirmasi Hapus
       ```dart
        AlertDialog(
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            OutlinedButton(
              child: const Text("Ya"),
              onPressed: () {
                ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!))
              },
            ),
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
       ```
<p align="center">
  <img src="https://github.com/user-attachments/assets/9ff47c95-5b83-4cf7-ae53-e68228c358e4" width="360"/>
</p>
       
