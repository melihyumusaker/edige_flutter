// ignore_for_file: sized_box_for_whitespace, library_private_types_in_public_api, prefer_typing_uninitialized_variables, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:edige/controllers/LoginController.dart';
import 'package:edige/screens/programDefaultPages/FirstScreen.dart';
import 'package:edige/utils/CustomDecorations.dart';

class ForgetMyPasswordPage extends StatefulWidget {
  var token;
  var email;
  ForgetMyPasswordPage({Key? key, required this.token, required this.email})
      : super(key: key);

  @override
  _ForgetMyPasswordPageState createState() => _ForgetMyPasswordPageState();
}

class _ForgetMyPasswordPageState extends State<ForgetMyPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _passwordsMatch = false;
  bool _allFieldsFilled = false;

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch =
          _newPasswordController.text == _confirmPasswordController.text;
      _checkAllFieldsFilled();
    });
  }

  void _checkAllFieldsFilled() {
    setState(() {
      _allFieldsFilled = _emailController.text.isNotEmpty &&
          _oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkAllFieldsFilled);
    _oldPasswordController.addListener(_checkAllFieldsFilled);
    _newPasswordController.addListener(_checkPasswordsMatch);
    _confirmPasswordController.addListener(_checkPasswordsMatch);
    _emailController.text = widget.email.toString();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Ortak TextField Oluşturma Fonksiyonu
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required double width,
    required enableValue,
    bool obscureText = false,
  }) {
    return Container(
      width: width * 0.9, // Ekran genişliğinin %90'ı kadar olacak
      child: TextField(
        enabled: enableValue,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Köşeleri yuvarla
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade400, // Pasif durumda kenarlık rengi
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(
                  255, 214, 99, 240), // Aktif durumda kenarlık rengi
            ),
          ),
        ),
        obscureText: obscureText,
      ),
    );
  }

  // Şifre Kontrol Mesajı
  Widget _buildPasswordMatchRow(double width) {
    return Container(
      width: width * 0.9,
      child: Row(
        children: [
          if (_passwordsMatch)
            const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            _passwordsMatch ? 'Şifreler aynı' : '',
            style: TextStyle(
              color: _passwordsMatch ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Şifremi Sıfırla Butonu
  Widget _buildResetButton(double width) {
    return Container(
      width: width * 0.6, // Genişlik ekranın %60'ı kadar olacak
      height: 50, // Sabit yükseklik
      decoration: BoxDecoration(
        gradient: _allFieldsFilled && _passwordsMatch
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 214, 99, 240),
                  Color.fromARGB(255, 162, 211, 123),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.grey.shade400,
                  Colors.grey.shade300,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: _allFieldsFilled && _passwordsMatch
            ? () async {
                final responseMessage = await Get.find<LoginController>()
                    .forgetMyPassword(
                        _oldPasswordController.text,
                        _confirmPasswordController.text,
                        _emailController.text,
                        widget.token);

                // Cevabı kullanıcıya göster
                Get.snackbar(
                  'Şifre Sıfırlama',
                  responseMessage,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: responseMessage.contains('başarıyla')
                      ? Colors.green
                      : Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );

                if (responseMessage.contains('başarıyla')) {
                const  Duration(seconds: 2);
                  Get.to(() =>const FirstScreen(),
                  transition: Transition
                      .rightToLeft);
                }
              }
            : null,
        borderRadius: BorderRadius.circular(16),
        child: const Center(
          child: Text(
            'Şifremi Sıfırla',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Şifremi Değiştir',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 214, 99, 240),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: CustomDecorations.buildGradientBoxDecoration(
              const Color.fromARGB(255, 214, 99, 240),
              const Color.fromARGB(255, 162, 211, 123)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _buildTextField(
                  enableValue: false,
                  label: 'Email',
                  controller: _emailController,
                  icon: Icons.mail,
                  width: screenWidth),
              const SizedBox(height: 16),
              _buildTextField(
                  enableValue: true,
                  label: 'Eski Şifre',
                  controller: _oldPasswordController,
                  width: screenWidth,
                  icon: Icons.lock,
                  obscureText: true),
              const SizedBox(height: 16),
              _buildTextField(
                  enableValue: true,
                  label: 'Yeni Şifre',
                  controller: _newPasswordController,
                  width: screenWidth,
                  icon: Icons.lock_open,
                  obscureText: true),
              const SizedBox(height: 16),
              _buildTextField(
                  enableValue: true,
                  label: 'Yeni Şifre (Tekrar)',
                  controller: _confirmPasswordController,
                  width: screenWidth,
                  icon: Icons.lock_open_rounded,
                  obscureText: true),
              const SizedBox(height: 16),
              _buildPasswordMatchRow(screenWidth),
              const SizedBox(height: 24),
              _buildResetButton(screenWidth),
            ],
          ),
        ),
      ),
    );
  }
}
