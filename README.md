# Tokokita Flutter - Tugas 8 Pertemuan 10 & Tugas 9 Pertemuan 11

Nama: Fauzia Azahra Depriani  
NIM: H1D023117  
Shift Lama: D  
Shift Baru: F  

---

## ⚙️ Penjelasan Kode

1. **`main.dart`**
   - Kode ini merupakan awal aplikasi Flutter. `MyApp` menggunakan `MaterialApp` untuk mengatur konfigurasi aplikasi dan menetapkan halaman awal. User akan diarahkan ke halaman login, tetapi kalau belum memiliki akun, user dapat mengeklik button register.

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
         home: LoginPage(),
       );
     }
   }
   ```

---

2. Proses registrasi di **Registrasi Page (`registrasi_page.dart`)**
   <p align="center">
     <img src="" width="360" style="display:inline-block; margin-right:10px;" />
     <img src="" width="360" style="display:inline-block;" />
   </p>

   - State dan Controller digunakan untuk validasi dan membaca input user:
     ```dart
      final _formKey = GlobalKey<FormState>();
      final _namaTextboxController = TextEditingController();
      final _emailTextboxController = TextEditingController();
      final _passwordTextboxController = TextEditingController();
     ```
   - User mengisi form registrasi dan akan divalidasi menggunakan aturan ini:
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
     - Konfirmasi Password tidak boleh kosong dan harus sama dengan password
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
   - User menekan button registrasi. Fungsi `_submit()` akan mengirim data ke API
       ```dart
      void _submit() {
        _formKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
      
        RegistrasiBloc.registrasi(
          nama: _namaTextboxController.text,
          email: _emailTextboxController.text,
          password: _passwordTextboxController.text,
        ).then(
          (value) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                },
              ),
            );
          },
          onError: (error) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
              ),
            );
          },
        ).whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
      }
       ```     
     - Set loading state menandakan bahwa request sedang berjalan
       ```dart
         setState(() {
           _isLoading = true;
         });
       ```
     - Memanggil API melalui Bloc
       ```dart
         RegistrasiBloc.registrasi(
           nama: _namaTextboxController.text,
           email: _emailTextboxController.text,
           password: _passwordTextboxController.text,
         )
       ```
     - Jika registrasi berhasil, maka akan menampilkan Success Dialog
       ```dart
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (BuildContext context) => SuccessDialog(
             description: "Registrasi berhasil, silahkan login",
             okClick: () {
               Navigator.pop(context);
             },
           ),
         );
       ```
       Saat user mengeklik "ok", akan diarahkan ke halaman login.
     - Jika registrasi gagal, maka akan menampilkan warning dialog
       ```dart
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (BuildContext context) => const WarningDialog(
             description: "Registrasi gagal, silahkan coba lagi",
           ),
         );
       ```
       
---

3. Proses Login di **Login Page (`login_page.dart`)**
   - Halaman ini digunakan untuk login ke dalam aplikasi
   - State dan Controller digunakan untuk validasi dan membaca input user:
     ```dart
      final _formKey = GlobalKey<FormState>();
      final _emailTextboxController = TextEditingController();
      final _passwordTextboxController = TextEditingController();
     ```
   - User mengisi form login sesuai dengan yang telah diinputkan di form registrasi.
     - Email tidak boleh kosong 
       ```dart
         Widget _emailTextField() {
           return TextFormField(
             decoration: const InputDecoration(labelText: "Email"),
             keyboardType: TextInputType.emailAddress,
             controller: _emailTextboxController,
             validator: (value) {
               if (value!.isEmpty) {
                 return 'Email harus diisi';
               }
               return null;
             },
           );
         }
       ```
     - Password tidak boleh kosong
       ```dart
         Widget _passwordTextField() {
           return TextFormField(
             decoration: const InputDecoration(labelText: "Password"),
             obscureText: true,
             controller: _passwordTextboxController,
             validator: (value) {
               if (value!.isEmpty) {
                 return "Password harus diisi";
               }
               return null;
             },
           );
         }
       ```
   - User mengeklik login. Saat tombol ditekan, semua validator pada form dijalankan. Jika semua input valid dan tidak sedang loading, maka proses login dimulai melalui fungsi `_submit()`.
   - Proses Login di `_submit()` akan memanggil fungsi `LoginBloc.login(...)` yang mengirim request ke API
       ```dart
         void _submit() {
           _formKey.currentState!.save();
           setState(() {
             _isLoading = true;
           });
         
           LoginBloc.login(
             email: _emailTextboxController.text,
             password: _passwordTextboxController.text,
           ).then((value) async {
       ```     
     - Jika login berhasil, token dan userID dari server disimpan melalui `UserInfo` ke penyimpanan lokal (SharedPreferences), lalu `Navigator.pushReplacement` mengganti halaman login dengan `ProdukPage` sehingga user langsung masuk ke daftar produk.
       ```dart
         if (value.code == 200) {
           await UserInfo().setToken(value.token.toString());
           await UserInfo().setUserID(int.parse(value.userID.toString()));
         
           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => const ProdukPage()),
           );
         }
       ```
     - Jika login gagal, aplikasi menampilkan warning
       ```dart
         showDialog(
           context: context,
           barrierDismissible: false,
           builder: (BuildContext context) => const WarningDialog(
             description: "Login gagal, silahkan coba lagi",
           ),
         );
       ```       

---

4. Setelah login berhasil, user akan diarahkan ke **Produk Page (`produk_page.dart`)**
   - Halaman untuk menampilkan daftar produk
   - Di bagian samping, tersedia menu Drawer dengan opsi Logout. Ketika user memilih Logout, aplikasi memanggil:
     ```dart
      await LogoutBloc.logout().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      });
     ```
   - Setiap produk ditampilkan menggunakan widget `ItemProduk`. Produk menggunakan `Card` dan `ListTile`, lalu memakai `GestureDetector` agar bisa diklik. Ketika sebuah item diklik, aplikasi membuka halaman detail produk menggunakan:
     ```dart
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProdukDetail(produk: produk),
        ),
      );
     ```
   - Di bagian kanan AppBar halaman produk terdapat sebuah ikon tanda plus yang berfungsi untuk menambahkan produk baru. Tombol ini dibuat menggunakan `GestureDetector` dan akan diarahkan ke `ProdukForm()`
     ```dart
      GestureDetector(
        child: const Icon(Icons.add, size: 26.0),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProdukForm()),
          );
        },
      )
     ```
     
---

5. **Produk Form (`produk_form.dart`)**
   - Halaman ProdukForm digunakan untuk dua keperluan sekaligus, yaitu menambah produk baru dan mengubah produk yang sudah ada. Ketika halaman pertama kali dibuka, method `initState()` memanggil fungsi `isUpdate()` untuk memastikan apakah halaman sedang digunakan untuk mengubah produk atau membuat produk baru. Jika `widget.produk` berisi data, maka itu berarti pengguna sedang mengedit produk

     ```dart
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
      _namaProdukTextboxController.text = widget.produk!.namaProduk!;
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk.toString();
     ```
     Namun jika `widget.produk` bernilai null, maka ini adalah mode tambah, sehingga judul tetap "Tambah Produk Fauzia" dan tombol berlabel "Simpan".
     
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
       

