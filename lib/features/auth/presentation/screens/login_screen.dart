import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tienda_app/common/widgets/buttons/primary_button.dart';
import 'package:tienda_app/common/widgets/screens/loading_screen.dart';
import 'package:tienda_app/common/widgets/text_fields/primary_text_field.dart';
import 'package:tienda_app/features/auth/presentation/screens/register_screen.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading) {
      return const LoadingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30,),
                
                // 🛍️ NUEVO LOGO UNIFICADO CON EL SPLASH
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_mall_outlined,
                    size: 64,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8,),

                // 🏷️ NUEVO NOMBRE DE LA APP: BAZAR GO
                Text(
                  'BAZAR GO',
                  style: AppTextStyles.textTitleStyle.copyWith(
                    letterSpacing: 3,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 24,),
                PrimaryTextField(
                  hintText: 'Ingresa tu correo electrónico',
                  labelText: 'Correo',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                PrimaryTextField(
                  hintText: 'Ingresa tu contraseña',
                  labelText: 'Contraseña', // ✨ Corregido: 'Contraeña'
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 24,),
                PrimaryButton(
                    onTap: () {
                      if(emailController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El correo no puede estar vacío')));
                        return;
                      }
                      if(passwordController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La contraseña no puede estar vacía')));
                        return;
                      }
                      loginUserWithEmailAndPassword();
                    },
                    text: 'INGRESAR'),
                const SizedBox(height: 40,),
                Text('¿No estás registrado?',
                  style: AppTextStyles.textDescriptionStyle,),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    child: Text('REGISTRARSE', style: AppTextStyles.textButtonStyle,))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUserWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
      
    } on FirebaseAuthException catch(e) {
      SnackBar snackBar = SnackBar(content: Text(e.message ?? 'Error al ingresar'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    }
  }
}