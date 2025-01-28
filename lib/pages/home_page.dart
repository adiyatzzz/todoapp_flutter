import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp_flutter/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List yang menyimpan daftar tugas dalam bentuk [nama_tugas, status_selesai]
  List<List<dynamic>> toDoList = [];

  // Controller untuk menangani input teks pada TextField
  final TextEditingController _controller = TextEditingController();

  // Key untuk menyimpan dan mengambil data dari SharedPreferences
  static const String _key = 'todo_list';

  @override
  void initState() {
    super.initState();
    loadToDoList(); // Saat aplikasi dimulai, muat data dari SharedPreferences
  }

  // Fungsi untuk menyimpan daftar tugas ke SharedPreferences
  Future<void> saveToDoList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList =
        jsonEncode(toDoList); // Ubah List ke format JSON String
    await prefs.setString(
        _key, encodedList); // Simpan JSON ke SharedPreferences
  }

  // Fungsi untuk mengambil daftar tugas dari SharedPreferences
  Future<void> loadToDoList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedList =
        prefs.getString(_key); // Ambil data dari SharedPreferences

    if (encodedList != null) {
      try {
        List<dynamic> decodedList =
            jsonDecode(encodedList); // Decode JSON ke List
        if (decodedList is List) {
          // Pastikan data yang diambil adalah List
          setState(() {
            toDoList =
                decodedList.map((item) => List<dynamic>.from(item)).toList();
            print("Loaded todo list: $toDoList"); // Debugging
          });
        }
      } catch (e) {
        print(
            "Error decoding todo list: $e"); // Tangani error jika JSON tidak valid
      }
    }
  }

  // Fungsi untuk menambahkan tugas baru
  Future<void> saveNewTask() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        toDoList.add([
          _controller.text,
          false
        ]); // Tambah tugas baru dengan status false (belum selesai)
        _controller.clear(); // Kosongkan input setelah ditambahkan
      });
      await saveToDoList(); // Simpan perubahan ke SharedPreferences
    }
  }

  // Fungsi untuk menghapus tugas berdasarkan index
  Future<void> deleteTask(int index) async {
    setState(() {
      toDoList.removeAt(index); // Hapus tugas dari List
    });
    await saveToDoList(); // Simpan perubahan ke SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Center(child: Text('Simple Todo')), // Judul aplikasi
      ),
      body: ListView.builder(
        itemCount: toDoList.length, // Jumlah item yang ditampilkan
        itemBuilder: (context, index) {
          return TodoList(
            taskName: toDoList[index][0], // Nama tugas
            taskCompleted: toDoList[index][1], // Status selesai/tidak selesai
            onChanged: (value) {
              setState(() {
                toDoList[index][1] =
                    !toDoList[index][1]; // Toggle status selesai/tidak selesai
              });
              saveToDoList(); // Simpan perubahan ke SharedPreferences
            },
            deleteFunction: (context) => deleteTask(index), // Hapus tugas
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller:
                    _controller, // Menghubungkan input dengan _controller
                decoration: InputDecoration(
                  hintText: "Add Task", // Placeholder teks input
                  filled: true,
                  fillColor:
                      Colors.deepPurple.shade200, // Warna background input
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed:
                saveNewTask, // Panggil fungsi untuk menambahkan tugas baru
            child: Icon(Icons.add), // Ikon tambah
          )
        ],
      ),
    );
  }
}
