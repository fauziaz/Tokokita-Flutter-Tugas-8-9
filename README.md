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
     <img src="https://github.com/user-attachments/assets/22d65577-88ea-485f-b43a-fee8c2aed1c8" width="360" style="display:inline-block; margin-right:10px;" />
     <img src="https://github.com/user-attachments/assets/76cb19bc-0d21-429c-80c5-919239770cdf" width="360" style="display:inline-block;" />
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
      <p align="center">
        <img src="https://github.com/user-attachments/assets/4988191b-ac0a-42ab-97c5-cdf60dbacc64" width="360" style="display:inline-block; margin-right:10px;" />
        <img src="https://github.com/user-attachments/assets/2dcf9da6-6f03-46d9-8d5b-711cb50c97cb" width="360" style="display:inline-block;" />
      </p>
      
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
      <p align="center">
        <img src="https://github.com/user-attachments/assets/2dcf9da6-6f03-46d9-8d5b-711cb50c97cb" width="360" style="display:inline-block; margin-right:10px;" />
      </p>

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
      <p align="center">
        <img src="https://github.com/user-attachments/assets/1e0e31d7-2f45-4944-b781-c6427eea843c" width="360" style="display:inline-block; margin-right:10px;" />
        <img src="https://github.com/user-attachments/assets/ea1c6087-0af0-4a56-9ce6-41b6aa8c9cc1" width="360" style="display:inline-block;" />
      </p>

   - Halaman ProdukForm digunakan untuk dua keperluan sekaligus, yaitu menambah produk baru dan mengubah produk yang sudah ada. Ketika halaman pertama kali dibuka, method `initState()` memanggil fungsi `isUpdate()` untuk memastikan apakah halaman sedang digunakan untuk mengubah produk atau membuat produk baru. Jika `widget.produk` berisi data, maka itu berarti pengguna sedang mengedit produk

     ```dart
      @override
      void initState() {
        super.initState();
        isUpdate();
      }
      );
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
     - Harga Produk tidak boleh kosong
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
   - Button Simpan/Ubah menyesuaikan mode form melalui variabel `tombolSubmit`.
     ```dart
      OutlinedButton(
        child: Text(tombolSubmit),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate && !_isLoading) {
            if (widget.produk != null) {
              ubah();
            } else {
              simpan();
            }
          }
        },
      )
     ```
     - Jika form valid dan tidak sedang loading:
          - Jika widget.produk != null → panggil ubah()
          - Jika widget.produk == null → panggil simpan()
       Fungsi `simpan()` dan `ubah()` akan memproses data melalui `ProdukBlo`, dan menampilkan dialog peringatan `(WarningDialog)` jika terjadi error. Jika berhasil, halaman akan kembali ke `ProdukPage`.

---

   
6.  Melihat **Produk Detail (`produk_detail.dart`)**
      <p align="center">
        <img src="https://github.com/user-attachments/assets/73f2d521-b978-4730-ad7d-01dec37355fc" width="360" style="display:inline-block; margin-right:10px;" />
        <img src="https://github.com/user-attachments/assets/7aad4dcb-f6e3-43e5-9c35-b158eb0dddcd" width="360" style="display:inline-block;" />
      </p>

      <p align="center">
        <img src="https://github.com/user-attachments/assets/982f1aae-7f9f-4cc6-9a30-a49256655f6e" width="360" style="display:inline-block; margin-right:10px;" />
        <img src="https://github.com/user-attachments/assets/7e17a329-1509-498a-8995-a5ac891c7030" width="360" style="display:inline-block;" />
      </p>

     - Setelah mengisi form, user akan dikembalikan ke halaman `ProdukPage`. Ketika produk diklik, maka akan diarahkan ke halaman detail produk.
     - Detail Produk ditampilkan dalam `Column`, berada di tengah halaman menggunakan `Center`.
       ```dart
         Text(
           "Kode : ${widget.produk!.kodeProduk}",
           style: const TextStyle(fontSize: 20.0),
         ),
         const SizedBox(height: 8.0),
         Text(
           "Nama : ${widget.produk!.namaProduk}",
           style: const TextStyle(fontSize: 18.0),
         ),
         const SizedBox(height: 8.0),
         Text(
           "Harga : Rp. ${widget.produk!.hargaProduk}",
           style: const TextStyle(fontSize: 18.0),
         ),
       ```
     - Jika mengeklik Button Edit, maka akan mengirim `widget.produk` ke form agar textfield otomatis terisi. `ProdukForm` kemudian mengetahui bahwa ini mode ubah, bukan tambah.
       ```dart
         OutlinedButton(
           child: const Text("EDIT"),
           onPressed: () {
             Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) => ProdukForm(
                   produk: widget.produk!,
                 ),
               ),
             );
           },
         ),
       ```
     - Ketika mengeklik Button Delete, akan ditampilkan popup konfirmasi
       ```dart
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        )
       ```
     - Popup Konfirmasi Hapus muncul saat tombol Delete ditekan
       ```dart
         AlertDialog(
           content: const Text("Yakin ingin menghapus data ini?"),
           actions: [
             OutlinedButton(
               child: const Text("Ya"),
               onPressed: () {
                 ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
                   (value) => Navigator.of(context).push(
                     MaterialPageRoute(builder: (context) => const ProdukPage()),
                   ),
                   onError: (error) {
                     showDialog(
                       context: context,
                       builder: (context) => const WarningDialog(
                         description: "Hapus gagal, silahkan coba lagi",
                       ),
                     );
                   },
                 );
               },
             ),
             OutlinedButton(
               child: const Text("Batal"),
               onPressed: () => Navigator.pop(context),
             ),
           ],
         )
       ```
       Pada dialog konfirmasi hapus, terdapat dua pilihan tombol. Jika pengguna menekan tombol "Ya", aplikasi akan memanggil fungsi `ProdukBloc.deleteProduk()` dengan mengirimkan ID produk yang akan dihapus. Apabila proses penghapusan berhasil, aplikasi secara otomatis akan mengarahkan pengguna kembali ke halaman daftar produk `(ProdukPage`) untuk menampilkan data terbaru. Namun, jika proses tersebut gagal, sistem akan menampilkan sebuah `WarningDialog` sebagai pemberitahuan bahwa penghapusan tidak berhasil dan pengguna diminta untuk mencoba kembali. Sementara itu, jika pengguna memilih tombol "Batal", dialog popup akan langsung ditutup tanpa melakukan tindakan apa pun, dan produk tetap tersimpan seperti sebelumnya.
